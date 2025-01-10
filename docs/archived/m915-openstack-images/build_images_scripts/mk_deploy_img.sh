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
elif [ ! -f /bin/pax ]
then
   echo "Missing utility, need to run: 'dnf install spax'"
   exit 1
fi

mkdir $MYWDIR/tmp.overcloud-full.initrd
cd $MYWDIR/tmp.overcloud-full.initrd
/usr/lib/dracut/skipcpio $MYWDIR/src_extracted/overcloud-full.initrd |zcat | cpio -ivd |pax -r
cp -f lib/modules/$KVER.x86_64/kernel/drivers/scsi/mpt3sas/mpt3sas.ko.xz lib/modules/$KVER.x86_64/kernel/drivers/scsi/mpt3sas/mpt3sas.ko.xz.orig
cp -f $MYWDIR/src_extracted/mpt3sas.ko.xz lib/modules/$KVER.x86_64/kernel/drivers/scsi/mpt3sas/mpt3sas.ko.xz
mkdir lib/modules/$KVER.x86_64/orig
cp lib/modules/$KVER.x86_64/modules.* lib/modules/$KVER.x86_64/orig/
depmod -b $MYWDIR/tmp.overcloud-full.initrd $KVER.x86_64
find . 2>/dev/null | cpio --quiet -c -o | gzip -8 > $MYWDIR/built/overcloud-full-custom.initrd

cp $MYWDIR/src_extracted/overcloud-full.vmlinuz $MYWDIR/built/overcloud-full-custom.vmlinuz
