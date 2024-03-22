# Storage Overview

The NERC OCP supports multiple types of storage.

## Glossary of common terms for OCP storage

This glossary defines common terms that are used in the storage content.

### Storage

OCP supports many types of storage, both for on-premise and cloud providers. You
can manage container storage for persistent and non-persistent data in an OCP cluster.

### Storage class

A storage class provides a way for administrators to describe the classes of storage
they offer. Different classes might map to quality of service levels, backup policies,
arbitrary policies determined by the cluster administrators.

## Storage types

OCP storage is broadly classified into two categories, namely ephemeral storage
and persistent storage.

### Ephemeral storage

Pods and containers are ephemeral or transient in nature and designed for stateless
applications. Ephemeral storage allows administrators and developers to better manage
the local storage for some of their operations. For more information about ephemeral
storage overview, types, and management, see Understanding ephemeral storage.

Pods and containers can require temporary or transient local storage for their
operation. The lifetime of this ephemeral storage does not extend beyond the life
of the individual pod, and this ephemeral storage cannot be shared across pods.

### Persistent storage

Stateful applications deployed in containers require persistent storage. OCP uses
a pre-provisioned storage framework called persistent volumes (PV) to allow cluster
administrators to provision persistent storage. The data inside these volumes can
exist beyond the lifecycle of an individual pod. Developers can use persistent
volume claims (PVCs) to request storage requirements. For more information about
persistent storage overview, configuration, and lifecycle, see Understanding
persistent storage.

Pods and containers can require permanent storage for their operation. OpenShift
Container Platform uses the Kubernetes persistent volume (PV) framework to allow
cluster administrators to provision persistent storage for a cluster. Developers
can use PVC to request PV resources without having specific knowledge of the
underlying storage infrastructure.

### Persistent volumes (PV)

OCP uses the Kubernetes persistent volume (PV) framework to allow cluster
administrators to provision persistent storage for a cluster. Developers can use
PVC to request PV resources without having specific knowledge of the underlying
storage infrastructure.

### Persistent volume claims (PVCs)

You can use a PVC to mount a PersistentVolume into a Pod. You can access the
storage without knowing the details of the cloud environment.

!!! note "Important Note"
    A PVC is in active use by a pod when a Pod object exists that uses the PVC.

### Access modes

Volume access modes describe volume capabilities. You can use access modes to match
persistent volume claim (PVC) and persistent volume (PV). The following are the
examples of access modes:

| Storage Class    | Description                                                                                         |
|------------------|-----------------------------------------------------------------------------------------------------|
| ReadWriteOnce (RWO)| Allows read-write access to the volume by a single node at a time.                                   |
| ReadOnlyMany (ROX) | Allows multiple nodes to read from the volume simultaneously, but only one node can write to it.      |
| ReadWriteMany (RWX)| Allows multiple nodes to read from and write to the volume simultaneously.                           |
| ReadWriteOncePod (RWOP)| Allows read-write access to the volume by multiple pods running on the same node simultaneously.     |

---
