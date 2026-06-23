# Migrate from NERC OpenStack

This guide covers the process of migrating your workloads and data off the NERC
OpenStack platform. It covers data migration, resource cleanup, and project decommissioning.

## Overview

Migrating from NERC OpenStack involves two main phases:

1. **Data Migration** — Transfer your data from NERC OpenStack resources (volumes,
object storage, VM filesystems) to your target platform.

2. **Decommissioning** — Clean up all OpenStack resources and archive your ColdFront
project.

## Data Migration

Before decommissioning your resources, ensure all critical data has been migrated
to your target environment.

NERC provides several methods for transferring data:

### Data Transfer from VMs

To transfer data from your virtual machine's filesystem to an external location,
use one of the following methods documented in the
[Data Transfer To/From NERC VM](../openstack/data-transfer/data-transfer-from-to-vm.md)
guide:

-   **Globus** — Preferred method for large datasets; handles retries, error recovery,
    and provides status updates. Set up a personal Globus endpoint on your VM.

-   **SCP** — Secure copy for smaller files (<~10 GB) using SSH.

-   **tar+ssh** — Stream a tar archive over SSH for efficient directory transfers.

-   **rsync** — Fast, delta-transfer synchronization; ideal for repeat or incremental
    transfers.

-   **Rclone** — Sync, copy, or mount the VM's filesystem via SFTP for transfer to
    any supported destination.

-   **WinSCP** (Windows) — GUI-based SFTP/SCP client for drag-and-drop transfers.

-   **Cyberduck** (macOS/Windows) — GUI-based SFTP/FTP client.

-   **Filezilla** (cross-platform) — Open-source SFTP/FTP client.

!!! note "Data on Detached Volumes"

    If you have a detached volume with data that needs to be migrated, attach it
    to a running VM as described in the
    [Attach a Volume to an Instance guide](../openstack/persistent-storage/attach-the-volume-to-an-instance.md),
    then use any of the clients listed above to transfer the data from the VM to
    your target location.

### Object Storage Data

Data stored in OpenStack Object Storage (Swift) containers can be migrated
using any of the clients documented in the
[Object Storage guide](../openstack/persistent-storage/object-storage.md):

-   **Horizon Dashboard** — Download files through the web interface.

-   **OpenStack CLI** — Use `openstack object store` commands to download objects.

-   **Swift Interface** — Use the `swift` command-line client (`python-swiftclient`)
    to download or sync data.

-   **AWS CLI** — Use S3-compatible `aws s3` commands with the NERC endpoint.

-   **s3cmd** — Sync or copy data from containers to your local system or another
    S3 target.

-   **Rclone** — Sync, copy, or mount object storage for transfer to any supported
    destination.

-   **Python libraries (Boto3, Minio)** — Programmatically download objects using
    the S3 API.

-   **GUI tools (WinSCP, Cyberduck)** — Connect via S3 protocol for a file-browser
    experience.

!!! note "Mount Object Storage to a VM"

    You can also mount your object storage container to a running instance as
    described in the
    [Mount The Object Storage to an Instance guide](../openstack/persistent-storage/mount-the-object-storage.md),
    then use any of the clients listed in [Data Transfer from VMs](#data-transfer-from-vms)
    to download the data from the VM, just like data on a mounted volume.

## Decommissioning

Once your data has been safely migrated, follow the
[Decommission Your NERC OpenStack Resources](../openstack/decommission/decommission-openstack-resources.md)
guide to:

1. Delete all VMs

2. Delete volumes and snapshots

3. Delete custom images

4. Delete private networks, routers, and interfaces

5. Release floating IPs

6. Clean up security groups

7. Delete key pairs

8. Delete buckets and objects

9. Remove users from your ColdFront project (optional)

10. Reduce storage quotas to zero

11. Review project resource quotas

12. Archive your ColdFront project

---
