FROM ghcr.io/archlinux/archlinux:base-devel AS devel
RUN --mount=type=cache,id=pacman-pkg,target=/var/cache/pacman/pkg \
    pacman-key --init && \
    pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com && \
    pacman-key --lsign-key 3056513887B78AEB && \
    pacman -U --noconfirm \
    'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'  \
    'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' && \
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf && \
    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf && \
    echo -e "\n[aur]\nSigLevel = Optional TrustAll\nServer = file:///aurpkgs" >> /etc/pacman.conf

FROM devel AS builder
RUN --mount=type=cache,id=pacman-pkg,target=/var/cache/pacman/pkg \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    useradd -m builder && \
    install -d /aurpkgs -o builder && \
    repo-add /aurpkgs/aur.db.tar.gz && \
    chown -R builder /aurpkgs && \
    pacman -Syu --noconfirm git
USER builder
WORKDIR /home/builder
RUN --mount=type=cache,id=pacman-pkg,target=/var/cache/pacman/pkg \
    git clone https://aur.archlinux.org/aurutils.git && \
    cd aurutils && \
    makepkg -si --noconfirm
COPY pkglist.aur.txt /tmp/pkglist.aur.txt
RUN --mount=type=cache,id=pacman-pkg,target=/var/cache/pacman/pkg \
    AUR_PAGER=ls aur sync --noconfirm $(cat /tmp/pkglist.aur.txt | tr '\n' ' ')

FROM devel AS bootstrapper
COPY --from=builder /aurpkgs /aurpkgs
RUN --mount=type=cache,id=pacman-pkg,target=/var/cache/pacman/pkg \
    pacman -Sy --noconfirm arch-install-scripts
ARG MODULES=base
COPY files /tmp/files
RUN for module in $MODULES; do \
    cp -r /tmp/files/"$module"/* /mnt/ || exit 1; done && \
    echo '[options]' >> /etc/pacman.conf && \
    find /mnt \( -type f -o -type l \) | \
    sed 's|^/mnt/|NoExtract = |' >> /etc/pacman.conf
COPY pkglists /tmp/pkglists
RUN --mount=type=cache,id=pacman-pkg,target=/mnt/var/cache/pacman/pkg \
    pacstrap /mnt --noconfirm --overwrite '*' \
    $(for module in $MODULES; do \
    cat /tmp/pkglists/"$module".txt; done)
COPY scripts /tmp/scripts
RUN --mount=type=cache,id=pacman-pkg,target=/mnt/var/cache/pacman/pkg \
    for module in $MODULES; do \
    arch-chroot /mnt /bin/sh -s < \
    /tmp/scripts/"$module".sh || exit 1; done

FROM scratch AS base
COPY --from=bootstrapper /mnt /
RUN \
    # nonempty-boot
    rm -rf /boot/* && \
    # var-log
    rm -rf /var/log/* && \
    # var-tmpfiles
    rm -rf /var/cache/* /var/db/* /var/lib/* /var/roothome/* /var/roothome/.* /var/spool/* && \
    bootc container lint --no-truncate --fatal-warnings
LABEL containers.bootc=1
