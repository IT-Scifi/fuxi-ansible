#!/bin/bash
# fuxi-update by Pekko Metsä.  Based on cubbli-admin cron-job by Mikko
# Rauhala and Jani Jaakkola v. 2016-09-05
# v. 2016-11-08

PATH=/sbin:/usr/sbin:/bin:/usr/bin:"$PATH"
umask 022

echo "---- $0 starting at $(date)"

RELEASE="$(lsb_release -cs)"
ARCH="$(uname -m)"
LOCK="/var/lock/fuxi-update.cron"
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
	echo "Failed to acquire fuxi-update cronjob lock." 1>&2
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
        echo "Warning: apt may be running during fuxi-update cronjob." 1>&2
	ps x 1>&2
fi


echo "# DO NOT EDIT. This file intentionally kept empty by fuxi-linux administration." > /etc/apt/sources.list

echo "--- Trying to run interrupted deb configure scripts"
if dpkg -l | grep -q ^i[^i] ; then
	echo " --- dpkg --configure -a"
        yes n | dpkg --configure -a
fi

# Run cubbli installer if not run already
#/sbin/cubbli-install

echo "--- apt-get clean"
apt-get clean


# See what would be autoremoved if we add this
echo "--- Simulation of autoremove ---"
apt-get -s -y autoremove

echo "--- apt-get update ---"
if ! apt-get update ; then
	rm -f /var/lib/apt/lists/*
	apt-get update
fi

echo " --- apt-get -f install ---"
apt-get -f install

echo " --- apt-get -y dist-upgrade ---"
# If dist upgrade fails, output of "ls /home" is mailed to administrators, because
# the username specifies the machine.  The hostname is not unique.
if ! apt-get -y dist-upgrade ; then
	ls /home | echo mail -s "$(hostname -f) dist-upgrade failed" pekko.metsa@helsinki.fi
fi

if ! grep -q "^Prompt=never$" /etc/update-manager/release-upgrades ; then
	sed -i "s/^Prompt=.*$/Prompt=never/" /etc/update-manager/release-upgrades
fi

if grep -q "^UMASK.*022" /etc/login.defs ; then
	sed -i 's/^\(UMASK.*\)022/\1077/' /etc/login.defs
fi

#echo "--- Removing unwanted packages"
#
#for deb in libsss-sudo sessioninstaller command-not-found command-not-found-data adobereader-enu xul-ext-ubufox; do
#  if dpkg -s $deb > /dev/null 2>&1; then
#    echo "--- removing $deb"
#    dpkg --purge $deb
#  else
#    echo "--- already removed: $deb"
#  fi
#done

apt-get -q -y update > /dev/null

if ! debconf-get-selections | grep -q msttcorefonts/accepted-mscorefonts-eula.*true ; then
	echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true" | debconf-set-selections
	apt-get -y reinstall ttf-mscorefonts-installer > /dev/null 2>&1
fi


exit 0
