# Use Ubuntu 18.04 as the base image
FROM ubuntu:18.04

# Set up environment variables (optional)
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt update && apt install -y \
    wget \
    curl \
    vim \
    neovim \
    gcc \
    make \
    libssl-dev \
    pkg-config \
    libxml2-dev \
    zlib1g-dev \
    openvpn \
    iproute2 \
    iptables \
    openssh-server \
    vpnc-scripts \
    && rm -rf /var/lib/apt/lists/*

# Download OpenConnect v8.00
WORKDIR /tmp
RUN wget ftp://ftp.infradead.org/pub/openconnect/openconnect-8.00.tar.gz && \
    tar zxvf openconnect-8.00.tar.gz && \
    cd openconnect-8.00 && \
    ./configure --disable-nls --prefix=/usr --with-vpnc-script=/usr/share/vpnc-scripts/vpnc-script && \
    make && \
    make install


# Setup SSH server
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22

# Set up SSH directory for root user and correct permissions
RUN mkdir /root/.ssh && \
    touch /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys

# Set the ENTRYPOINT to OpenConnect with the given command
ENTRYPOINT echo $VPN_PASSWORD_BASE64 | base64 -d > /tmp/auth.txt && \
    (/usr/sbin/openconnect --protocol=gp $VPN_SERVER --user=$VPN_USERNAME --passwd-on-stdin < /tmp/auth.txt &) && \
    /usr/sbin/sshd -D
