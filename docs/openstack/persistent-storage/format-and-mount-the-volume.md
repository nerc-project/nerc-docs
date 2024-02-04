# Format And Mount The Volume

## For Linux based virtual machine

SSH to your instance.  You should now see the volume as an additional disk in
the output of `sudo fdisk -l` or `lsblk` or `cat /proc/partitions`.

    # lsblk
    NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    ...
    vda     254:0    0   10G  0 disk
    ├─vda1  254:1    0  9.9G  0 part /
    ├─vda14 254:14   0    4M  0 part
    └─vda15 254:15   0  106M  0 part /boot/efi
    vdb     254:16   0    1G  0 disk

We see the volume here as the disk 'vdb', which matches the `/dev/vdb/` we
noted in "Attached To" column.

Create a filesystem on the volume and mount it - in the example we create an
`ext4` filesystem:

Run the following commands as `root` user:

    mkfs.ext4 /dev/vdb
    mkdir /mnt/test_volume
    mount /dev/vdb /mnt/test_volume
    df -H

The volume is now available at the mount point:

    lsblk
    NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    ...
    vda     254:0    0   10G  0 disk
    ├─vda1  254:1    0  9.9G  0 part /
    ├─vda14 254:14   0    4M  0 part
    └─vda15 254:15   0  106M  0 part /boot/efi
    vdb     254:16   0    1G  0 disk /mnt/test_volume

If you place data in the directory `/mnt/test_volume`, detach the volume, and
mount it to another instance, the second instance will have access to the data.

!!! note "Important Note"
    In this case it's easy to spot because there is only one additional disk attached
    to the instance, but it's important to keep track of the device name, especially
    if you have multiple volumes attached.

## For Windows virtual machine

Here we create an empty volume of 100 GB as described above:

![Create Volume for Windows VM](images/create_volume_win.png)

![Attach Volume to a running Windows VM](images/attach-volume-to-an-win-instance.png)

Login using the Floating IP attached to the Windows VM:

![Connect to Remote Instance using Floating IP](images/remote_connection_floating_ip.png)

![Prompted Administrator Login](images/prompted_administrator_login.png)

!!! warning "What is the user login for Windows Server 2022?"
    To connect with this Windows VM you need to contact us by emailing us at
    [help@nerc.mghpcc.org](mailto:help@nerc.mghpcc.org?subject=NERC%20Windows%20Server%20Login%20Info)
    or, by submitting a new ticket at [the NERC's Support Ticketing System](https://mghpcc.supportsystem.com/open.php)

![Successfully Remote Connected Instance](images/remote_connected_instance.png)

Once connected search for "Disk Management" from Windows search box. This will
show all attached disk as **Unknown** and **Offline** as shown here:

![Windows Disk Management](images/win_disk_management.png)

![Windows Set Disk Online](images/win_set_disk_online.png)

In Disk Management, you may be prompted to initialize the new disk.

![Windows Initialize Disk](images/win_initialize_disk.png)

Choose the appropriate partition style (usually MBR or GPT) and proceed.

![Windows Disk Partition Style](images/win_disk_partition_style.png)

Format the New Volume:

- Right-click on the unallocated space of the new disk.
- Select "New Simple Volume" and follow the wizard to create a new partition.

![Windows Simple Volume Wizard Start](images/win_disk_simple_volume.png)

- Choose the file system (usually NTFS for Windows).
- Assign a drive letter or mount point.

Complete Formatting:

- Complete the wizard to format the new volume.

- Once formatting is complete, the new volume should be visible in File Explorer
  as shown below:

![Windows Simple Volume Wizard Start](images/win_new_drive.png)

---
