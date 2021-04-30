service valheim stop
runuser -u steam -- /usr/games/steamcmd +login anonymous +force_install_dir /home/steam/valheimserver +app_update 896660 validate +exit
service valheim start
