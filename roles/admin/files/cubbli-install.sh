#!/bin/bash
# Based on cubbli-install script from Jani Jaakkola.  Modified for
# fuxi-linux by Pekko Metsä 2017

LOG="/var/log/cubbli-install.log"

interactive=no
if tty > /dev/null; then
  interactive=yes
fi

log() {
 logger -t "$0" "$*"
 echo "$*" >> $LOG
 [ $interactive = yes ] && echo -e "\e[32m$*\e[0m"
}

do_apt() {
  DEBIAN_FRONTEND=noninteractive apt-get -y -q -o APT::Status-Fd=1 "$@" 2>> $LOG |
    while IFS=: read c1 c2 p what; do      
      [ $interactive = yes ] || continue
      if echo "$p" | egrep -q '^[0-9.]+$'; then
        printf '\r\e[2K%2.2f%% %.70s' "$p" "$what"
      fi
    done
  ret=${PIPESTATUS[0]}
  [ $interactive = yes ] && printf '\r\e[2K'
  if [ $ret != 0 ]; then    
    log "FAILED: apt-get $* returned $ret"
    log "Command was: DEBIAN_FRONTEND=noninteractive apt-get -y -q -o APT::Status-Fd=1 $@"
    log "See $LOG for details."
    [ $interactive = yes ] && echo -e "\e[31mCubbli installer failed!\e[0m"
    exit 1
  fi 
}
  

if [ -f /etc/cubbli/installer-finished ]; then
  log "Cubbli installer has already been run at $(cat /etc/cubbli/installer-finished)."
  exit 0
fi

log "Cubbli installer starting at $(date)."
log "Fetching updates. [1/5]"
do_apt update
do_apt dist-upgrade

log "Install cubbli-mint package. [2/5]"
do_apt install cubbli-mint

log "Installing ubuntu-drivers driver packakes. [3/5]"
ubuntu-drivers autoinstall
#do_apt install $(ubuntu-drivers list)

# cubbli-apps and cubbli-dev are too large for fuxilaptops' small SSD.
#log "Installing cubbli-apps and cubbli-dev. This will take some time. [4/5]"
log "Skipping cubbli-apps and cubbli-dev. This will take no time. [4/5]"
#do_apt install cubbli-apps cubbli-dev

log "Removing unnecessary packages [5/5]"
do_apt autoremove

date > /etc/cubbli/installer-finished
sync
log "Cubbli installer finished successfully at $(date)."
