set -e
for dir in pkgbuilds/*; do
  cd "$dir"
  makepkg $@
  for pkg in *.pkg.tar.zst; do
    cp "$pkg" ../
  done
  cd ../../
done