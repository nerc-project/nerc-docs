# Attach The Volume To An Instance

## Using Horizon dashboard

Once you're logged in to [NERC's Horizon dashboard](https://stack.nerc.mghpcc.org).

Navigate to _Project -> Volumes -> Volumes_.

In the Actions column, click the dropdown and select "Manage Attachments".

![Volume Dropdown Options](images/volume_options.png)

From the menu, choose the instance you want to connect the volume to from
Attach to Instance, and click "Attach Volume".

![Attach Volume](images/volume_attach.png)

The volume now has a status of "In-use" and "Attached To" column shows which
instance it is attached to, and what device name it has.

This will be something like `/dev/vdb` but it can vary depending on the state
of your instance, and whether you have attached volumes before.

Make note of the device name of your volume.

![Attaching Volume Successful](images/volume_in_use.png)

## Using the CLI

**Prerequisites**:

To run the OpenStack CLI commands, you need to have:

-   OpenStack CLI setup, see [OpenStack Command Line setup](../openstack-cli/openstack-CLI.md#command-line-setup)
    for more information.

To attach the volume to an instance using the CLI, do this:

### Using the openstack client

When the status is 'available', the volume can be attached to a virtual machine
using the following openstack client command syntax:

```sh
openstack server add volume <INSTANCE_NAME_OR_ID> <VOLUME_NAME_OR_ID>
```

For example:

```sh
openstack server add volume test-vm my-volume
+-----------------------+--------------------------------------+
| Field                 | Value                                |
+-----------------------+--------------------------------------+
| ID                    | 5b5380bd-a15b-408b-8352-9d4219cf30f3 |
| Server ID             | 8a876a17-3407-484c-85c4-8a46fbac1607 |
| Volume ID             | 5b5380bd-a15b-408b-8352-9d4219cf30f3 |
| Device                | /dev/vdb                             |
| Tag                   | None                                 |
| Delete On Termination | False                                |
+-----------------------+--------------------------------------+
```

where "test-vm" is the virtual machine and the second parameter, "my-volume" is
the volume created before.

!!! tip "Pro Tip"

    If your instance name `<INSTANCE_NAME_OR_ID>` and volume name `<VOLUME_NAME_OR_ID>`
    include spaces, you need to enclose them in quotes, i.e. `"<INSTANCE_NAME_OR_ID>"`
    and `"<VOLUME_NAME_OR_ID>"`.

    For example: `openstack server remove volume "My Test Instance" "My Volume"`.

### To verify the volume is attached to the VM

```sh
openstack volume list
+--------------------------------------+-----------------+--------+------+----------------------------------+
| ID                                   | Name            | Status | Size | Attached to                      |
+--------------------------------------+-----------------+--------+------+----------------------------------+
| 563048c5-d27b-4397-bb4e-034e0f4d9fa7 |                 | in-use |   20 | Attached to test-vm on /dev/vda  |
| 5b5380bd-a15b-408b-8352-9d4219cf30f3 | my-volume       | in-use |   20 | Attached to test-vm on /dev/vdb  |
+--------------------------------------+-----------------+--------+------+----------------------------------+
```

The volume now has a status of "in-use" and "Attached To" column shows which
instance it is attached to, and what device name it has.

This will be something like `/dev/vdb` but it can vary depending on the state
of your instance, and whether you have attached volumes before.

---
