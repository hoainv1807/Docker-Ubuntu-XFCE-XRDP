docker run -d --name Ubuntu-1 \
  --shm-size 2g \
  --cpus 2 \
  --restart always \
  --cap-add=SYS_ADMIN \
  -e USERNAME=TEST -e PASSWORD=TEST \
  -p 50001:3389 \
  ubuntu-xfce-xrdp
