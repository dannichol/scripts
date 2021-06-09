#!/bin/bash

#ERRLOG=/home/dan/scripts/log/backup_error.log
function bailout() {
    echo "$(date '+%H:%M:%S',) EXITING, $*" #| tee -a "$ERRLOG"
    usage
    exit 1
}

function usage() {
echo "
Options:
  Only one of the following should be used.
   -b 
      Backup source to target
   -r 
      Restore source to target
Flags:
  Both are required.
   -s
      Source directory path
   -t
      Target directory path. If not specified, defaults to source/source.tgz
Usage:
  ./backup -b -s /home/user -t /mnt/usb/backups/home
"
}

function verifyOpts() {
  [ -n "$ACTION" ] && bailout -b and -r cannot be used together
}

while getopts "brs:t:" opt; do
	case ${opt} in
	  b ) 
      verifyOpts
			[ -z "$ACTION" ] && ACTION=backup; export ACTION
      echo "$ACTION"
	  ;;
	
	  r ) 
      verifyOpts
			[ -z "$ACTION" ] && ACTION=restore; export ACTION
      echo "$ACTION"
	  ;;
	
	  s )
	    SOURCE="${OPTARG}"
      TARGET="${OPTARG}${OPTARG}.tgz"
      echo "$SOURCE" "$TARGET"
	  ;;
	
	  t )
	    TARGET=${OPTARG}
      echo "$TARGET"
	  ;;
	
	  \?)
	    echo "Invalid option: ${OPTARG}" 1>&2
	  ;;
	
	  : )
	    echo "Invalid option: ${OPTARG} requires an argument" 1>&2
	  ;;
	
	esac
done

# OLD CODE THAT NEEDS TO BE CHANGED
#
# [[ $USER != "root" ]] && bailout "Please run this as ROOT"
# 
# case "$1" in
#     --backup)
#         rsync -aAXv /home /run/media/dan/external_storage/home
#         [[ "$?" -ne 0 ]] && bailout "RSYNC operation failed with exit code $?. Please refer to rsync man page."
#     ;;
# 
#     --restore)
#         rsync -aAXv /run/media/dan/external_storage/home /home 
#         [[ "$?" -ne 0 ]] && bailout "RSYNC operation failed with exit code $?. Please refer to rsync man page."
#     ;;
# 
#     *) 
#         echo "$(date '+%d/%m/%Y %H:%M:%S') $1 is not a valid option" >> $ERRLOG
#         usage
#     ;;
# esac
