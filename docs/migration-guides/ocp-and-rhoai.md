# Migrate from NERC OpenShift and OpenShift AI (RHOAI)

This guide covers the process of migrating your workloads and data off the NERC
OpenShift (OCP) and Red Hat OpenShift AI (RHOAI) platforms.

## Overview

Migrating from NERC OpenShift and/or RHOAI involves two main phases:

1. **Data Migration** — Transfer your data from OpenShift persistent storage,
object storage (MinIO), and RHOAI workbenches/notebooks to your target platform.

2. **Decommissioning** — Delete all resources and archive your ColdFront project.

## Data Migration

Before decommissioning your resources, ensure all critical data has been migrated
to your target environment. NERC provides several methods for transferring data
from OCP and RHOAI.

### Data Transfer from OpenShift

Refer to the [Data Transfer To and From NERC OpenShift](../openshift/storage/data-transfer-from-to-openshift.md)
guide for detailed instructions on the following methods:

-   **`oc rsync`** — Recommended for transferring directories between your local
machine and a pod. Efficient for repeat transfers as it only copies changed files.

-   **`oc cp`** — Convenient for copying individual files or small directories
to/from a container.

-   **Object storage with `rclone`** — Use [Rclone](../openshift/storage/Rclone.md)
for large or resumable transfers. Rclone can copy data between MinIO, S3-compatible
storage, and your target system.

-   **Globus** — Preferred method for large datasets (see the OpenStack data transfer
guide for Globus setup, as the same Globus endpoint can be used).

### Persistent Volume Claims (PVCs)

Data stored on PVCs should be copied to a pod's filesystem (via `oc rsync` or
`oc cp`) and then transferred to your target system. Alternatively, use `rclone`
configured with MinIO credentials to move data directly from MinIO-backed PVCs.

### MinIO Object Storage

If you use MinIO for object storage, refer to the [MinIO guide](../openshift/storage/minio.md)
for accessing and exporting your data. Rclone can be configured to sync data from
MinIO to any S3-compatible target.

### RHOAI Workbenches and Notebooks

For users of Red Hat OpenShift AI (RHOAI):

1. **Notebook data** — Connect to your JupyterLab environment (see
[Explore the JupyterLab Environment](../openshift-ai/data-science-project/explore-the-jupyterlab-environment.md))
and download any data, models, or notebooks from the workbench's filesystem.

2. **Data Science Projects** — Review your data science project resources (see
[Using Your Data Science Project (DSP)](../openshift-ai/data-science-project/using-projects-the-rhoai.md))
and export any stored artifacts, trained models, or pipelines.

3. **S3 data** — If you access data via S3 within RHOAI, see the guide on
[how to access, download, and analyze data for S3 usage](../openshift-ai/other-projects/how-access-s3-data-then-download-and-analyze-it.md).

## Decommissioning

Once your data has been safely migrated, follow the
[Decommission OpenShift Resources](../openshift/decommission/decommission-openshift-resources.md)
guide to:

1. Delete all resources (pods, deployments, PVCs, routes, services, builds, etc.)

2. Remove users from your ColdFront project (optional)

3. Reduce all resource quotas to zero via a ColdFront change request

4. Review project resource quotas

5. Archive your ColdFront project

---
