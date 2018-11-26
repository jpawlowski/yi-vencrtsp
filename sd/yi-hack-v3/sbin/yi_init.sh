# Run original init.sh if we miss our custom files
HOMEVER=`cat /home/homever`
if [[ ! -d /tmp/sd/yi-hack-v3/lib/hi3518e ]] && [[ -f /home/app/init.sh.$HOMEVER ]]; then
  mv -f /home/app/init.sh.$HOMEVER /home/app/init.sh
  reboot
  exit
fi

ulimit -s 1024
export LD_LIBRARY_PATH=/home/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/app/locallib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/hisiko/hisilib:$LD_LIBRARY_PATH
export PATH=/home/app/localbin:$PATH
export PATH=/home/base/tools:$PATH

rm /etc/mtab

/home/app/script/factory_test.sh

sysctl -w vm.dirty_background_ratio=2
sysctl -w vm.dirty_ratio=5
sysctl -w vm.dirty_writeback_centisecs=100
sysctl -w vm.dirty_expire_centisecs=500
echo 5 > /proc/sys/vm/laptop_mode
echo 0 > /proc/sys/vm/swappiness

#/home/base/tools/nvram_tools_h19
bcmver="bd1e"
bcmver1="0bdc"
bcmcmd=$(lsusb|grep "0a5c"|cut -d':' -f3)
bcmcmd1=$(lsusb|grep "7601"|cut -d':' -f3)
bcmver2="7601"

lsusb

#/home/app/script/info.sh

if [ $bcmver = $bcmcmd ];then
	/home/base/tools/bcmdl -n /home/app/localbin/nvram_wubb-738gn.txt /home/base/wifi/firmware/fw_bcmdhd_xy159.bin.trx -C 10 
	insmod /home/base/wifi/driver/bcmdhd.ko iface_name=wlan0
	himm 0x20120080 0x1c00        
	himm 0x20120080 0x1c20
	himm 0x20120080 0x1b0a 
	himm 0x20120080 0x1b2a
	echo "BCM" > /tmp/BCM
elif [ $bcmver1 = $bcmcmd ];then
	/home/base/tools/bcmdl -n /home/app/localbin/nvram_wubb-738gn.txt /home/base/wifi/firmware/fw_bcmdhd_xy159.bin.trx -C 10 
	insmod /home/base/wifi/driver/bcmdhd.ko iface_name=wlan0
	himm 0x20120080 0x1c00        
	himm 0x20120080 0x1c20
	himm 0x20120080 0x1b0a 
	himm 0x20120080 0x1b2a
	echo "BCM" > /tmp/BCM
elif [ $bcmver2 = $bcmcmd1 ];then
	himm 0x20180100 0
	sleep 1
	himm 0x20180100 0x40
	sleep 1
	insmod /home/base/wifi/driver/mt7601Usta.ko
	echo "MTK 7601" > /tmp/MTK
else
	insmod /home/base/wifi/driver/rtl8189fs.ko
	echo "realtech 8819fs"
fi

ifconfig wlan0 up

rm /etc/resolv.conf
ln -s /tmp/resolv.conf /etc/resolv.conf

cd /home/app
./log_server &
./dispatch &

# load custom kernel extensions if present
if [[ -d /tmp/sd/yi-hack-v3/lib/hi3518e ]]; then
  cd /tmp/sd/yi-hack-v3/lib/hi3518
  ./load3518e -i
  himm 0x201200cc 0xfe033144
  himm 0x201200c8 0x23c2e
  himm 0x201200d8 0x0d1ec001
  insmod hi_cipher.ko

  cd /home/app
  ./rmm &
  sleep 2

  if [[ -d /tmp/sd/yi-hack-v3/bin ]]; then
    cd /tmp/sd/yi-hack-v3/bin

    if [[ -f sample_venc ]]; then
      chmod 755 ./sample_venc
      ./sample_venc 0
    fi
    if [[ -f vencrtsp ]]; then
      chmod 755 ./vencrtsp
      ./vencrtsp &
    fi
  fi

  cd /home/app
  ./mp4record &
  #./cloud &
  #./p2p_tnp &
  #./oss &
  #./watch_process &
  #lua /home/app/script/cifs.luac /home/app/recbackup &
  #insmod /home/app/localko/watchdog.ko

# if we were unable to recover the original boot script,
# let's do what we think that script did
else
  cd /home/hisiko
  ./load3518e -i
  himm 0x201200cc 0xfe033144
  himm 0x201200c8 0x23c2e
  himm 0x201200d8 0x0d1ec001

  insmod /home/base/hi_cipher.ko
  cd /home/app
  ./rmm &
  sleep 2
  #./rtspsvr &
  ./mp4record &
  ./cloud &
  ./p2p_tnp &
  ./oss &
  ./watch_process &
  #lua /home/app/script/cifs.luac /home/app/recbackup &
  insmod /home/app/localko/watchdog.ko
fi
