# Network File System (NFS)

NFS enables a system to share directories and files with others over a network.
With NFS, users and applications can access files on remote systems as if they
were stored locally. Client systems mount a directory hosted on the NFS server,
allowing them to access and work with the files it contains.

## Pre-requisite

We are using following setting for this purpose to setup the NFS server and
client on Ubuntu based NERC OpenStack VM:

-   1 Linux machine for the **NFS Server**, `ubuntu-22.04-x86_64`, `cpu-su.1` flavor
    with 1vCPU, 4GB RAM, 20GB storage - also [assign Floating IP](../../openstack/create-and-connect-to-the-VM/assign-a-floating-IP.md).
    Please note the NFS Server's Internal IP i.e. `<NFS_SERVER_INTERNAL_IP>`
    i.e. `192.168.0.73` in this example.

-   1 Linux machine for the **NFS Client**, `ubuntu-22.04-x86_64`, `cpu-su.1` flavor
    with 1vCPU, 4GB RAM, 20GB storage - also [assign Floating IP](../../openstack/create-and-connect-to-the-VM/assign-a-floating-IP.md).

-   ssh access to both machines: [Read more here](../../openstack/create-and-connect-to-the-VM/bastion-host-based-ssh/index.md)
    on how to set up SSH on your remote VMs.

-   Create a security group with a rule that opens **Port 2049** (the default
    _NFS_ port) for file sharing. Update Security Group to the **NFS Server** VM
    only following [this reference](../../openstack/access-and-security/security-groups.md#update-security-groups-to-a-running-vm).

## Installing and configuring NFS Server

1.  Update System Packages:

    ```sh
    sudo apt-get update && sudo apt-get upgrade -y
    ```

2.  Install NFS Kernel Server:

    ```sh
    sudo apt install nfs-kernel-server -y
    ```

3.  Create a directory you want to share over the network:

    ```sh
    sudo mkdir -p /mnt/nfs_share
    ```

4.  Set the ownership and permissions to allow access (adjust based on requirements):

    Since we want all the client machines to access the shared directory, remove
    any restrictions in the directory permissions.

    ```sh
    sudo chown -R nobody:nogroup /mnt/nfs_share/
    ```

    You can also tweak the file permissions to your preference. Here's we have given
    the read, write and execute privileges to all the contents inside the directory.

    ```sh
    sudo chmod 777 /mnt/nfs_share/
    ```

5.  Configure NFS Exports:

    Edit the `/etc/exports` file to define shared directories and permissions.
    Permissions for accessing the NFS server are defined in the `/etc/exports` file.
    So open the file using your favorite text editor i.e. nano editor:

    ```sh
    sudo nano /etc/exports
    ```

    !!! tip "Define Shared Directories and Permissions"

        You can provide access to a single client, multiple clients, or specify
        an entire subnet.

        To grant access to a single client, use the syntax:

        ```sh
        /mnt/nfs_share  Client_Internal_IP_1(rw,sync,no_subtree_check)
        ```

        For multiple clients, specify each client on a separate file:

        ```sh
        /mnt/nfs_share  Client_Internal_IP_1(rw,sync,no_subtree_check)
        /mnt/nfs_share  Client_Internal_IP_2(rw,sync,no_subtree_check)
        ```

    Add a line like this to share the directory with read/write permissions for a
    subnet (e.g., 192.168.1.0/24):

    ```sh
    /mnt/nfs_share 192.168.1.0/24(rw,sync,no_subtree_check)
    ```

    **Explanation:**

    -   **rw**: Read and write access.
    -   **sync**: Changes are written to disk immediately.
    -   **no_subtree_check**: Avoid permission issues for subdirectories.

    !!! info "Other Options for Directory Permissions for the NFS share directory"

        You can configure the shared directories to be exported by adding them to
        the `/etc/exports` file. For example:

        ```
        /srv     *(ro,sync,subtree_check)
        /home    *.hostname.com(rw,sync,no_subtree_check)
        /scratch *(rw,async,no_subtree_check,no_root_squash)
        ```

        For more information [read here](https://ubuntu.com/server/docs/network-file-system-nfs#configuration).

6.  Apply Export Settings with the shared directories:

    ```sh
    sudo exportfs -rav
    ```

7.  Retart NFS Service:

    ```sh
    sudo systemctl restart nfs-kernel-server
    ```

## Configure the NFS Client on the Client VM

1. Update System Packages:

    ```sh
    sudo apt-get update && sudo apt-get upgrade -y
    ```

2. On the Client VM, install the required NFS package:

    ```sh
    sudo apt install nfs-common -y
    ```

3. Create a Mount Point:

    Create a local directory where the shared NFS directory will be mounted:

    ```sh
    sudo mkdir -p /mnt/nfs_clientshare
    ```

4. Testing connectivity between the Client and Server using the `showmount` command:

    ```sh
    showmount --exports <NFS_SERVER_INTERNAL_IP>
    ```

    For e.g.,

    ```sh
    showmount --exports 192.168.0.73

    Export list for 192.168.0.73:
    /mnt/nfs_share 192.168.0.0/24
    ```

5. Mount the Shared Directory:

    Use the `mount` command to connect to the **NFS Server** and mount the directory.

    ```sh
    sudo mount -t nfs <NFS_SERVER_INTERNAL_IP>:/mnt/nfs_share /mnt/nfs_clientshare
    ```

    For e.g.,

    ```sh
    sudo mount -t nfs 192.168.0.73:/mnt/nfs_share /mnt/nfs_clientshare
    ```

6. Verify the Mount:

    Check if the directory is mounted successfully.

    ```sh
    df -h
    ```

You should see the NFS share listed that is mounted and accessible.

!!! info "How to **Unmount** Shared Directory, if not needed!"

    When you're finished with a mount, we can unmount it with the `umount` command.

    ```sh
    sudo umount /mnt/nfs_clientshare
    ```

## Make the Mount Persistent on the Client VM

An alternate way to mount an NFS share from another machine is to add a line to
the `/etc/fstab` file. The line must state the Floating IP of the **NFS Server**,
the directory on the _NFS Server_ being exported, and the directory on the local
Client VM where the NFS share is to be mounted. This will ensure the NFS share
is mounted automatically even after the Client VM is rebooted at the boot time.

The general syntax for the line in `/etc/fstab` file is as follows:

```sh
example.hostname.com:/srv /opt/example nfs rsize=8192,wsize=8192,timeo=14,intr
```

1. Edit `/etc/fstab` Open the file:

    ```sh
    sudo nano /etc/fstab
    ```

2. Add an entry like this:

    ```sh
    <NFS_SERVER_INTERNAL_IP>:/mnt/nfs_share /mnt/nfs_clientshare nfs defaults 0 0
    ```

    For e.g.,

    ```sh
    192.168.0.73:/mnt/nfs_share /mnt/nfs_clientshare nfs defaults 0 0
    ```

3. Test the Configuration Unmount and remount all filesystems listed in `/etc/fstab`:

    ```sh
    sudo umount /mnt/nfs_clientshare
    sudo mount -a
    ```

4. Verify the Mount:

    Check if the directory is mounted successfully.

    ```sh
    df -h
    ```

## Test the Setup

-   On the **NFS Server**, write a test file:

    ```sh
    echo "Hello from NFS Server" | sudo tee /mnt/nfs_share/test.txt
    ```

-   On the **NFS Client**, verify the file is accessible:

    ```sh
    cat /mnt/nfs_clientshare/test.txt
    ```

---
