# Lyrion Music Server

Docker Container image for Lyrion Music Server (formerly SqueezeCenter, SqueezeboxServer, SlimServer, and Logitech Media Server)

The Docker Container updates the system on restart to apply security and Linux updates.

To run LMS on Unraid:

docker run -d --name="LyrionMusicServer" \
--net="bridge" \
-p 3483:3483/tcp \
-p 9000:9000/tcp \
-p 9090:9090/tcp \
-e PUID="99" \
-e PGID="100" \
-e TZ="America/Chicago" \
-v "/mnt/user/appdata/LyrionMusicServer":"/config":rw \
-v "/mnt/user/Music":"/music":rw \
dlandom/lyrionmusicserver
