FROM ghcr.io/archlinux/archlinux:base-devel AS builder

RUN useradd -m builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf && \
    echo -e "\n[aur]\nSigLevel = Optional TrustAll\nServer = file:///aurpkgs" >> /etc/pacman.conf && \
    install -d /aurpkgs -o builder && \
    repo-add /aurpkgs/aur.db.tar.gz && \
    chown -R builder /aurpkgs && \
    pacman -Syu --noconfirm multilib-devel git

USER builder
WORKDIR /home/builder

RUN git clone https://aur.archlinux.org/aurutils.git && \
    cd aurutils && \
    makepkg -si --noconfirm

COPY pkglist.aur.txt /tmp/pkglist.aur.txt
RUN gpg --recv-keys F54984BFA16C640F 85AB96E6FA1BE5FE && \
    curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.gpg | gpg --import - && \
    AUR_PAGER=ls aur sync --noconfirm $(cat /tmp/pkglist.aur.txt | tr '\n' ' ')


FROM ghcr.io/unusualnorm/archlinux-bootc
COPY pkglists /tmp/pkglists
COPY --from=builder /aurpkgs /usr/lib/pacman/aurpkgs
COPY files /

RUN echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf && \
    echo -e "\n[aur]\nSigLevel = Optional TrustAll\nServer = file:///usr/lib/pacman/aurpkgs" >> /etc/pacman.conf && \
    pacman --disable-sandbox -Syu --noconfirm $(grep -h -v '^#' /tmp/pkglists/*.txt | tr '\n' ' ') && \
    rm -r /tmp/pkglists

# RUN pacman --disable-sandbox -S whois --noconfirm && \
#     useradd -m user && \
#     usermod -aG wheel user && \
#     usermod -p "$(echo "password" | mkpasswd -s)" user

COPY scripts /scripts
COPY run-scripts.sh /tmp/run-scripts.sh
RUN /tmp/run-scripts.sh && \
    pacman -Scc --noconfirm && rm -r /var/cache/* && \
    rm -r /tmp/run-scripts.sh /scripts && \
    rm -rf /boot/* /run/* /tmp/* /var/db/* /var/lib/* /var/log/* /var/roothome/.cache /var/spool/* && \
    find "/etc" -type s -exec rm {} \; && \
    bootc container lint --fatal-warnings
