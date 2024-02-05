# Decommission a VM

Make sure you backup your critical data or configuration from the virtual machines.
You can follow [this guide](../data-transfer/data-transfer-from-to-vm.md) to
initiate and perform data transfer from/to the VM.

## VM deletion

VMs can be deleted using either the OpenStack dashboard or via the openstack client
`openstack server delete` command.

!!! danger "Important Note"
    This will immediately terminate the instance, delete all content of the
    virtual machine and erase the disk. This operation is not recoverable.

There are other options available if you wish to keep the virtual machine for
future usage. These do, however, continue to use quota for the project even though
the VM is not running.

- **Suspend the VM** which saves the state of the VM to disk so it could be restarted
later

- **Snapshot the VM** to keep an offline copy of the virtual machine

If however, the virtual machine is no longer required and no data on the
associated system or ephemeral disk needs to be preserved, the following command
can be run:

    openstack server delete <INSTANCE_NAME_OR_ID>

The quota associated with this virtual machine will be returned to the project
and you can review and verify that looking at your
[OpenStack dashboard overview](../logging-in/dashboard-overview.md#compute-panel).

Navigate to Project -> Compute -> Overview.

If the quota does not return, please raise a ticket.

## Delete volumes and snapshots

To delete volume(s), please read [this documentation](../persistent-storage/delete-volumes.md).

To delete snapshot(s),

## Delete all containers and objects

## Release any Floating IPs

## Delete all custom Networks and Routers

## Clean up all Security Groups except `default`

## Delete all custom built Images

## Delete all of your stored Key Pairs

## Review your OpenStack Dashboard

## ColdFront to reduce the Storage Quota to Zero

- Flavor
- Image
- Network
- Security Group
- Key Name

---
