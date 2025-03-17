# Use the official Ubuntu 24.04 base image
FROM ubuntu:24.04

# Set environment variable to suppress interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Preconfigure keyboard layout to English (US)
RUN echo 'keyboard-configuration keyboard-configuration/layoutcode select us' | debconf-set-selections

# Update system packages and upgrade installed software
RUN apt-get update -y && apt-get upgrade -y

# Install XFCE desktop environment and related tools
RUN apt-get install -y xfce4 xfce4-goodies xfce4-notifyd xfce4-whiskermenu-plugin xfce4-netload-plugin xfce4-cpufreq-plugin

# Install X11 server, XRDP, and additional utilities
RUN apt-get install -y xorg dbus-x11 x11-xserver-utils xrdp sudo htop wget curl nano gnupg gdebi iproute2 net-tools dialog

# Install dependencies required by the Wipter application
RUN apt-get install -y libgtk-3-0t64 libgtk-3-bin libnotify4 libnotify-bin libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0t64 libuuid1 libsecret-1-0 libappindicator3-1

# Install dependencies required by the UpRock application
RUN apt-get install -y libc6 libwebkit2gtk-4.1-0

# Download and install the Wipter application from the official source
RUN wget -O /tmp/wipter-app-amd64.deb https://provider-assets.wipter.com/latest/linux/x64/wipter-app-amd64.deb && \
    gdebi --n /tmp/wipter-app-amd64.deb && \
    rm /tmp/wipter-app-amd64.deb

# Download and install the UpRock application from the official source
RUN wget -O /tmp/UpRock-Mining-v0.0.8.deb https://edge.uprock.com/v1/app-download/UpRock-Mining-v0.0.8.deb && \
    gdebi --n /tmp/UpRock-Mining-v0.0.8.deb && \
    rm /tmp/UpRock-Mining-v0.0.8.deb

# Download and install the Nomachine application from the official source
RUN wget -O /tmp/nomachine_8.16.1_1_amd64.deb https://download.nomachine.com/download/8.16/Linux/nomachine_8.16.1_1_amd64.deb && \
    gdebi --n /tmp/nomachine_8.16.1_1_amd64.deb && \
    rm /tmp/nomachine_8.16.1_1_amd64.deb

# Configure a passwordless default keyring to avoid authentication prompts
RUN mkdir -p /root/.local/share/keyrings && \
    touch /root/.local/share/keyrings/default.keyring && \
    echo -n "" > /root/.local/share/keyrings/default.keyring

# Clean up unnecessary packages and cache to reduce image size
RUN apt-get autoclean && apt-get autoremove -y && apt-get autopurge -y

# Configure XRDP to launch the XFCE desktop environment by default
RUN echo "startxfce4" > /etc/skel/.xsession

# Expose the XRDP service port
EXPOSE 3389

# Copy entrypoint script to the image and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint script as the default command to run at container startup
CMD ["/entrypoint.sh"]
