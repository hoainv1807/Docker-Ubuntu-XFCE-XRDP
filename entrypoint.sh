#!/bin/bash

echo "v3.18.25"

if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "ERROR: USERNAME and PASSWORD environment variables are not set." >&2
  exit 1
fi

if id -u "$USERNAME" >/dev/null 2>&1; then
  echo "User $USERNAME already exists. Skipping user creation."
else
  echo "Creating user: $USERNAME"
  useradd -m -s /bin/bash "$USERNAME"
  echo "$USERNAME:$PASSWORD" | chpasswd
  echo "User $USERNAME created successfully."
  usermod -aG sudo "$USERNAME"
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  echo "xfce4-session" > /home/"$USERNAME"/.xsession
  chown -R "$USERNAME:$USERNAME" /home/"$USERNAME"
  echo "Configured permissions for user: $USERNAME"
  echo "Configuring passwordless keyring for user: $USERNAME"
  mkdir -p /home/"$USERNAME"/.local/share/keyrings
  touch /home/"$USERNAME"/.local/share/keyrings/default.keyring
  echo -n "" > /home/"$USERNAME"/.local/share/keyrings/default.keyring
  chown -R "$USERNAME:$USERNAME" /home/"$USERNAME"/.local/share/keyrings
  echo "Passwordless keyring configured successfully for user: $USERNAME"
fi

if [ -z "$P2P_EMAIL" ]; then
  echo "P2P_EMAIL is not set or is blank. Skipping creation of the Peer2Profit configuration file."
else
  FLAG_FILE="/home/$USERNAME/.config/org.peer2profit.setup_done"

  if [ -f "$FLAG_FILE" ]; then
    echo "Peer2Profit configuration file has already been created. Skipping."
  else
    INSTALL_ID2=$(uuidgen)
    CONFIG_FILE="/home/$USERNAME/.config/org.peer2profit.peer2profit.ini"
    CONFIG_DIR=$(dirname "$CONFIG_FILE")
    mkdir -p "$CONFIG_DIR"
    cat <<EOF > "$CONFIG_FILE"
[General]
Username=$P2P_EMAIL
hideToTrayMsg=true
installid2=$INSTALL_ID2
locale=en_US
EOF

    chown -R "$USERNAME:$USERNAME" "$CONFIG_DIR"

    # Create the flag file to mark the script as completed
    touch "$FLAG_FILE"
    echo "Peer2Profit configuration file created successfully at $CONFIG_FILE."
  fi
fi

echo "Forcefully killing any running XRDP services..."
pkill -9 xrdp-sesman 2>/dev/null
pkill -9 xrdp 2>/dev/null
echo "XRDP services terminated (if they were running)."

if [ -f /var/run/xrdp/xrdp-sesman.pid ]; then
  rm -f /var/run/xrdp/xrdp-sesman.pid
fi


echo "Starting SSH service..."
service ssh restart

echo "Starting XRDP services..."
/usr/sbin/xrdp-sesman &
exec /usr/sbin/xrdp -nodaemon

# Keep the container running (optional, if needed)
tail -f /dev/null
