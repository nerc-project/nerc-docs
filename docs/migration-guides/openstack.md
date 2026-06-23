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
and provides status updates.

-   **Object Storage (Swift/S3)** — Upload data to NERC object storage containers,
then download to your target system.

-   **Volume transfer** — Transfer an entire volume (with all its data) to another
project.

-   **Standard network transfer** — Use `scp`, `rsync`, or other standard tools.

### Object Storage Data

Data stored in OpenStack Object Storage (Swift) containers can be:

-   Downloaded directly via the Horizon dashboard or Swift/S3 API.

-   Migrated using `juicefs sync` as described in the
[Mount The Object Storage guide](../openstack/persistent-storage/mount-the-object-storage.md#juicefs-sync).

-   Transferred to any S3-compatible target using S3 clients.

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
