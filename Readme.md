# Features / Needs
This project is a Simple RTSP server running on yi ants (tested only on YHS-113-IR with Hi3518eV200 proc) hacked with yi-hack-v3 files

# Informations
CAM: YHS-113-IR (27US) from Amazon<br/>
SDK: Hi3518E_V200R001C01SPC040 - Hi3518E_SDK_V1.0.4.0<br/>
RTSP: based on https://github.com/LaurenLuoYun/vencrtsp<br/>
YI-HACK-V3: https://github.com/shadow-1/yi-hack-v3<br/>

# SD
Files to copy on sd cards.

startup.sh will replace yi init.sh file by an alternative version.<br/>
The new init.sh doesn't load yi ko files and apps but ko from SDK ver 040<br/>

./sample_venc 0 to encode stream in H264 (tested)<br/>
./vencrtsp to start RSTP server: (first version is not very stable and can "seg fault") and need to be fixed and improve


# Others
Yellow LED: GPIO0_3<br/>
- on<br/>
`himm 0x201403FC 0x1<br/>`
- off<br/>
`himm 0x201403FC 0x5<br/>`

Blue LED: Not find

IR-LED: Not find

IR-CUT:<br/>
- on<br/>
```
himm 0x201c000c 0x2<br/>
sleep 1;<br/>
himm 0x201c000c 0x0<br/>
```
        
- off<br/>
```
himm 0x201c000c 0x1<br/>
sleep 1;<br/>
himm 0x201c000c 0x0<br/>
```


