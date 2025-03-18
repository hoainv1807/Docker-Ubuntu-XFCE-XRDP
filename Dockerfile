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
RUN apt-get install -y xorg dbus-x11 x11-xserver-utils xrdp sudo htop wget curl nano gnupg gdebi iproute2 net-tools dialog util-linux uuid-runtime

# Install dependencies required by the Wipter application
RUN apt-get install -y libgtk-3-0t64 libgtk-3-bin libnotify4 libnotify-bin libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0t64 libuuid1 libsecret-1-0 libappindicator3-1

# Install dependencies required by the Peer2Profit application
RUN apt-get install -y  libxcb-glx0 libx11-xcb1 libxcb-icccm4 libxcb-image0 libxcb-shm0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-sync1 libxcb-xfixes0 libxcb-render0 libxcb-shape0 libxcb-xinerama0 libxcb-xkb1 libxcb1 libx11-6 libxkbcommon-x11-0  libxkbcommon0  libgl1 libxcb-util1 libxau6 libxdmcp6 libbsd0

# Download and install the Wipter application from the official source
RUN wget -O /tmp/wipter-app-amd64.deb https://provider-assets.wipter.com/latest/linux/x64/wipter-app-amd64.deb && \
    gdebi --n /tmp/wipter-app-amd64.deb && \
    rm /tmp/wipter-app-amd64.deb

# Download and install the Peer2Profit application from the official source
RUN wget -O /tmp/peer2profit_0.48_amd64.deb https://updates.peer2profit.app/peer2profit_0.48_amd64.deb && \
    gdebi --n /tmp/peer2profit_0.48_amd64.deb && \
    rm /tmp/peer2profit_0.48_amd64.deb

# Install Brave browser using the installation script
RUN curl -fsS https://dl.brave.com/install.sh | sh

# Configure a passwordless default keyring to avoid authentication prompts
RUN mkdir -p /root/.local/share/keyrings && \
    touch /root/.local/share/keyrings/default.keyring && \
    echo -n "" > /root/.local/share/keyrings/default.keyring

# Install OpenSSH Server and move it to 22222
RUN apt-get install -y openssh-server
RUN sed -i 's/#Port 22/Port 22222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config && \
    echo "ListenAddress ::" >> /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd

# Clean up unnecessary packages and cache to reduce image size
RUN apt-get autoclean && apt-get autoremove -y && apt-get autopurge -y

# Configure XRDP to launch the XFCE desktop environment by default
RUN echo "startxfce4" > /etc/skel/.xsession

# Expose the XRDP service port
EXPOSE 3389 22222

# Copy entrypoint script to the image and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint script as the default command to run at container startup
CMD ["/entrypoint.sh"]
