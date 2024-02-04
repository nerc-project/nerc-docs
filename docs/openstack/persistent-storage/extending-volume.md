# Extending Volume

A volume can be made larger while maintaining the existing contents, assuming the
file system supports resizing. We can extend a volume that is not attached to any
VM and in **"Available"** status.

The steps are as follows:

- Extend the volume to its new size

- Extend the filesystem to its new size

## Using Horizon dashboard

Once you're logged in to NERC's Horizon dashboard.

Navigate to Project -> Volumes -> Volumes.

![Extending Volume](images/extending_volumes.png)

Specify, the new extened size in GB:

![Volume New Extended Size](images/volume_new_extended_size.png)

## Using the CLI

**Prerequisites**:

To run the OpenStack CLI commands, you need to have:

- OpenStack CLI setup, see [OpenStack Command Line setup](../openstack-cli/openstack-CLI.md#command-line-setup)
  for more information.

### Using the openstack client

The existing volume "my-volume" can be extended to a new size of 100 GB for
the previous 80 GB by running the following command:

    openstack volume set --size 100 my-volume

For windows systems, please follow the [provider documentation](https://docs.microsoft.com/en-us/windows-server/storage/disk-management/extend-a-basic-volume).

!!! info "Please note"
    - Volumes can be made larger, but not smaller. There is no support for
    shrinking existing volumes.
    - The procedure given above has been tested with ext4 and XFS filesystems only.

---
