#!/bin/bash

bfoldname="backup_"
bfoldname+=$(date +"%Y-%m-%d_%H-%M")

echo "Backing up folder: $1"
echo ""
echo ""

compress=false

while getopts "c" opt; do
  case $opt in
    c)
      echo "Compressing the Backup too..."
      compress=true
      shift $((OPTIND -1))
      ;;
    ?)
      echo "Invalid option: -$opt"
      exit 1
      ;;
  esac
done



if [ -d "$1" ]; then
    mkdir $bfoldname
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
    fi

    
else
    echo "Invalid directory provided"
fi

