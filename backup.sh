#!/bin/bash
# b29, b29kaamkarlo

mkdir -p .backups

bfoldname=".backups/backup_"
bfoldname+=$(date +"%Y-%m-%d_%H-%M")

if [ -f "./.backups/maxbackups" ]; then
  source ./.backups/maxbackups
else
  echo "N=15" > ./.backups/maxbackups
  source ./.backups/maxbackups
fi
# echo "$N"

compress=true

while getopts "chN:" opt; do
  case $opt in
    f)
      echo "Not compressing the Backup, making folder..."
      echo ""
      compress=false
      shift $((OPTIND -1))
      ;;
    N)
      echo "Changing maximum backups number, Currently $N -> $OPTARG"
      echo "N=$OPTARG" > ./.backups/maxbackups
      N="$OPTARG"
      old=$(find ./.backups/ -type f -name 'backup_*' | sort | head -n 1)
      rm "$old"
      exit 0
      ;;
    h*)
      echo "Help called for backup.sh"
      echo "Usage: ./backup.sh [-c Compress] \"directoryname\""
      exit 0
      ;;
  esac
done


echo "Backing up folder: $1"
echo ""


if [ -d "$1"  ]; then
    # mkdir $bfoldname
    if [ "$compress" = false ]; then 
        cp -r $1 $bfoldname
        echo "Starting backup..."
        echo "Backup Finished Succcessfully!!!"
        echo "Backup Folder: $(pwd)/$bfoldname"
    else
        tar -czf "$bfoldname.tar.gz" $1
        echo "Starting backup..."
        echo "Backup Finished Succcessfully!!!"
        echo "Backup Folder: $(pwd)/$bfoldname.tar.gz"

        n=$(find ./.backups/ -name "backup_*.tar.gz" | wc -l)

        echo " "
        if [ "$n" -gt "$N" ]; then
          echo "Backup amount exceeding max amount ($n)"
          todel=$(find ./.backups/ -type f -name 'backup_*' | sort | head -n 1)
          echo "Deleting backup: $todel"
          rm "$todel"
        fi
    fi
else
    echo "Invalid directory provided"
fi

