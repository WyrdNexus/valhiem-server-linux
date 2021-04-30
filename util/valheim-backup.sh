#!/bin/bash
directory="${1:=default}"
message="$directory Backup Complete $(date)"
sudo cp /home/steam/.config/unity3d/IronGate/Valheim/worlds/* ~/valheim/bu/$directory/
sudo chown "${USER:=$(/usr/bin/id -run)}":"$USER" ~/valheim/bu/$directory/
echo "$message" >> ~/valheim/bu/backups.log
echo "$message"
