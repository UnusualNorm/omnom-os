sort pkglist.aur.txt -o pkglist.aur.txt
for file in pkglists/*; do
    sort "$file" -o "$file"
done
