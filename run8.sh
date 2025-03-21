docker run -d --name Ubuntu-8 \
  --shm-size 1g \
  --cpus 1 \
  --restart always \
  --cap-add=SYS_ADMIN \
  -p 5008:3389 \
  -p 4008:22222 \
  -e USERNAME=TEST -e PASSWORD=TEST \
  ubuntu-xfce-xrdp
