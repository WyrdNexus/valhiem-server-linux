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

# todo password min 5 chars & not in server name
[ -z "$1" ] && {
  err "valheim-start missing args: server-name password port"
  return 1
}

[ -z "$2" ] && {
  err "valheim-start missing args: password port"
  return 1
}

[ ${#2} -lt 5 ] && {
  err "valheim-start password is too short"
  return 1
}

[[ "$1" =~ .*"$2".* ]] && {
  err "valheim-start password cannot be in the server name"
  return 1
}

name="${1}"
pass="${2}"
port="${3:=2456}"

info "Starting Valheim World: $name on :$port"

export LD_LIBRARY_PATH="/home/steam/valheimserver/linux64:$LD_LIBRARY_PATH"
export SteamAppId=892970

exec /home/steam/valheimserver/valheim_server.x86_64 -name "${name}" -port "${port}" -nographics -batchmode -world "${name}" -password "${pass}" -public "0"
