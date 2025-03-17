#!/bin/bash
# Entry point script for runtime user creation

# Ensure USERNAME and PASSWORD are set
# Verifies that the required environment variables are set; exits with an error if either is missing
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "ERROR: USERNAME and PASSWORD environment variables are not set." >&2
  exit 1
fi

# Check if the user already exists
# Determines if the user account specified by $USERNAME already exists in the system
if id -u "$USERNAME" >/dev/null 2>&1; then
  echo "User $USERNAME already exists. Skipping user creation."
else
  # Create the user and configure it
  # Creates a new user with a home directory and sets the shell to Bash
  echo "Creating user: $USERNAME"
  useradd -m -s /bin/bash "$USERNAME"

  # Sets the password for the new user
  echo "$USERNAME:$PASSWORD" | chpasswd
  echo "User $USERNAME created successfully."

  # Configure user permissions
  # Adds the user to the 'sudo' group for administrative privileges
  usermod -aG sudo "$USERNAME"
  
  # Grants the user passwordless sudo access by appending to the sudoers file
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

  # Sets up XFCE as the default desktop session
  echo "xfce4-session" > /home/"$USERNAME"/.xsession
  
  # Ensures correct ownership of the home directory and its contents
  chown -R "$USERNAME:$USERNAME" /home/"$USERNAME"
  echo "Configured permissions for user: $USERNAME"

  # Set up a passwordless default keyring for the user
  # Configures a keyring file for the user to avoid password prompts for certain services
  echo "Configuring passwordless keyring for user: $USERNAME"
  mkdir -p /home/"$USERNAME"/.local/share/keyrings
  touch /home/"$USERNAME"/.local/share/keyrings/default.keyring
  echo -n "" > /home/"$USERNAME"/.local/share/keyrings/default.keyring
  chown -R "$USERNAME:$USERNAME" /home/"$USERNAME"/.local/share/keyrings
  echo "Passwordless keyring configured successfully for user: $USERNAME"
fi

# Kill any running XRDP services as a fail-safe
# Stops any currently running XRDP services to prevent conflicts during restart
echo "Forcefully killing any running XRDP services..."
pkill -9 xrdp-sesman 2>/dev/null # Forcefully terminates xrdp-sesman if running
pkill -9 xrdp 2>/dev/null       # Forcefully terminates xrdp if running
echo "XRDP services terminated (if they were running)."

# Removes stale XRDP session manager PID file if it exists
if [ -f /var/run/xrdp/xrdp-sesman.pid ]; then
    rm -f /var/run/xrdp/xrdp-sesman.pid
fi

# Start XRDP services with logs
# Begins XRDP services, ensuring they run in the foreground
echo " IM NEW " # Placeholder message to confirm script edits or versioning
echo "Starting XRDP services..."
/usr/sbin/xrdp-sesman &         # Launches xrdp session manager in the background
exec /usr/sbin/xrdp -nodaemon   # Starts XRDP in no-daemon mode for logging
