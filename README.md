# PSplash Hotfix SWU
## Description
This hotfix restores proper psplash functionality on the device.

## Build .swu package
```
cpio -ov -H crc <<EOF > psplash_fix.swu
sw-description
psplash_restore.sh
EOF
```
