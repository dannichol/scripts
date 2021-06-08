#!/bin/bash

ERRLOG=/home/dan/scripts/log/backup_error.log
bailout() {
    echo "$(date '+%d/%m/%Y %H:%M:%S') $1" | tee -a "$ERRLOG"
    exit 7
}

usage() {
echo "This script is designed to backup the system as follows:"
echo " "
echo "    --backup-root    backs up the root filesystem from / to /backup"
echo "    --restore-root   restores the root filesystem from /backup to /"
echo " "
exit 10
}

[[ $USER != "root" ]] && bailout "Please run this as ROOT"

case "$1" in
    --backup-root)
        mount /dev/sdb3 /backup
        [[ "$?" -ne 0 ]] && bailout "MOUNT operation failed"
       	rsync -aAXv / --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/backup/*","/home"} /backup
        [[ "$?" -ne 0 ]] && bailout "RSYNC operation failed with exit code $?. Please refer to rsync man page."
        umount /backup
        [[ "$?" -ne 0 ]] && bailout "UMOUNT operation failed"
    ;;

    --restore-root)
        mount /dev/sdb3 /backup
        [[ "$?" -ne 0 ]] && bailout "MOUNT operation failed"
        rsync -aAXv /backup --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/backup/*","/home"} /
        [[ "$?" -ne 0 ]] && bailout "RSYNC operation failed with exit code $?. Please refer to rsync man page."
        umount /backup
        [[ "$?" -ne 0 ]] && bailout "UMOUNT operation failed"
    ;;

    --backup-home)
        rsync -aAXv /home /run/media/dan/external_storage/home
        [[ "$?" -ne 0 ]] && bailout "RSYNC operation failed with exit code $?. Please refer to rsync man page."
    ;;

    --restore-home)
        rsync -aAXv /run/media/dan/external_storage/home /home 
        [[ "$?" -ne 0 ]] && bailout "RSYNC operation failed with exit code $?. Please refer to rsync man page."
    ;;

    *) 
        echo "$(date '+%d/%m/%Y %H:%M:%S') $1 is not a valid option" >> $ERRLOG
        usage
    ;;
esac
