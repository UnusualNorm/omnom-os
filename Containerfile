FROM docker.io/archlinux:base-devel AS pkg-builder
WORKDIR /

RUN pacman -Sy && \
    useradd -m builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
USER builder

COPY makepkgs.sh /makepkgs.sh
COPY --chown=builder:builder PKGBUILDS /PKGBUILDS
RUN /makepkgs.sh -cs --noconfirm


FROM docker.io/archlinux:base-devel AS builder
RUN pacman -Sy --noconfirm arch-install-scripts
COPY pkglist.txt /tmp/pkglist.txt
RUN pacstrap -P /mnt $(grep -v '^#' /tmp/pkglist.txt | tr '\n' ' ')


FROM scratch
COPY --from=builder /mnt /

COPY --from=pkg-builder /PKGBUILDS /tmp/PKGBUILDS
RUN pacman -U --noconfirm /tmp/PKGBUILDS/*.pkg.tar.zst && \
    rm -rf /tmp/PKGBUILDS

COPY files /
COPY scripts /scripts

COPY run-scripts.sh /tmp/run-scripts.sh
RUN /tmp/run-scripts.sh && \
    rm /tmp/run-scripts.sh && \
    rm -rf /scripts

RUN sed -i \
    -e 's|^#\(DBPath\s*=\s*\).*|\1/usr/lib/pacman|g' \
    -e 's|^#\(IgnoreGroup\s*=\s*\).*|\1modified|g' \
    "/etc/pacman.conf" && \
    mv "/var/lib/pacman" "/usr/lib/" && \
    rm -rf /var/cache/* && \
    find "/etc" -type s -exec rm {} \;

RUN mkdir /sysroot /efi && \
    rm -rf /boot/* /var/log /home /root /usr/local /srv && \
    ln -s sysroot/ostree /ostree && \
    ln -s var/home /home && \
    ln -s var/roothome /root && \
    ln -s var/usrlocal /usr/local && \
    ln -s var/srv /srv

RUN bootc container lint
LABEL containers.bootc=1
