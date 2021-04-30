#!/bin/bash
err() {
  local color="\033[0;31m" #red
  local nc="\033[0m"
  echo "$color" "Valheim Script Error: $* $nc" >>/dev/stderr
}

info() {
  local color="\033[0;32m" #green
  local nc="\033[0m"
  echo "$color" "$* $nc"
}

titlebox() {
  local color="\033[0;33m" #yellow
  local nc="\033[0m"
  local s="$*"
  echo "
__${s//?/_}__
|$color $s $nc|
‾‾${s//?/‾}‾‾
"
}

install_steamcmd() {
  # todo check for existing install
  info "SteamCmd Installing"
  add-apt-repository multiverse
  dpkg --add-architecture i386
  apt update && apt upgrade -y
  echo steam steam/question select "I AGREE" | debconf-set-selections
  echo steam steam/license note '' | debconf-set-selections
  apt install -y steamcmd
  useradd --create-home --shell /bin/bash steam
  info "SteamCmd Install Successful!"
}

install_valheim() {
  info "Valheim Installing"
  runuser -u steam -- /usr/games/steamcmd +login anonymous +force_install_dir /home/steam/valheimserver +app_update 896660 validate +exit
  runuser -u steam -- mkdir -p /home/steam/.config/unity3d/IronGate/Valheim
  runuser -u steam -- touch /home/steam/.config/unity3d/IronGate/Valheim/{admin,banned}list.txt
  info "Valheim Install Successful!"
}

install_service() {
  info "Setting up valheim service"
  cp ./valheim-start.sh /home/steam/valheim-start.sh
  chown steam:steam /home/steam/valheim-start.sh

  cp ../service/valheim.service /etc/systemd/system/valheim.service
  systemctl daemon-reload
  systemctl enable valheim
}

titlebox "Installing Valheim Server"
info "Valheim SteamCmd Standalone Linux Server"

# todo install nginx
# todo dialog set config.env
install_steamcmd
install_valheim
install_service

info "Manage admin and bans with SteamIDs at /home/steam/.config/unity3d/IronGate/Valheim/"
info "Start and stop the server with the valheim command, or systemctl:"
echo "   valheim-server-linux/valheim start"
echo "   systemctl [start|stop|reload] valheim"


