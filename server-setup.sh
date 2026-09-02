#!/bin/bash

echo "🔧 Restoring production server settings..."

# 1. Auto-login configuration
echo "Setting up auto-login..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
sudo bash -c 'cat > /etc/systemd/system/getty@tty1.service.d/override.conf << EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin harsh-lab --noclear %I $TERM
EOF'

# 2. Lid close settings
echo "Configuring lid behavior..."
sudo bash -c 'cat >> /etc/systemd/logind.conf << EOF
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF'

# 3. WiFi configuration
echo "Ensuring WiFi config exists..."
if [ ! -f /etc/wpa_supplicant/wpa_supplicant-wlo1.conf ]; then
    sudo wpa_passphrase "Redrosemote12" "RRequest2" | sudo tee /etc/wpa_supplicant/wpa_supplicant-wlo1.conf
fi

# 4. Enable all required services
echo "Enabling system services..."
sudo systemctl daemon-reload
sudo systemctl enable getty@tty1.service
sudo systemctl enable wpa_supplicant@wlo1.service
sudo systemctl enable ssh
sudo systemctl enable systemd-logind.service

# 5. Disable problematic services
echo "Disabling conflicting services..."
sudo systemctl disable systemd-networkd-wait-online.service 2>/dev/null
sudo systemctl mask systemd-networkd-wait-online.service 2>/dev/null
sudo systemctl disable systemd-networkd 2>/dev/null

# 6. Apply changes
echo "Applying all changes..."
sudo systemctl restart systemd-logind

echo ""
echo "✅ DONE! Production settings restored!"
echo ""
echo "Verify settings:"
echo "  getty (auto-login): $(sudo systemctl is-enabled getty@tty1.service)"
echo "  WiFi (wpa_supplicant): $(sudo systemctl is-enabled wpa_supplicant@wlo1.service)"
echo "  SSH: $(sudo systemctl is-enabled ssh)"
echo ""
echo "Reboot to test: sudo reboot"
