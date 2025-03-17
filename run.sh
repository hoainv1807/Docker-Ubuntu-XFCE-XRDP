docker run -d --name Ubuntu-1 \
    --shm-size 2g \
  --cpus 2 \
  --restart always \
  --cap-add=SYS_ADMIN \
  -e USERNAME=TEST -e PASSWORD=TEST \
  ubuntu-xfce-xrdp
