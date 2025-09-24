FROM ghcr.io/archlinux/archlinux:base-devel AS builder

RUN useradd -m builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf && \
    echo -e "\n[aur]\nSigLevel = Optional TrustAll\nServer = file:///aurpkgs" >> /etc/pacman.conf && \
    install -d /aurpkgs -o builder && \
    repo-add /aurpkgs/aur.db.tar.gz && \
    chown -R builder /aurpkgs && \
    pacman -Sy --noconfirm git

USER builder
WORKDIR /home/builder

RUN git clone https://aur.archlinux.org/aurutils.git && \
    cd aurutils && \
    makepkg -si --noconfirm

COPY pkglist.aur.txt /tmp/pkglist.aur.txt
RUN AUR_PAGER=ls aur sync --noconfirm $(cat /tmp/pkglist.aur.txt | tr '\n' ' ')


FROM ghcr.io/unusualnorm/archlinux-bootc
COPY pkglist.txt /tmp/pkglist.txt
COPY pkglist.aur.txt /tmp/pkglist.aur.txt
COPY --from=builder /aurpkgs /usr/lib/pacman/aurpkgs
COPY files /

RUN echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf && \
    echo -e "\n[lizardbyte]\nSigLevel = Optional\nServer = https://github.com/LizardByte/pacman-repo/releases/latest/download" >> /etc/pacman.conf && \
    echo -e "\n[aur]\nSigLevel = Optional TrustAll\nServer = file:///usr/lib/pacman/aurpkgs" >> /etc/pacman.conf && \
    pacman -Sy --noconfirm $(grep -v '^#' /tmp/pkglist.txt | tr '\n' ' ') && \
    rm /tmp/pkglist.txt /tmp/pkglist.aur.txt

COPY scripts /scripts
COPY run-scripts.sh /tmp/run-scripts.sh
RUN /tmp/run-scripts.sh && \
    pacman -Scc --noconfirm && \
    rm -r /tmp/run-scripts.sh /scripts && \
    rm -r /boot/* /var/cache/* /var/db/* /var/lib/* /var/log/* /var/roothome/.cache && \
    find "/etc" -type s -exec rm {} \; && \
    bootc container lint
