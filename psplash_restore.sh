#!/bin/sh
# Fix /boot/splash/psplash if it is missing or its contents are missing

# Mount /dev/mmcblk1p2 to /boot/splash if not mounted
if ! grep -qs "/boot/splash" /proc/mounts; then
    printf "[INFO] %s\n" "Splash partition is not mounted. Attempting to mount..."
    if ! block mount "/dev/mmcblk1p2" "/boot/splash"; then
        printf "[ERROR] %s\n" "Failed to mount splash partition."
        exit 1
    else
        printf "[INFO] %s\n" "Splash partition mounted successfully." 
    fi
else 
    printf "[INFO] %s\n" "Splash partition is already mounted."
fi

# Create /boot/splash/psplash if it does not exist
mkdir -p "/boot/splash/psplash"

# Bind mount it to /usr/share/psplash
if ! mount --bind /boot/splash/psplash /usr/share/psplash/; then                                          
    printf "[ERROR] %s\n" "Failed to bind mount splash partition to /usr/share/psplash."
    exit 1                                                                                 
else                                                                                             
    printf "[INFO] %s\n" "Successfully bind mounted splash partition to /usr/share/psplash."
fi                                                                                           

# Copy images from /rom/usr/share/psplash to /usr/share/psplash
found=0
for src in /rom/usr/share/psplash/*.png; do
    [ -e "$src" ] || continue
    found=1
    printf "[INFO] Found file: %s\n" "$src"
    printf "[INFO] Copying it to destination\n"
    cp -fP "$src" "/usr/share/psplash/"
done

if [ "$found" -eq 0 ]; then
    printf "[ERROR] %s\n" "No PNG files found in /rom/usr/share/psplash."
fi
printf "[INFO] %s\n" "Done"



