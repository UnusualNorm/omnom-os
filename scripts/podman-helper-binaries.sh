set -e
url=$(curl -s https://api.github.com/repos/containers/gvisor-tap-vsock/releases/latest \
    | grep browser_download_url \
    | grep gvproxy-linux-amd64 \
    | cut -d '"' -f 4)

sudo mkdir -p /usr/libexec/podman
sudo curl -L -o /usr/libexec/podman/gvproxy "$url"
sudo chmod +x /usr/libexec/podman/gvproxy
