#!/bin/bash
# cubbli-admin cron-job by Mikko Rauhala and Jani Jaakkola
# Slightly modified by Pekko Metsä 2016-2017 for fuxi-linux.
# JJ

PATH=/usr/local/sbin:/sbin:/usr/sbin:/bin:/usr/bin:"$PATH"
umask 022

log() {
  logger -t "$0" "$*"
  echo "---- $*"

}

log "$0 starting at $(date)"

# Try to avoid debian packages hanging
export DEBIAN_FRONTEND=noninteractive

cubbli_install()
{
	for package in "$@"; do
		if ! dpkg --get-selections "$package" 2> /dev/null | grep -q "install$"; then
			apt-get -y install "$package"
		fi
	done
}

RELEASE="$(lsb_release -cs)"
ARCH="$(uname -m)"
LOCK="/var/lock/cubbli-admin.cron"
HOSTNAME="$(hostname)"
DOMAIN="$(hostname -d)"
HOSTBASE="$(echo "$HOSTNAME" | cut -d - -f 1)"

if [ "a$RELEASE" != "axenial" -a "a$RELEASE" != "asarah" ]; then
	echo "Unsupported release $RELEASE" 1>&2
	exit 2
fi

# Get a lock for the script to run
GOT_LOCK=0
for a in $(seq 1 30); do
	if ( set -o noclobber; echo "$$" > "$LOCK") 2> /dev/null; then
		trap 'rm -f "$LOCK"; exit $?' INT TERM EXIT
		GOT_LOCK=1
                break
        fi
        sleep 1m
done
if [ "a$GOT_LOCK" = "a0" ]; then
	echo "Failed to acquire cubbli-admin cronjob lock." 1>&2
	echo "Held by $(cat "$LOCK")" 1>&2
	exit 1
fi

# Make a slight effort to wait for apt to be idle.
APT_RUNNING=1
for a in $(seq 1 180); do
        if ! ps x | awk '{ print $5 }' | sed s_^.*/__ | grep -q '^apt' ; then
                APT_RUNNING=0
		break
        fi
        sleep 1m
done
if [ "a$APT_RUNNING" = "a1" ]; then
        echo "Warning: apt may be running during cubbli-admin cronjob." 1>&2
	ps x 1>&2
fi



echo "# DO NOT EDIT. This file intentionally kept empty by Fuxi-linux administration." > /etc/apt/sources.list

if dpkg -l | grep -q ^i[^i] ; then
        log "Trying to run interrupted deb configure scripts"
	echo " --- dpkg --configure -a"
        yes n | dpkg --configure -a
fi

log "Running apt-get clean"
apt-get clean

log "Running  apt-get update"
if ! apt-get -y update ; then
        log "Retrying apt-get update"
	rm -f /var/lib/apt/lists/*
	apt-get -y update
fi

# Do a remove-install cycle for matlab to mitigate free space issues
#if dpkg -l matlab 2> /dev/null | grep -q "^.i *matlab " ; then
#	if ! apt-get -s -y install matlab 2> /dev/null | grep -q "^matlab is already the newest version." ; then
#		echo " --- remove and install matlab ---"
#		dpkg --remove --force-depends matlab
#		apt-get -y install matlab
#		apt-get clean
#	fi
#fi

log "Running apt-get -f install"
apt-get -y -f install

log "Running apt-get -y dist-upgrade"
if ! apt-get -y dist-upgrade ; then
	echo mail -s "$(hostname -f) dist-upgrade failed" tietos-linux-info@helsinki.fi < /var/log/cubbli-apt.log
fi

# FIXME: move this to cubbli-install
log "Running ubuntu-drivers autoinstall"
ubuntu-drivers autoinstall < /dev/null 

# Run cubbli installer if not run already
/usr/local/sbin/cubbli-install.sh

# Install cuda if we have nvidia drivers
if { dpkg -s nvidia-375 && dpkg -s cubbli-dev ; } > /dev/null 2>&1 ; then
  if dpkg -s cuda > /dev/null 2>&1; then
    log "Cuda already installed."
  else 
    log "Installing cuda drivers. Running apt-get -y install cuda"
    apt-get -y install cuda
  fi
fi

# Count free size of root filesystem in gigabytes
DFROOT=$(( $(stat --file-system -c"%a / ( 1024*1024*1024 / %S )" / ) ))

if [ -f /etc/cubbli/flags/use-ad-home ]; then
  # Classroom installation
  
  # Clean /old linux
  if [ -d /oldlinux ] && 
    [ $(( ( $(date +%s) - $(stat -c%Y /oldlinux) )/60/60/24 )) -gt 7 ]; then
      log "/oldlinux is more than a week old. Removing it."
      rm -r /oldlinux
  fi
  
  # Install matlab?
  if [ $DFROOT -gt 25 ] && ! dpkg -s matlab > /dev/null 2>&1; then
    log "More than 25G space in /. Installing matlab."
    apt-get -y install matlab
  fi
fi

    


#if laptop-detect ; then
#	cubbli_install cubbli-laptop
#fi

#if hostname | grep -q -e "didfys" -e "flkl" -e "flatm" -e "flspa" -e "flgeo" -e "fladm" -e "hip" -e "flafo" -e "flxray" -e "kukad210" -e "kukad211" || hostname -f | grep -q -i -F -e ".physics.helsinki.fi" -e ".acclab.helsinki.fi" -e ".atm.helsinki.fi" -e ".theorphys.helsinki.fi" -e ".astro.helsinki.fi" -e ".gfl.helsinki.fi" -e ".xrayphys.helsinki.fi" ; then
#	cubbli_install cubbli-dept-physics
#	apt-get update > /dev/null 2>&1
#	cubbli_install hy-physics-proprietary
#fi

log "Removing unwanted packages"

for deb in libsss-sudo sessioninstaller python3-commandnotfound command-not-found \
    command-not-found-data adobereader-enu xul-ext-ubufox kde-config-whoopsie \
    whoopsie \
    muon-updater muon-notifier plasma-discover-updater \
    apport-gtk apport-kde \
    libpam-kwallet4 libpam-kwallet5 ; do
  if dpkg -s $deb > /dev/null 2>&1; then
    log "* removing $deb"
    dpkg --purge $deb
  fi
done

log "Running autoremover"
apt-get -y autoremove

#log "Starting printer list updater"
#/usr/local/sbin/cubbli-update-printers.sh

if ! debconf-get-selections | grep -q msttcorefonts/accepted-mscorefonts-eula.*true ; then
        log "Installing ttf-mscorefonts-installer"
	echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true" | debconf-set-selections
	apt-get -y reinstall ttf-mscorefonts-installer > /dev/null 2>&1
fi

log "$0 done."

exit 0
