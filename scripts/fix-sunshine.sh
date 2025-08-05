set -e
setcap cap_sys_admin+p $(readlink -f $(which sunshine))
