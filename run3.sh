docker run -d --name Ubuntu-3 \
  --shm-size 1g \
  --cpus 1 \
  --restart always \
  --cap-add=SYS_ADMIN \
  -p 5003:3389 \
  -p 4003:22222 \
  -e USERNAME=TEST -e PASSWORD=TEST \
  ubuntu-xfce-xrdp
