docker run -d --name Ubuntu-1 \
  --shm-size 2g \
  --cpus 2 \
  --restart always \
  --cap-add=SYS_ADMIN \
  -p 50001:3389 \
  -e USERNAME=TEST -e PASSWORD=TEST \
  -p P2P_EMAIL="noemail@example.com" \
  ubuntu-xfce-xrdp
