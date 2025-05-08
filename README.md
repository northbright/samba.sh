# samba.sh
Setup Samba in one bash script.

It only works on Ubuntu currently.

## Usage
* Set variables in `samba.sh`

```bash
# -------------------- #
# Variables
# -------------------- #
# Server name
server_name="server"

# Server data dir
data_dir="/data/samba"

# Ethernet interfaces to bind
interfaces=( lo eno1 )

# Samba users. Use space as separator.
users=( ppt my )

# Passwords of users
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
