FROM ghcr.io/archlinux/archlinux:base-devel AS builder

RUN useradd -m builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo -e "\n[custom]\nSigLevel = Optional TrustAll\nServer = file:///home/custompkgs" >> /etc/pacman.conf && \
    install -d /home/custompkgs -o builder && \
    repo-add /home/custompkgs/custom.db.tar.gz && \
    chown -R builder /home/custompkgs && \
    pacman -Sy --noconfirm git

USER builder
WORKDIR /home/builder

RUN git clone https://aur.archlinux.org/aurutils.git && \
    cd aurutils && \
    makepkg -si --noconfirm

COPY pkglist.aur.txt /tmp/pkglist.aur.txt
RUN AUR_PAGER=ls aur sync --noconfirm $(grep -v '^#' /tmp/pkglist.aur.txt | tr '\n' ' ')


FROM ghcr.io/unusualnorm/archlinux-bootc
COPY pkglist.txt /tmp/pkglist.txt
COPY pkglist.aur.txt /tmp/pkglist.aur.txt
COPY --from=builder /home/custompkgs /usr/lib/pacman/custompkgs

RUN echo -e "\n[custom]\nSigLevel = Optional TrustAll\nServer = file:///usr/lib/pacman/custompkgs" >> /etc/pacman.conf && \
    pacman -Sy --noconfirm $(grep -v '^#' /tmp/pkglist.txt | tr '\n' ' ') $(grep -v '^#' /tmp/pkglist.aur.txt | tr '\n' ' ') && \
    rm /tmp/pkglist.txt /tmp/pkglist.aur.txt

COPY files /
COPY scripts /scripts

COPY run-scripts.sh /tmp/run-scripts.sh
RUN /tmp/run-scripts.sh && \
    pacman -Scc --noconfirm && \
    rm /tmp/run-scripts.sh && \
    rm -r /scripts && \
    rm -r /boot/* /var/cache/* /var/db/* /var/lib/* /var/log/* /var/roothome/.cache && \
    find "/etc" -type s -exec rm {} \; && \
    bootc container lint
