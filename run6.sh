docker run -d --name Ubuntu-6 \
  --shm-size 1g \
  --cpus 1 \
  --restart always \
  --cap-add=SYS_ADMIN \
  -p 5006:3389 \
  -p 4006:22222 \
  -e USERNAME=TEST -e PASSWORD=TEST \
  ubuntu-xfce-xrdp
