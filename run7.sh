docker run -d --name Ubuntu-7 \
  --shm-size 1g \
  --cpus 1 \
  --restart always \
  --cap-add=SYS_ADMIN \
  -p 5007:3389 \
  -p 4007:22222 \
  -e USERNAME=TEST -e PASSWORD=TEST \
  ubuntu-xfce-xrdp
