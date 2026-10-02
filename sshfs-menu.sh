#!/bin/bash
set -euo pipefail

# sshfs-menu: interactief menu voor het mounten/unmounten van SSHFS-shares
# Gebruik: ./sshfs-menu.sh [mount|unmount]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

check_deps() {
  local missing=()
  command -v whiptail >/dev/null 2>&1 || missing+=("whiptail")
  command -v sshfs >/dev/null 2>&1 || missing+=("sshfs")
  command -v fusermount >/dev/null 2>&1 || missing+=("fusermount")
  if [ ${#missing[@]} -gt 0 ]; then
    echo "Ontbrekende dependencies: ${missing[*]}"
    echo "Installeer met: sudo apt-get install whiptail sshfs"
    exit 1
  fi
}

MOUNT(){
  local HOSTNAME USERNAME REMLOCATION LOCLOCATION
  HOSTNAME=$(whiptail --inputbox "Wat is de hostname of IP-adres waarmee je wilt verbinden?" 8 78 192.168.1.2 --title "Hostname" 3>&1 1>&2 2>&3) || return
  USERNAME=$(whiptail --inputbox "Wat is de gebruikersnaam?" 8 78 root --title "Gebruikersnaam" 3>&1 1>&2 2>&3) || return
  REMLOCATION=$(whiptail --inputbox "Wat is de remote locatie die je wilt mounten?" 8 78 / --title "Remote locatie" 3>&1 1>&2 2>&3) || return
  LOCLOCATION=$(whiptail --inputbox "Wat is de lokale locatie om naar te mounten?" 8 78 "/home/$USER/sshfs/pc-local/" --title "Lokale locatie" 3>&1 1>&2 2>&3) || return

  mkdir -p "$LOCLOCATION"
  sshfs "${USERNAME}@${HOSTNAME}:${REMLOCATION}" "$LOCLOCATION" \
    -o idmap=user,uid="$(id -u)",gid="$(id -g)",reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
  whiptail --title "Klaar" --msgbox "Mounted ${USERNAME}@${HOSTNAME}:${REMLOCATION} naar ${LOCLOCATION}." 8 78
}

UNMOUNT(){
  local LOCLOCATION
  LOCLOCATION=$(whiptail --inputbox "Wat is de lokale locatie die je wilt unmounten?" 8 78 "/home/$USER/sshfs/pc-local/" --title "Lokale locatie" 3>&1 1>&2 2>&3) || return
  fusermount -u "$LOCLOCATION"
  whiptail --title "Klaar" --msgbox "Unmounted ${LOCLOCATION}." 8 78
}

MAINMENU(){
  local CHOICE
  CHOICE=$(whiptail --title "SSHFS Menu" --menu "Kies een optie" 15 60 8 \
    "MOUNT" "Mount een remote sshfs naar een lokale map." \
    "UNMOUNT" "Unmount een remote sshfs van een lokale map." 3>&1 1>&2 2>&3) || return

  case "$CHOICE" in
    MOUNT) MOUNT; MAINMENU ;;
    UNMOUNT) UNMOUNT; MAINMENU ;;
  esac
}

check_deps

# CLI argumenten ondersteunen
case "${1:-}" in
  mount) MOUNT ;;
  unmount) UNMOUNT ;;
  *) MAINMENU ;;
esac
