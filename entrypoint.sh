#!/bin/bash

echo "v3.20.25-novnc"

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


echo "Configuring VNC server for user: $USERNAME"

# Create VNC password file
mkdir -p /home/"$USERNAME"/.vnc
echo "$PASSWORD" | x11vnc -storepasswd -rfbauth /home/"$USERNAME"/.vnc/passwd
chown -R "$USERNAME:$USERNAME" /home/"$USERNAME"/.vnc
chmod 600 /home/"$USERNAME"/.vnc/passwd

# Start x11vnc with the specified password and display :0
echo "Starting x11vnc..."
x11vnc -forever -usepw -shared -rfbauth /home/"$USERNAME"/.vnc/passwd -display :0 &

# Start noVNC
echo "Starting noVNC..."
/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &
echo "Starting VNC server..."
sudo -u "$USERNAME" vncserver :1 -geometry 1280x800 -depth 24

# FLAG_FILE="/home/$USERNAME/.config/org.mysteriumnetwork.setup_done"
#
# if [ -f "$FLAG_FILE" ]; then
#   echo "Mystery Network setup has already been completed. Skipping installation."
# else
#   echo "Running Mystery Network installation script..."
#   sudo -E bash -c "$(curl -s https://raw.githubusercontent.com/mysteriumnetwork/node/master/install.sh)"
#   mkdir -p "$(dirname "$FLAG_FILE")"
#   touch "$FLAG_FILE"
#   echo "Mystery Network installation completed successfully."
# fi

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

tail -f /dev/null
