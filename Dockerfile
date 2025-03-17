# Use the official Debian base image
FROM ubuntu:24.04

# Set environment variables to disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Preconfigure keyboard layout to English (US)
RUN echo 'keyboard-configuration keyboard-configuration/layoutcode select us' | debconf-set-selections

# Update and install necessary packages
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y xfce4 xfce4-goodies xfce4-notifyd xfce4-whiskermenu-plugin xfce4-netload-plugin xfce4-cpufreq-plugin
RUN apt-get install -y xorg dbus-x11 x11-xserver-utils xrdp sudo htop wget curl nano gnupg gdebi iproute2 net-tools dialog

# Add additional dependencies required by the Wipter app
RUN apt-get install -y libgtk-3-0t64 libgtk-3-bin libnotify4 libnotify-bin libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0t64 libuuid1 libsecret-1-0 libappindicator3-1

# Download and install the Wipter app
RUN wget -O /tmp/wipter-app-amd64.deb https://provider-assets.wipter.com/latest/linux/x64/wipter-app-amd64.deb && \
    gdebi --n /tmp/wipter-app-amd64.deb && \
    rm /tmp/wipter-app-amd64.deb

# Configure a default passwordless keyring
RUN mkdir -p /root/.local/share/keyrings && \
    touch /root/.local/share/keyrings/default.keyring && \
    echo -n "" > /root/.local/share/keyrings/default.keyring

# Clean Up
RUN apt-get autoclean && apt-get autoremove -y && apt-get autopurge -y

# Configure XRDP
RUN echo "startxfce4" > /etc/skel/.xsession

# Expose XRDP port
EXPOSE 3389

# Add a script to dynamically create the user and set up XRDP at runtime
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run the entry point script
CMD ["/entrypoint.sh"]
