# Migrate from NERC OpenShift and OpenShift AI (RHOAI)

This guide covers the process of migrating your workloads and data off the NERC
OpenShift (OCP) and Red Hat OpenShift AI (RHOAI) platforms.

## Overview

Migrating from NERC OpenShift and/or RHOAI involves four main phases:

1. **Bulk-Export All Project Configurations** — Export all application setups,
   configurations, and secrets into a reusable YAML file.

2. **Data Migration** — Transfer your data from OpenShift persistent storage,
   object storage (MinIO), and RHOAI workbenches/notebooks to your target platform.

3. **Backup Internal Container Images** — Pull images from the internal OpenShift
   registry and push them to an external registry.

4. **Decommissioning** — Delete all resources and archive your ColdFront project.

## Bulk-Export All Project Configurations

Export all application setups, configurations, and secrets within a specific
project into a single reusable YAML file:

```sh
oc get all,pod,deployment,deploymentconfig,pvc,route,service,build,buildconfig,
statefulset,replicaset,replicationcontroller,job,cronjob,imagestream,revision,
configuration,notebook -o yaml > openshift_backup.yaml
```

## Data Migration

Before decommissioning your resources, ensure all critical data has been migrated
to your target environment. NERC provides several methods for transferring data
from OCP and RHOAI.

### Persistent Storage (PVCs)

Copy data from PVCs to a pod's filesystem and then transfer it
to your target system. Refer to the
[Use Persistent Storage section](../openshift/storage/data-transfer-from-to-openshift.md#use-persistent-storage)
of the Data Transfer guide for detailed instructions on the following methods:

-   **`oc rsync`** — Recommended for transferring directories between your local
    machine and a pod. Efficient for repeat transfers as it only copies changed
    files. See [Using `oc rsync`](../openshift/storage/data-transfer-from-to-openshift.md#using-oc-rsync).

-   **`oc cp`** — Convenient for copying individual files or small directories
    to/from a container. See
    [Copying a Single File](../openshift/storage/data-transfer-from-to-openshift.md#copying-a-single-file).

-   **`tar` with `oc exec`** — Stream a tar archive through a pod for efficient
    directory transfers. See
    [Using `tar` with `oc exec`](../openshift/storage/data-transfer-from-to-openshift.md#using-tar-with-oc-exec).

-   **Transfer data directly to a PVC** — Run a temporary pod that mounts the PVC
    and transfer data using `oc rsync` or `oc cp`. See
    [Transferring Data Directly to a PVC](../openshift/storage/data-transfer-from-to-openshift.md#transferring-data-directly-to-a-pvc).

-   **Transfer between two PVCs** — Run a pod that mounts both PVCs and copy data
    between them. See
    [Transferring Between Two PVCs](../openshift/storage/data-transfer-from-to-openshift.md#transferring-between-two-pvcs).

For help choosing the right method, see the
[Choosing a Transfer Method](../openshift/storage/data-transfer-from-to-openshift.md#choosing-a-transfer-method)
table.

### Object Storage (MinIO)

If you use [MinIO](../openshift/storage/minio.md) for object storage on your
OpenShift project, export your data using the following approaches documented
in the
[For Object Storage Setup on NERC OCP](../openshift/storage/data-transfer-from-to-openshift.md#for-object-storage-setup-on-nerc-ocp)
section:

-   **MinIO Web Console** — Upload and download data through the browser-based
    interface. See [Using MinIO](../openshift/storage/data-transfer-from-to-openshift.md#using-minio).

-   **Rclone** — Sync, copy, or mount object storage for transfer to any supported
    destination. See [Using Rclone](../openshift/storage/data-transfer-from-to-openshift.md#using-rclone).

-   **Rclone workbench (RHOAI)** — Deploy an Rclone-based workbench through RHOAI
    to manage transfers via a web interface. See
    [Using RHOAI Rclone Workbench](../openshift/storage/Rclone.md).

### RHOAI Workbenches, Notebooks, and Cluster Storage

For users of Red Hat OpenShift AI (RHOAI):

1. **Notebook data** — Connect to your JupyterLab environment (see
   [Explore the JupyterLab Environment](../openshift-ai/data-science-project/explore-the-jupyterlab-environment.md))
   and download any data, models, or notebooks from the workbench's filesystem.

2. **Data Science Projects** — Review your data science project resources (see
   [Using Your Data Science Project (DSP)](../openshift-ai/data-science-project/using-projects-the-rhoai.md))
   and export any stored artifacts, trained models, or pipelines.

3. **Cluster storage** — All RHOAI cluster storage is backed by PVCs in your
   OpenShift project to store your Jupyter notebooks and associated data, ensuring
   that your work remains persistent. You can download the data as described in
   [Persistent Storage (PVCs)](#persistent-storage-pvcs) above.

!!! note "Important"

    The PVC backing a workbench's cluster storage includes all files uploaded to
    that workbench. When you download the PVC data, you will also get all
    notebooks, applications, and data stored on that workbench.

## Backup Internal Container Images

If you have images stored in the internal OpenShift registry (ImageStreams),
pull them to your local machine and push them to an external registry:

```sh
# Log in to the OpenShift registry via docker or podman
podman login -u $(oc whoami) -p $(oc whoami -t) $(oc registry info)

# Pull the image to your local machine
podman pull $(oc registry info)/<project-name>/<image-name>:<tag>

# Tag and push to an external registry (e.g., Quay or Docker Hub)
podman tag $(oc registry info)/<project-name>/<image-name>:<tag> quay.io/<username>/<image-name>:<tag>
podman push quay.io/<username>/<image-name>:<tag>
```

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
