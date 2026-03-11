cat <<'EOF' >> /etc/bash.bashrc
if [ -d /etc/bash.bashrc.d ]; then
    for rc in /etc/bash.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
EOF
