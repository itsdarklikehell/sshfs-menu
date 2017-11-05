#!/bin/bash
sudo apt-get install sshfs git
cd
git clone https://github.com/itsdarklikehell/sshfs-menu
cd sshfs-menu
chmod +x sshfs-menu.sh
sudo ln -s $PWD/sshfs-menu.sh /usr/local/bin/sshfs-menu
MOUNT(){
  HOSTNAME=$(whiptail --inputbox "What is the hostname or ip address you would like to connect to?" 8 78 192.168.1.2 --title "Hostname" 3>&1 1>&2 2>&3)
  # A trick to swap stdout and stderr.
  # Again, you can pack this inside if, but it seems really long for some 80-col terminal users.
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    echo "User selected Ok and entered " $HOSTNAME
    USERNAME=$(whiptail --inputbox "What is the username you would like to use?" 8 78 root --title "Username" 3>&1 1>&2 2>&3)
    # A trick to swap stdout and stderr.
    # Again, you can pack this inside if, but it seems really long for some 80-col terminal users.
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
      echo "User selected Ok and entered " $USERNAME
    else
      echo "User selected Cancel."
    fi
    #echo "(Exit status was $exitstatus)"
    REMLOCATION=$(whiptail --inputbox "What is the remote location you would like to connect to?" 8 78 / --title "Remote Location" 3>&1 1>&2 2>&3)
    # A trick to swap stdout and stderr.
    # Again, you can pack this inside if, but it seems really long for some 80-col terminal users.
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
      echo "User selected Ok and entered " $REMLOCATION
    else
      echo "User selected Cancel."
    fi
    #echo "(Exit status was $exitstatus)"
    LOCLOCATION=$(whiptail --inputbox "What is the local location you would like to mount the remote location to?" 8 78 /home/$USER/sshfs/pc-local/ --title "Local location" 3>&1 1>&2 2>&3)
    # A trick to swap stdout and stderr.
    # Again, you can pack this inside if, but it seems really long for some 80-col terminal users.
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
      echo "User selected Ok and entered " $LOCLOCATION
      mkdir -P $LOCLOCATION
    else
      echo "User selected Cancel."
    fi
    #echo "(Exit status was $exitstatus)"
    sshfs $USERNAME@$HOSTNAME:$REMLOCATION $LOCLOCATION -o idmap=user


  else
    echo "User selected Cancel."
  fi
  #echo "(Exit status was $exitstatus)"
}
UNMOUNT(){
  LOCLOCATION=$(whiptail --inputbox "What is the local location you would like to unmount?" 8 78 /home/$USER/sshfs/pc-local/ --title "Local location" 3>&1 1>&2 2>&3)
  # A trick to swap stdout and stderr.
  # Again, you can pack this inside if, but it seems really long for some 80-col terminal users.
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    echo "User selected Ok and entered " $LOCLOCATION
    fusermount -u $LOCLOCATION
  else
    echo "User selected Cancel."
  fi
  #echo "(Exit status was $exitstatus)"
}
MAINMENU(){

  CHOICE=$(whiptail --title "Menu example" --menu "Choose an option" $LINES $COLUMNS $(( $LINES - 8 )) \
  "MOUNT" "Mount a remote sshfs to a local folder." \
  "UNMOUNT" "Unount a remote sshfs from a local folder." 3>&1 1>&2 2>&3)
  if [ $CHOICE = MOUNT ]; then
    echo "User selected " $CHOICE
    MOUNT
  fi
  if [ $CHOICE = UNMOUNT ]; then
    echo "User selected " $CHOICE
    UNMOUNT
  fi
}

MAINMENU
