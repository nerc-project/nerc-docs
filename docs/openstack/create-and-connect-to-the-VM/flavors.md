# Nova flavors

In NERC OpenStack, flavors define the compute, memory, and storage capacity of
nova computing instances. In other words, a flavor is an available hardware
configuration for a server.

!!! info "Note"
    Flavors are visible only while you are launching an instance and under "Flavor"
    tab as [explained here](../create-and-connect-to-the-VM/launch-a-VM.md#flavor-tab).

The important fields are

| Field      | Description                                      |
|------------|--------------------------------------------------|
| RAM        | Memory size in MB                                |
| Disk       | Size of disk in GB                               |
| Ephemeral  | Size of a second disk. 0 means no second disk is defined and mounted. |
| VCPUs      | Number of virtual cores                          |

## Currently, our setup supports and offers the following flavors

NERC offers the following flavors based on our Infrastructure-as-a-Service
(IaaS) - OpenStack offerings (Tiers of Service).

!!! tip "Pro Tip"
    Choose a flavor for your instance from the available Tier that suits your
    requirements, use-cases, and budget when launching a VM as [shown here](../create-and-connect-to-the-VM/launch-a-VM.md#flavor-tab).

### 1. Standard Compute Tier

The standard compute flavor **"cpu-su"** is provided from Lenovo SD530 (2x Intel
8268 2.9 GHz, 48 cores, 384 GB memory) server. The base unit is 1 vCPU, 4 GB
memory with default of 20 GB root disk at a rate of $0.013 / hr of wall time.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|---------------|-----|-----|-------|---------|-------------|-----------|
|cpu-su.1       |1    |0    |1      |4        |20           |$0.013     |
|cpu-su.2       |2    |0    |2      |8        |20           |$0.026     |
|cpu-su.4       |4    |0    |4      |16       |20           |$0.052     |
|cpu-su.8       |8    |0    |8      |32       |20           |$0.104     |
|cpu-su.16      |16   |0    |16     |64       |20           |$0.208     |

### 2. Memory Optimized Tier

The memory optimized flavor **"mem-su"** is provided from the same servers at
**"cpu-su"** but with 8 GB of memory per core. The base unit is 1 vCPU, 8 GB
memory with default of 20 GB root disk at a rate of $0.026 / hr of wall time.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|---------------|-----|-----|-------|---------|-------------|-----------|
|mem-su.1       |1    |0    |1      |8        |20           |$0.026     |
|mem-su.2       |2    |0    |2      |16       |20           |$0.052     |
|mem-su.4       |4    |0    |4      |32       |20           |$0.104     |
|mem-su.8       |8    |0    |8      |64       |20           |$0.208     |
|mem-su.16      |16   |0    |16     |128      |20           |$0.416     |

### 3. GPU Tier

NERC also supports the most demanding workloads including Artificial Intelligence
(AI), Machine Learning (ML) training and Deep Learning modeling, simulation,
data analytics, data visualization, distributed databases, and more. For such
demanding workloads, the NERC's GPU-based distributed computing flavor is
recommended, which is integrated into a specialized hardware such as GPUs
that produce unprecedented performance boosts for technical computing workloads.

!!! info "Guidelines for Utilizing GPU-Based Flavors in Active Resource Allocation"
    To effectively utilize GPU-based flavors on any NERC (OpenStack) resource allocation,
    the Principal Investigator (PI) or project manager(s) must submit a
    [change request](../../get-started/allocation/allocation-change-request.md#request-change-resource-allocation-attributes-for-openstack-project)
    for their currently active NERC (OpenStack) resource allocation. This request
    should specify the number of GPUs they intend to use by setting the "OpenStack
    GPU Quota" attribute. We recommend ensuring that this count accurately reflects
    the current GPU usage. Additionally, they need to adjust the quota values for
    "OpenStack Compute RAM Quota" and "OpenStack Compute vCPU Quota" to sufficiently
    accommodate the GPU flavor they wish to use when launching a VM in their
    OpenStack Project.

    Once the change request is reviewed and approved by the NERC's admin, users
    will be able to select the appropriate GPU-based flavor [during the flavor
    selection tab](../create-and-connect-to-the-VM/launch-a-VM.md#flavor-tab)
    when launching a new VM.

There are four different options within the GPU tier, featuring the newer
**NVIDIA A100 SXM4**, **NVIDIA A100s**, **NVIDIA V100s**, and **NVIDIA K80s**.

!!! question "How can I get customized A100 SXM4 GPUs not listed in the current flavors?"
    We also provide customized A100 SXM4 GPU-based flavors, which are not publicly
    listed on our NVIDIA A100 SXM4 40GB GPU Tiers list. These options are exclusively
    available for demanding projects and are subject to availability.

    To request access, please fill out [this form](https://forms.gle/UNffz9LXNEoWESEaA).
    Our team will review your request and reach out to you to discuss further.

#### i. NVIDIA A100 SXM4 40GB

The **"gpu-su-a100sxm4"** flavor is provided from Lenovo SD650-N V2 (2x Intel Xeon
Platinum 8358 32C 250W 2.6GHz, 128 cores, 1024 GB RAM 4x NVIDIA HGX A100 40GB) servers.
The higher number of tensor cores available can significantly enhance the speed
of machine learning applications. The base unit is 32 vCPU, 240 GB memory with
default of 20 GB root disk at a rate of $2.078 / hr of wall time.

| Flavor            | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|-------------------|-----|-----|-------|---------|-------------|-----------|
|gpu-su-a100sxm4.1  |1    |1    |32     |240      |20           |$2.078     |
|gpu-su-a100sxm4.2  |2    |2    |64     |480      |20           |$4.156     |

!!! note "How to setup NVIDIA driver for **"gpu-su-a100sxm4"** flavor based VM?"
    After launching a VM with an **NVIDIA A100 SXM4** GPU flavor, you will need to
    setup the NVIDIA driver in order to use GPU-based codes and libraries.
    Please run the following commands to setup the NVIDIA driver and CUDA
    version required for these flavors in order to execute GPU-based codes.
    **NOTE:** These commands are **ONLY** applicable for the VM based on
    "**ubuntu-22.04-x86_64**" image. You might need to find corresponding
    packages for your own OS of choice.

        sudo apt update
        sudo apt -y install nvidia-driver-495
        # Just click *Enter* if any popups appear!
        # Confirm and verify that you can see the NVIDIA device attached to your VM
        lspci | grep -i nvidia
        # 00:05.0 3D controller: NVIDIA Corporation GA100 [A100 SXM4 40GB] (rev a1)
        sudo reboot
        # SSH back to your VM and then you will be able to use nvidia-smi command
        nvidia-smi

#### ii. NVIDIA A100 40GB

The **"gpu-su-a100"** flavor is provided from Lenovo SR670 (2x Intel 8268 2.9 GHz,
48 cores, 384 GB memory, 4x NVIDIA A100 40GB) servers. These latest GPUs deliver
industry-leading high throughput and low latency networking. The base unit is 24
vCPU, 74 GB memory with default of 20 GB root disk at a rate of $1.803 / hr of
wall time.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|---------------|-----|-----|-------|---------|-------------|-----------|
|gpu-su-a100.1  |1    |1    |24     |74       |20           |$1.803     |
|gpu-su-a100.2  |2    |2    |48     |148      |20           |$3.606     |

!!! note "How to setup NVIDIA driver for **"gpu-su-a100"** flavor based VM?"
    After launching a VM with an **NVIDIA A100** GPU flavor, you will need to
    setup the NVIDIA driver in order to use GPU-based codes and libraries.
    Please run the following commands to setup the NVIDIA driver and CUDA
    version required for these flavors in order to execute GPU-based codes.
    **NOTE:** These commands are **ONLY** applicable for the VM based on
    "**ubuntu-22.04-x86_64**" image. You might need to find corresponding
    packages for your own OS of choice.

        sudo apt update
        sudo apt -y install nvidia-driver-495
        # Just click *Enter* if any popups appear!
        # Confirm and verify that you can see the NVIDIA device attached to your VM
        lspci | grep -i nvidia
        # 0:05.0 3D controller: NVIDIA Corporation GA100 [A100 PCIe 40GB] (rev a1)
        sudo reboot
        # SSH back to your VM and then you will be able to use nvidia-smi command
        nvidia-smi

#### iii. NVIDIA V100 32GB

The **"gpu-su-v100"** flavor is provided from Dell R740xd (2x Intel Xeon Gold 6148,
40 cores, 768GB memory, 1x NVIDIA V100 32GB) servers. The base unit is 48 vCPU,
192 GB memory with default of 20 GB root disk at a rate of $1.214 / hr of wall time.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|---------------|-----|-----|-------|---------|-------------|-----------|
|gpu-su-v100.1  |1    |1    |48     |192      |20           |$1.214     |

!!! note "How to setup NVIDIA driver for **"gpu-su-v100"** flavor based VM?"
    After launching a VM with an **NVIDIA V100** GPU flavor, you will need to
    setup the NVIDIA driver in order to use GPU-based codes and libraries.
    Please run the following commands to setup the NVIDIA driver and CUDA
    version required for these flavors in order to execute GPU-based codes.
    **NOTE:** These commands are **ONLY** applicable for the VM based on
    "**ubuntu-22.04-x86_64**" image. You might need to find corresponding
    packages for your own OS of choice.

        sudo apt update
        sudo apt -y install nvidia-driver-470
        # Just click *Enter* if any popups appear!
        # Confirm and verify that you can see the NVIDIA device attached to your VM
        lspci | grep -i nvidia
        # 00:05.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 32GB] (rev a1)
        sudo reboot
        # SSH back to your VM and then you will be able to use nvidia-smi command
        nvidia-smi

#### iv. NVIDIA K80 12GB

The **"gpu-su-k80"** flavor is provided from Supermicro X10DRG-H (2x Intel
E5-2620 2.40GHz, 24 cores, 128GB memory, 4x NVIDIA K80 12GB) servers. The base unit
is 6 vCPU, 28.5 GB memory with default of 20 GB root disk at a rate of $0.463 /
hr of wall time.

| Flavor       | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|--------------|-----|-----|-------|---------|-------------|-----------|
|gpu-su-k80.1  |1    |1    |6      |28.5     |20           |$0.463     |
|gpu-su-k80.2  |2    |2    |12     |57       |20           |$0.926     |
|gpu-su-k80.4  |4    |4    |24     |114      |20           |$1.852     |

!!! note "How to setup NVIDIA driver for **"gpu-su-k80"** flavor based VM?"
    After launching a VM with an **NVIDIA K80** GPU flavor, you will need to
    setup the NVIDIA driver in order to use GPU-based codes and libraries.
    Please run the following commands to setup the NVIDIA driver and CUDA
    version required for these flavors in order to execute GPU-based codes.
    **NOTE:** These commands are **ONLY** applicable for the VM based on
    "**ubuntu-22.04-x86_64**" image. You might need to find corresponding
    packages for your own OS of choice.

        sudo apt update
        sudo apt -y install nvidia-driver-470
        # Just click *Enter* if any popups appear!
        # Confirm and verify that you can see the NVIDIA device attached to your VM
        lspci | grep -i nvidia
        # 00:05.0 3D controller: NVIDIA Corporation GK210GL [Tesla K80] (rev a1)
        sudo reboot
        # SSH back to your VM and then you will be able to use nvidia-smi command
        nvidia-smi

!!! question "NERC IaaS Storage Tiers Cost"
    Storage both **OpenStack Swift (object storage)** and
    **Cinder (block storage/ volumes)** are charged separately at a rate of
    $0.009 TB/hr or $9.00E-12 KB/hr at a granularity of KB/hr. More about cost
    can be [found here](../../get-started/cost-billing/how-pricing-works.md) and
    some of the common billing related FAQs are [listed here](../../get-started/cost-billing/billing-faqs.md).

## How can I get customized A100 SXM4 GPUs not listed in the current flavors?

We also provide customized A100 SXM4 GPU-based flavors, which are not publicly
listed on our NVIDIA A100 SXM4 40GB GPU Tiers list. These options are exclusively
available for demanding projects and are subject to availability.

To request access, please fill out [this form](https://docs.google.com/forms/d/e/1FAIpQLSdUgsIf4UQgQmdI7OpDeC0ONKyI9xlE9EXi3ZukRGilEDWzRQ/viewform?usp=pp_url).
Our team will review your request and reach out to you to discuss further.

## How to Change Flavor of an instance

!!! warning "Important Note"
    This is only possible using the openstack client at this time!

**Prerequisites**:

To run the OpenStack CLI commands, you need to have:

- OpenStack CLI setup, see
[OpenStack Command Line setup](../openstack-cli/openstack-CLI.md#command-line-setup)
for more information.

If you want to change the **flavor** that is bound to a VM, then you can run the
following openstack client commands, here we are changing flavor of an existing
VM i.e. named "test-vm" from `mem-su.2` to `mem-su.4`:

First, stop the running VM using:

    openstack server stop test-vm

Then, verify the status is "SHUTOFF" and also the used flavor is `mem-su.2` as
shown below:

    openstack server list
    +--------------------------------------+------+---------+--------------------------------------------+--------------------------+---------+
    | ID | Name | Status | Networks | Image | Flavor |
    +--------------------------------------+------+---------+--------------------------------------------+--------------------------+---------+
    | cd51dbba-fe95-413c-9afc-71370be4d4fd | test-vm | SHUTOFF | default_network=192.168.0.58, 199.94.60.10 | N/A (booted from volume) | mem-su.2 |
    +--------------------------------------+------+---------+--------------------------------------------+--------------------------+---------+

Then, resize the flavor from `mem-su.2` to `mem-su.4` by running:

    openstack server resize --flavor mem-su.4 cd51dbba-fe95-413c-9afc-71370be4d4fd

Confirm the resize:

    openstack server resize confirm cd51dbba-fe95-413c-9afc-71370be4d4fd

Then, start the VM:

    openstack server start cd51dbba-fe95-413c-9afc-71370be4d4fd

Verify the VM is using the new flavor of `mem-su.4` as shown below:

    openstack server list
    +--------------------------------------+------+--------+--------------------------------------------+--------------------------+---------+
    | ID | Name | Status | Networks | Image | Flavor |
    +--------------------------------------+------+--------+--------------------------------------------+--------------------------+---------+
    | cd51dbba-fe95-413c-9afc-71370be4d4fd | test-vm | ACTIVE | default_network=192.168.0.58, 199.94.60.10 | N/A (booted from volume) | mem-su.4 |
    +--------------------------------------+------+--------+--------------------------------------------+--------------------------+---------+

---
