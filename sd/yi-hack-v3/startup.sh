#!/bin/sh

HOMEVER=`cat /home/homever`

# Replace init.sh
if [[ ! -f /home/app/init.sh.$HOMEVER ]] &&
   [[ -f /tmp/sd/yi-hack-v3/sbin/yi_init.sh ]] &&
   [[ -d /tmp/sd/yi-hack-v3/lib/hi3518e ]]; then
      cp /home/app/init.sh /home/app/init.sh.$HOMEVER
      cp /tmp/sd/yi-hack-v3/sbin/yi_init.sh /home/app/init.sh
      reboot
fi
