# Create An Empty Volume

An empty volume is like an unformatted USB stick. We'll attach it to an
instance, create a filesystem on it, and mount it to the instance.

## Using Horizon dashboard

Once you're logged in to NERC's Horizon dashboard, you can create a volume via
the "Volumes -> Volumes" page by clicking on the "Create Volume" button.

Navigate to Project -> Volumes -> Volumes.

![Volumes](images/volumes.png)

Click "Create Volume".

In the Create Volume dialog box, give your volume a name. The description
field is optional.

![Create Volume](images/create_volume.png)

Choose "empty volume" from the Source dropdown. This will create a volume that
is like an unformatted hard disk. Choose a size (In GiB) for your volume.
Leave Type and Availibility Zone as it as. Only admin to the NERC OpenStack
will be able to manage volume types.

Click "Create Volume" button.

Checking the status of created volume will show:

"downloading" means that the volume contents is being transferred from the image
service to the volume service

In a few moments, the newly created volume will appear in the Volumes list with
the Status "available". "available" means the volume can now be used for booting.
A set of volume_image meta data is also copied from the image service.

![Volumes List](images/volumes_list.png)

## Using the CLI

**Prerequisites**:

To run the OpenStack CLI commands, you need to have:

- OpenStack CLI setup, see [OpenStack Command Line setup](../openstack-cli/openstack-CLI.md#command-line-setup)
  for more information.

To create a volume using the CLI, do this:

### Using the openstack client

This allows an arbitrary sized disk to be attached to your virtual machine, like
plugging in a USB stick. The steps below create a disk of 20GB with name "my-volume".

    openstack volume create --size 20 my-volume

    +---------------------+--------------------------------------+
    | Field               | Value                                |
    +---------------------+--------------------------------------+
    | attachments         | []                                   |
    | availability_zone   | nova                                 |
    | bootable            | false                                |
    | consistencygroup_id | None                                 |
    | created_at          | 2024-02-03T17:06:05.000000           |
    | description         | None                                 |
    | encrypted           | False                                |
    | id                  | 5b5380bd-a15b-408b-8352-9d4219cf30f3 |
    | multiattach         | False                                |
    | name                | my-volume                            |
    | properties          |                                      |
    | replication_status  | None                                 |
    | size                | 20                                   |
    | snapshot_id         | None                                 |
    | source_volid        | None                                 |
    | status              | creating                             |
    | type                | tripleo                              |
    | updated_at          | None                                 |
    | user_id             | 938eb8bfc72e4ca3ad2b94e2eb4059f7     |
    +---------------------+--------------------------------------+

### To view newly created volume

    openstack volume list
    +--------------------------------------+-----------------+-----------+------+----------------------------------+
    | ID                                   | Name            | Status    | Size | Attached to                      |
    +--------------------------------------+-----------------+-----------+------+----------------------------------+
    | 563048c5-d27b-4397-bb4e-034e0f4d9fa7 |                 | in-use    |   20 | Attached to test-vm on /dev/vda  |
    | 5b5380bd-a15b-408b-8352-9d4219cf30f3 | my-volume       | available |   20 |                                  |
    +--------------------------------------+-----------------+-----------+------+----------------------------------+

---
