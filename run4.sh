docker run -d --name Ubuntu-4 \
  --shm-size 1g \
  --cpus 1 \
  --restart always \
  --cap-add=SYS_ADMIN \
  -p 5004:3389 \
  -p 4004:22222 \
  -e USERNAME=TEST -e PASSWORD=TEST \
  ubuntu-xfce-xrdp
