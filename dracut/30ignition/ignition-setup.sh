#!/bin/bash
set -eu

copy_file() {
    src="${1}"; dst="${2}"
    if [ -f "${src}" ]; then
        echo "Copying ${src} to ${dst}"
        cp "${src}" "${dst}"
    else
        echo "File ${src} does not exist.. Skipping copy"
    fi
}

destination=/usr/lib/ignition/
mkdir -p $destination

# We will support grabbing a platform specific base.ign config
# from the initrd at /usr/lib/ignition/platform/${OEM_ID}/base.ign
copy_file "/usr/lib/ignition/platform/${OEM_ID}/base.ign" "${destination}/base.ign"

# We will support a user embedded config in the boot partition
# under $bootmnt/ignition/config.ign
bootmnt=/mnt/boot_partition
mkdir -p $bootmnt
mount /dev/disk/by-label/boot $bootmnt
copy_file "${bootmnt}/ignition/config.ign" "${destination}/user.ign"
umount $bootmnt
