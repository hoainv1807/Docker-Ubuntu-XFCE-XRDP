xdocker run -d --name Ubuntu-1 \
  --shm-size 1g \
  --cpus 1 \
  --restart always \
  --cap-add=SYS_ADMIN \
  -p 5001:3389 \
  -p 4001:22222 \
  -e USERNAME=TEST -e PASSWORD=TEST \
  -v /etc/_docker/ubuntu-xfce-xrdp:/TEST/.local/share \
  ubuntu-xfce-xrdp

  #change TEST for security xrdp
