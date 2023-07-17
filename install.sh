#!/bin/bash

# Check if the script is running with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Set up screen
apt-get install -y screen
echo "caption always "%{= kw}%-w%{= kG}%{+b}[%n %t]%{-b}%{= kw}%+w %= [%l] %0c:%s %{-}"
startup_message off" >> .screenrc

# Setting up Samba home folder
apt-get install -y samba

# Add Samba configuration for home folder
echo "[picloud-home]
 comment=picloud-home
 path=/home/pi
 browseable=yes
 writeable=yes
 only guest=no
 create mask=0740
 directory mask=0750
 public=no" >> /etc/samba/smb.conf

# Set Samba user
smbpasswd -a pi

echo "Samba configuration finished."

# Install Docker
snap install core docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
sudo chmod 666 /var/run/docker.sock
docker -v
docker run hello-world
