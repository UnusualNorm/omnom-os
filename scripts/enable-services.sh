set -e
systemctl enable bluetooth.service
systemctl enable cosmic-greeter.service
systemctl enable libvirtd.service
systemctl enable NetworkManager.service
systemctl enable power-profiles-daemon.service
systemctl enable waydroid-container.service
systemctl enable zerotier-one.service
