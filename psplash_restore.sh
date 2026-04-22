#!/bin/sh
# Fix /boot/splash/psplash if it missing or content inside it is missing

# Mount /dev/mmcblk1p2 to /boot/splash if not
if ! grep -qs "/boot/splash" /proc/mounts; then
    printf "[INFO] %s\n" "Splash partition is not mounted. Attempting to mount..."
    if ! block mount "/dev/mmcblk1p2" "/boot/splash"; then
        printf "[ERROR] %s\n" "Failed to mount splash partition."
        exit 1
    else
        printf "[INFO] %s\n" "Successfully mounted splash partition."
    fi
else 
    printf "[INFO] %s\n" "Splash partition is already mounted."
fi

# Create /boot/splash/psplash
mkdir -p "/boot/splash/psplash"

# Bind it to /usr/share/psplash
if ! mount --bind /boot/splash/psplash /usr/share/psplash/; then                                          
    printf "[ERROR] %s\n" "Failed to bind mount splash partition to /usr/share/psplash."
    exit 1                                                                                 
else                                                                                             
    printf "[INFO] %s\n" "Successfully bind mounted splash partition to /usr/share/psplash."
fi                                                                                           

# Fill /usr/share/psplash with images from /rom/usr/share/psplash 
for src in /rom/usr/share/psplash/*.png; do
        printf "[INFO] %s %s\n" "Found file:" $src
    if [ -e "$src" ]; then
        printf "[INFO] %s\n" "File exist, copy it to destination"
        cp -fP "$src" "/usr/share/psplash/"
    fi
done

printf "[INFO] %s\n" "Done"



