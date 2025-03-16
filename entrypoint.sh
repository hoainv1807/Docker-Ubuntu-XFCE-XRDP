#!/bin/bash
# Entry point script for runtime user creation and root filesystem persistence

# Ensure USERNAME and PASSWORD are set
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "ERROR: USERNAME and PASSWORD environment variables are not set." >&2
  exit 1
fi

# Check if the persistent volume is mounted
if [ ! -d "/persistent" ]; then
  echo "ERROR: Persistent volume is not mounted at /persistent." >&2
  exit 1
fi

# Perform the initial sync of the root filesystem to the persistent volume if necessary
if [ ! -f "/persistent/.initialized" ]; then
  echo "Syncing root filesystem to persistent volume..."
  rsync -a --exclude=/persistent --exclude=/proc --exclude=/sys --exclude=/dev / /persistent
  touch /persistent/.initialized
fi

# Mount the persistent volume to root
echo "Mounting persistent volume to root..."
mount --bind /persistent /

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
fi

# Start XRDP services with logs
echo "Starting XRDP services..."
/usr/sbin/xrdp-sesman &
exec /usr/sbin/xrdp -nodaemon
