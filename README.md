# samba.sh
Setup Samba in one bash script.

It only works on Ubuntu currently.

## Usage
* Get names of interfaces

```
ip addr

// Output:
1. lo: ....
2. eno1: ...
```

Record the interfaces to bind with Samba.

* Modify `samba.sh` before run

```bash
# -------------------- #
# Variables
# -------------------- #
# Server name
server_name="server"

# Server data dir
data_dir="/data/samba"

# Interfaces to bind
# Run `ip addr` or `ip link` to check interfaces.
interfaces=( lo eno1 )

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
