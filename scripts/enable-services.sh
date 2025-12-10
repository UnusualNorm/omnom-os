set -e
systemctl enable bluetooth.service
systemctl enable chronyd.service
systemctl enable cosmic-greeter.service
systemctl enable libvirtd.service
systemctl enable NetworkManager.service
systemctl enable power-profiles-daemon.service
systemctl enable systemd-oomd.service
systemctl enable zerotier-one.service
