set -e
for dir in /usr/lib/modules/*; do
  dracut "$dir/initramfs.img" "$(basename $dir)"
done