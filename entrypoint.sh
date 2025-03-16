#!/bin/bash
# Entry point script for runtime user creation

# Ensure USERNAME and PASSWORD are set
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "ERROR: USERNAME and PASSWORD environment variables are not set."
  exit 1
fi

# Create the user and configure it
useradd -m -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd
usermod -aG sudo "$USERNAME"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
echo "xfce4-session" > /home/"$USERNAME"/.xsession
chown -R "$USERNAME:$USERNAME" /home/"$USERNAME"

# Start XRDP services
/usr/sbin/xrdp-sesman &
exec /usr/sbin/xrdp -nodaemon

