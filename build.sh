sudo podman build --build-arg "MODULES=$*" --cap-add sys_admin --squash-all -t omnom-os .
