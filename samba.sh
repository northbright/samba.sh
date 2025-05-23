#!/bin/bash

# How to use
# 1. Edit below variables.
# 2. Run this script with `sudo`: sudo ./samba.sh

# -------------------- #
# Variables
# -------------------- #

# Server name
server_name="server"

# Server data dir
# It'll create per-user data dir under this dir when creating users.
# e.g. /data/samba/ppt and /data/samba/my
data_dir="/data/samba"

# Interface to bind
# Run `ip addr` or `ip link` to check interfaces.
interface="eno1"

# Samba users. Use space as separator.
users=( ppt my )

# Passwords of users
# You may change the password by running `sudo smbpasswd -U <USER>` after running this script.
declare -A passwords
passwords[ppt]="password_for_ppt"
passwords[my]="password_for_my"

# Samba shares(names) of users
declare -A shares
shares[ppt]="ppt"
shares[my]="share"

# ufw Firewall allow ports
ufw_allows=( ssh samba )

# -------------------- #
# Scripts
# -------------------- #

# Install packages.
apt update && apt install vim ufw samba -y

# Samba settings

# Backup smb.conf
cp /etc/samba/smb.conf /etc/samba/smb.conf.bk

# Create /etc/samba/smb.conf
cat <<EOF > /etc/samba/smb.conf
[global]
    workgroup = WORKGROUP
    server string = $server_name
    server role = standalone server

    # Bind ethernet interface
    # e.g. interfaces = lo enp1s0f0 enp1s0f1
    interfaces = lo $interface
    bind interfaces only = yes

    # Disable NetBIOS server(optional)
    disable netbios = no

    smb ports = 445
    log file = /var/log/samba/smb.log
    max log size = 1000
    log level = 3 passdb:5 auth:5

    # Xiaomi TV supports SMB1 only.
    # Add SMB1 protocol(optional).
    client min protocol = NT1
    server min protocol = NT1
EOF

# Create Samba data dir.
mkdir -p $data_dir
chown :sambashare $data_dir

# Create users and Samba shares.
for user in "${users[@]}"; do
  echo "creating user: $user..."
  
  # Create data dir for user.
  mkdir -p $data_dir/$user

  # Create user.
  adduser --disabled-password --gecos "" \
    --home $data_dir/$user \
    --no-create-home \
    --shell /usr/sbin/nologin \
    --ingroup sambashare $user

  # Set ownership and permissions of user's home.
  chown $user:sambashare $data_dir/$user
  chmod 2770 $data_dir/$user

  # Set password for samba user and enable the user.
  pass=${passwords[$user]}
  (echo "$pass"; echo "$pass") | smbpasswd -s -a $user
  smbpasswd -e $user

  # Create Samba share
  share=${shares[$user]}

cat <<EOF >> /etc/samba/smb.conf

[$share]
  path = /data/samba/$user
  browseable = yes
  read only = no
  force create mode = 0660
  force directory mode = 2770
  valid users = $user    
EOF

done

# Firewall Settings
ufw default deny incoming
ufw default allow outgoing

# Set allow ports.
for port in "${ufw_allows[@]}"; do
  ufw allow $port
done

ufw --force enable
ufw status verbose

# Start(restart) Samba service
echo -ne "\n" | testparm
systemctl enable smbd.service
systemctl restart smbd.service
systemctl status smbd.service
