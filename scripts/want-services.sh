set -e
systemctl --global add-wants niri.service kanshi.service
systemctl --global add-wants niri.service mako.service
systemctl --global add-wants niri.service swaybg.service
systemctl --global add-wants niri.service swayidle.service
systemctl --global add-wants niri.service waybar.service
