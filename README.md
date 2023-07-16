# Raspberry Pi Cloud Setup

## Description

This guide provides step-by-step information to set up following services on a *Raspberry Pi 4 B+*:

|Service|Purpose|
|---|---|
|[SSH](https://www.raspberrypi.com/software/)|Accessing the command line from other devices|
|[Docker](https://github.com/docker)|Run sandboxed applications and servers|
|[PiHole](https://github.com/pi-hole/pi-hole)|DNS with blacklists for ads (like hosts file for Windows)|
|[OpenVPN](https://github.com/OpenVPN/openvpn3)|VPN service to connect with other clients|
|[Dynamic DNS](https://github.com/troglobit/inadyn)|Exposing the VPN connection to the internet<br>so connection becomes possible from anywhere|
|[Samba](https://github.com/samba-team/samba)|Network storage for easy file system access|

## Installing the OS

Download and install [Raspberry Pi Imager](https://www.raspberrypi.com/software/). Run the installer. Insert the SD card and choose it in the UI. Choose an OS pick
```
Raspberry Pi OS (Other)
```
```
Raspberry Pi OS Lite (64-bit)
```
In the main menu hit the `Settings icon` on the bottom right. Use the settings in the image below. Skip the wireless connection setting if you are going to connect the Pi to your router via a LAN cable, which is recommended for this.

After that you can hit write. Once that is done, insert the SD card in your Pi and put some power on it.

<img src="https://user-images.githubusercontent.com/40058557/253777732-eb1aaa18-0cd0-4074-b1d2-5ff31f3a26d3.png" width="200"/> <img src="https://user-images.githubusercontent.com/40058557/253777772-a9296563-6efa-45d8-8b36-41d7faad29e2.png" width="200"/> <img src="https://user-images.githubusercontent.com/40058557/253777782-2abeff9c-8e97-49a5-947b-2baf3aeb42c6.png" width="200"/> <img src="https://user-images.githubusercontent.com/40058557/253777820-b09cad30-0fca-459c-a5ed-c501f86adc1a.png" height="135"/> <img src="https://user-images.githubusercontent.com/40058557/253777868-e832d1a3-bcc7-44cd-b45f-d3fa4e1bda54.png" width="200"/>

## Connecting via SSH

The connection via SSH works through a terminal. There are many programs out there, but I recommend using [Terminal from Microsoft Store](https://apps.microsoft.com/store/detail/9N0DX20HK701?hl=en-us&gl=US).

Once the Pi is booted up, open *Terminal* and type:

```
ssh pi@npi
```
```
Are you sure you want to continue connecting?
```
Type yes and enter password. The username and host will appear in green lettering, indicating that you are inside the Pi's command line. Every command you type now, will be directly executed on the Raspberry Pi.

![image](https://user-images.githubusercontent.com/40058557/253778056-3aadfb7c-8947-4db4-ad97-867e25b46ee2.png)

If you disconnect or close the window, the session will be lost. You can reconnect by typing `ssh pi@npi` in Terminal again.

## Accessing Raspberry Pi Home Folder from PC via Samba

Install Samba:
```
sudo apt-get install -y samba
```
Create the configuration file:
```
sudo nano /etc/samba/smb.conf
```
Scroll all the way down with arrow keys. Copy and paste the following at the end of the file:

```ini
[NPiHome]
 comment=NPiHome
 path=/home/pi
 browseable=yes
 writeable=yes
 only guest=no
 create mask=0740
 directory mask=0750
 public=no
```

Press `CTRL+X` and `Y` and `Enter` to save the file.

A Samba user needs to be created:
```
sudo smbpasswd -a pi
```
Enter a password twice. You can pick the same password as your login password.

Go to "This PC" in MS Explorer. Right click anywhere on the free spot and click `Add a new network location`.

<img src="https://user-images.githubusercontent.com/40058557/253781561-288d40e8-17c6-4779-9e5a-d65c12a2f250.png" width="200"/>

Use the following network address:
```
\\npi\home
```

And the Samba credentials to connect to the Raspberry Pi Home folder directly via your explorer.

<img src="https://user-images.githubusercontent.com/40058557/253802475-303f7efd-d412-44c0-940b-1b352ad8ffe9.png" width="200"/>

## Docker Installation

There is an [official Docker guide](https://docs.docker.com/engine/install/raspbian/). But we are going to use [snap](https://snapcraft.io/install/docker/raspbian) to install Docker. Run following commands in order:

```
sudo apt update
sudo apt install -y snapd
```
```
sudo reboot
```
Connect to your Pi via SSH again.
```
sudo snap install core
```
Install Docker
```
sudo snap install docker
```
Add the Docker to group, so we don't need to type sudo every time.
```
sudo groupadd docker
```
```
sudo usermod -aG docker $USER
```
```
newgrp docker
```
```
sudo chmod 666 /var/run/docker.sock
```
Verify installation. It should show the version and build number.
```
docker -v
```

## Create a Dynamic DNS Account

The VPN server needs a dynDNS address, so you can connect form anywhere. There are many dynDNS hosters out there. We will use deSEC. [Create an account here.](https://desec.io/?domainType=dynDNS)

During the registration pick `Register a new domain under dedyn.io`. After verifying your mail address you can click "Configure Your Router" to see the settings:

```
URL: https://update.dedyn.io/
URL for IPv6: https://update.dedyn.io/?myipv4=<ipaddr>&myipv6=<ip6addr>
Domain: ***.dedyn.io
Username: ***.dedyn.io
Password: ********
```

<img src="https://user-images.githubusercontent.com/40058557/253817906-5c34dfcb-8e81-4dbe-9413-9508838397a3.png" width="200">

## Clone this Repo

```
sudo apt-get install git
```
```
git clone https://github.com/neko-js/rpi-cloud
```










