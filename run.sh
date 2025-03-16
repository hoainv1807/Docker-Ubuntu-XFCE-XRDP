docker run -d --name debian-1 \
  --shm-size 2g \
  --cpus 2 \
  --restart always \
  --cap-add=SYS_ADMIN \
  -v ubuntu1_vol:/persistent \
  -e USERNAME=TESTUSER -e PASSWORD=TESTUSER \
  debian-xfce-xrdp
