set -e

systemctl enable greetd.service
systemctl enable power-profiles-daemon.service

systemctl --global enable pipewire.service
systemctl --global enable pipewire-pulse.service
systemctl --global enable wireplumber.service

systemctl --global add-wants niri.service foot-server.service
systemctl --global add-wants niri.service mako.service
systemctl --global add-wants niri.service polkit-gnome.service
systemctl --global add-wants niri.service quickshell.service
systemctl --global add-wants niri.service swaybg.service
systemctl --global add-wants niri.service xembedsniproxy.service
