#!/bin/bash

if [ ! "$UPDATE" = "1" ]; then
  echo "UPDATE not requested, keeping installed version"
else
  echo "UPDATE requested, updating to latest version"
  wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin

fi

export HOME=/config
exec calibre
