# samba.sh
Setup Samba in one bash script.

It only works on Ubuntu currently.

## Usage
* Modify `samba.sh` before run
  * netplan settings(static IP)
  * Set server name(default: `server`)
  * Data dir(default: `/data/samba`)
    It'll create per-user data dir under data dir(e.g. `/data/samba/ppt` and `/data/samba/my`)
  * Bind interfaces(run `ip addr` or `ip link` to determine which interfaces to bind)
  * User names and passwords(may be changed by `sudo smbpasswd -U <USER>` later)
  * Samba shares of users
  * Allowed ports of ufw firewall(default: `ssh samba`)

```bash
# netplan settings
ip="10.0.10.3/24"
gateway="10.0.10.1"
dns1="223.5.5.5"
dns2="223.6.6.6"

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
```

* Run `samba.sh` with `sudo`

```bash
sudo ./samba.sh
```

## License
* [MIT License](LICENSE)
