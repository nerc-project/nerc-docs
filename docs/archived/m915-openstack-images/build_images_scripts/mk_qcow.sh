#!/bin/sh -e

KVER=4.18.0-193.51.1.el8_2

if [ -z $MYWDIR ]
then
  echo "Check MYWDIR environment variable"
  exit 1
elif [ ! -d $MYWDIR/src_extracted ]
then
   echo "Missing $MYWDIR/src_extracted directory"
   exit 1
elif [ ! -f /bin/guestmount ]
then
   echo "Missing utility, need to run: 'dnf install libguestfs-tools'"
   echo "also run:  'systemctl start libvirtd'"
   echo "and 'dnf update libgcrypt'"
   exit 1
elif [ `rpm -q libgcrypt` != "libgcrypt-1.8.5-4.el8.x86_64" ]
then
   echo "untested version of ligcrypt found. test guestmount by hand, and update gcrypt or fix this script"
   exit 1
fi

cd $MYWDIR

mkdir -p /tmp/img_mount
mkdir -p /tmp/img_build
cp $MYWDIR/src_extracted/overcloud-full.qcow2 /tmp/img_build/overcloud-full-custom.qcow2

#### investigate if this  helps to use different paths or run in containers?
#### keep commented out until then
###export LIBGUESTFS_BACKEND=direct'


guestmount -a /tmp/img_build/overcloud-full-custom.qcow2 -m /dev/sda /tmp/img_mount

TARGET_MODULE_DIR=/tmp/img_mount/lib/modules/$KVER.x86_64
TARGET_DRIVER=$TARGET_MODULE_DIR/kernel/drivers/scsi/mpt3sas/mpt3sas.ko.xz

cp $TARGET_DRIVER $TARGET_DRIVER.orig
cp $MYWDIR/src_extracted/mpt3sas.ko.xz $TARGET_DRIVER

mkdir $TARGET_MODULE_DIR/orig
cp $TARGET_MODULE_DIR/modules.* $TARGET_MODULE_DIR/orig/

#depmod -b /tmp/img_mount $KVER.x86_64
mv /tmp/img_mount/boot/initramfs-$KVER.x86_64.img /tmp/img_mount/boot/initramfs-$KVER.x86_64.img.bak
cp $MYWDIR/built/overcloud-full-custom.initrd /tmp/img_mount/boot/initramfs-$KVER.x86_64.img

guestunmount /tmp/img_mount
sync
sleep 5
sync

virt-customize --selinux-relabel -a /tmp/img_build/overcloud-full-custom.qcow2 --run-command "depmod $KVER.x86_64"
virt-sysprep --operation machine-id -a /tmp/img_build/overcloud-full-custom.qcow2

cp /tmp/img_build/overcloud-full-custom.qcow2 $MYWDIR/built/
