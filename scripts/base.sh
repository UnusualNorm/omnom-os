set -e

mv /var/lib/pacman /usr/lib/pacman
echo "uninitialized" > /etc/machine-id

systemctl enable iwd.service
systemctl enable sshd.service
systemctl enable sync-homed-users.service
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable systemd-timesyncd.service
systemctl enable systemd-homed.service
