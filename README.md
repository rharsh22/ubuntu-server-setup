# Ubuntu Server Auto-Configuration

This script automatically configures a production-grade Ubuntu server with:
- Auto-login (no password needed)
- WiFi auto-connect
- SSH auto-start
- Lid close ignore (for laptop servers)
- Fast boot (60 seconds)

## Usage

```bash
sudo chmod +x server-setup.sh
sudo ./server-setup.sh
```

## What it configures

- getty auto-login for harsh-lab user
- wpa_supplicant for WiFi
- SSH server
- systemd lid handling
- Disables networkd-wait-online (removes 2-3 min delay)

## Author
harsh-lab (DevOps Learning)


### Setup System Resource Alerts with monit 
https://oneuptime.com/blog/post/2026-03-02-how-to-set-up-system-resource-alerts-with-monit-on-ubuntu/view
