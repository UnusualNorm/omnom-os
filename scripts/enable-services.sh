set -e
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
systemctl enable chronyd.service
systemctl enable cups.service
systemctl enable greetd.service
systemctl enable libvirtd.service
systemctl enable power-profiles-daemon.service
systemctl enable systemd-oomd.service
systemctl enable systemd-zram-setup@zram0.service
systemctl enable zerotier-one.service
systemctl --global enable syncthing.service