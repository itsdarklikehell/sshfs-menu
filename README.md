# sshfs-menu

Interactief menu voor het mounten en unmounten van bestandssystemen via SSHFS.

## Installatie

```bash
git clone https://github.com/itsdarklikehell/sshfs-menu.git
cd sshfs-menu
chmod +x sshfs-menu.sh
```

## Gebruik

```bash
# Interactief menu
./sshfs-menu.sh

# Direct mounten
./sshfs-menu.sh mount

# Direct unmounten
./sshfs-menu.sh unmount
```

## Vereisten

- `whiptail` — voor de interactieve menu's
- `sshfs` — voor het mounten van remote bestandssystemen
- `fusermount` — voor het unmounten

```bash
sudo apt-get install whiptail sshfs
```

## Features

- Interactief menu met whiptail
- CLI argumenten voor directe mount/unmount
- Automatische dependency-check
- Moderne SSHFS opties (reconnect, keepalive)
- Nederlandse interface

---

## 🎥 Gource Visualization

De ontwikkelhistorie van dit project in een film:

<video src="https://raw.githubusercontent.com/itsdarklikehell/sshfs-menu/master/gource.mp4" controls width="100%"></video>
