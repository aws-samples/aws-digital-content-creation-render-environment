#!/usr/bin/env bash
mkdir -p /data
while [[ ! -b $(readlink -f /dev/xvdh) ]]; do echo "waiting for device /dev/xvdh"; sleep 5 ; done
blkid $(readlink -f /dev/xvdh) || mkfs -t ext4 $(readlink -f /dev/xvdh)
e2label $(readlink -f /dev/xvdh) dcc-data
grep -q ^LABEL=dcc-data /etc/fstab || echo 'LABEL=dcc-data /data ext4 defaults' >> /etc/fstab
grep -q "^$(readlink -f /dev/xvdh) /data " /proc/mounts || mount /data
