truncate -s 10G image.raw
sudo podman run \
    --rm \
    --privileged \
    --pid=host \
    -v /var/lib/containers:/var/lib/containers \
    -v $(pwd):/output \
    omnom-os bootc install to-disk \
        --generic-image \
        --composefs-backend \
        --filesystem ext4 \
        --bootloader systemd \
        --via-loopback \
        --wipe \
        /output/image.raw
