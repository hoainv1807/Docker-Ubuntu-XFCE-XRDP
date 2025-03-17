#!/bin/bash
# Entry point script for runtime user creation

# Ensure USERNAME and PASSWORD are set
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "ERROR: USERNAME and PASSWORD environment variables are not set." >&2
  exit 1
fi

# Check if the user already exists
if id -u "$USERNAME" >/dev/null 2>&1; then
  echo "User $USERNAME already exists. Skipping user creation."
else
  # Create the user and configure it
  echo "Creating user: $USERNAME"
  useradd -m -s /bin/bash "$USERNAME"
  echo "$USERNAME:$PASSWORD" | chpasswd
  echo "User $USERNAME created successfully."

  # Configure user permissions
  usermod -aG sudo "$USERNAME"
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  echo "xfce4-session" > /home/"$USERNAME"/.xsession
  chown -R "$USERNAME:$USERNAME" /home/"$USERNAME"
  echo "Configured permissions for user: $USERNAME"

  # Set up a passwordless default keyring for the user
  echo "Configuring passwordless keyring for user: $USERNAME"
  mkdir -p /home/"$USERNAME"/.local/share/keyrings
  touch /home/"$USERNAME"/.local/share/keyrings/default.keyring
  echo -n "" > /home/"$USERNAME"/.local/share/keyrings/default.keyring
  chown -R "$USERNAME:$USERNAME" /home/"$USERNAME"/.local/share/keyrings
  echo "Passwordless keyring configured successfully for user: $USERNAME"
fi

# Kill any running XRDP services as a fail-safe
echo "Forcefully killing any running XRDP services..."
pkill -9 xrdp-sesman 2>/dev/null
pkill -9 xrdp 2>/dev/null
echo "XRDP services terminated (if they were running)."

if [ -f /var/run/xrdp/xrdp-sesman.pid ]; then
    rm -f /var/run/xrdp/xrdp-sesman.pid
fi

# Start XRDP services with logs
echo " IM NEW "
echo "Starting XRDP services..."
/usr/sbin/xrdp-sesman &
exec /usr/sbin/xrdp -nodaemon
