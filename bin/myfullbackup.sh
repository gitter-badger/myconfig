#!/bin/sh
# Last modified: Fr Nov 29, 2013  07:14
if [ "$(id -u)" != "0" ]; then
  exit 1
fi

##########
# Config #
##########
UUID="09ec7ae8-70a1-407b-860f-a7a21e3f671d"
BACKUPDIR="/backup/"
STATUSFILE="${BACKUPDIR}statusfile"

rsnapshot_cfg() { #{{{
cat <<CONFIG
# this file is overwritten at every run
# This file requires tabs between elements #
config_version	1.2
snapshot_root	${BACKUPDIR}
no_create_root	1

#cmd_cp		/usr/bin/cp
cmd_rm		/usr/bin/rm
cmd_rsync	/usr/bin/rsync
#cmd_ssh	/usr/bin/ssh
cmd_logger	/usr/bin/logger
#cmd_du		/usr/bin/du
#cmd_rsnapshot_diff	/usr/local/bin/rsnapshot-diff
#cmd_preexec	/path/to/preexec/script
#cmd_postexec	/path/to/postexec/script

#interval	hourly	6
interval	daily	7
interval	weekly	4
interval	monthly	3

verbose		2
loglevel	3
#logfile	/var/log/rsnapshot
lockfile	/var/run/rsnapshot.pid
#rsync_short_args	-a
#rsync_long_args	--delete --numeric-ids --relative --delete-excluded
#ssh_args	-p 22
#du_args	-csh
one_fs		1

#include_file	/path/to/include/file
exclude_file	${BACKUPDIR}exclude_file

#link_dest	0
#sync_first	0
#use_lazy_deletes	0
#rsync_numtries 0

### BACKUP POINTS / SCRIPTS ###
backup	/home/					localhost/
backup	/etc/					localhost/
backup	/usr/local/				localhost/
#backup	/var/log/rsnapshot		localhost/
backup	/root/					localhost/
backup	/var/					localhost/
CONFIG
} #}}}

exclude_file() {
cat <<EXCLUDE
/home/hubi/tmp/
/home/hubi/.cache/
/home/hubi/Bilder/workspace/
EXCLUDE
}

###############################################################################
echo "0 0 0" >/sys/class/scsi_host/host1/scan
sleep 1
mount /dev/disk/by-uuid/$UUID ${BACKUPDIR}

[[ -f $STATUSFILE ]] || exit 1
BACKUPNR=`cat $STATUSFILE`
rsnapshot_cfg >${BACKUPDIR}rsnapshot_cfg
exclude_file >${BACKUPDIR}exclude_file

echo "starting backups (Nr. $BACKUPNR)..."
echo

rsnapshot -c ${BACKUPDIR}rsnapshot_cfg $1 daily
if (test $[$BACKUPNR % 7] -eq 0); then
  rsnapshot -c ${BACKUPDIR}rsnapshot_cfg $1 weekly
  if (test $[$BACKUPNR % 28] -eq 0); then
    rsnapshot -c ${BACKUPDIR}rsnapshot_cfg $1 monthly
  fi
fi

echo `expr $BACKUPNR + 1` > $STATUSFILE

have() { type "$1" &> /dev/null; }
have pacman && {
  pacman -Qeq > ${BACKUPDIR}daily.0/Pakete.txt
}

###############################################################################
sync
umount /backup
hdparm -Y /dev/disk/by-uuid/$UUID

# vim: set noexpandtab :