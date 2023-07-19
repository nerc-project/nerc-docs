# Nova flavors

In NERC OpenStack, flavors define the compute, memory, and storage capacity of
nova computing instances. In other words, a flavor is an available hardware
configuration for a server.

## Currently, our setup supports and offers the following flavors

NERC offers the following flavors based on our Infrastructure-as-a-Service
(IaaS) - OpenStack offerings (Tiers of Service).

!!! tip "Pro Tip"

    Choose a flavor for your instance from the available Tier that suits your requirements, use-cases, and budget when launching a VM.

### 1. Standard Compute Tier

The standard compute flavor **"cpu-su"** is provided from Lenovo SD530 (2x Intel
8268 2.9 GHz, 48 cores, 384 GB memory) server. The base service unit (SU) is 1
vCPU, 4 GB memory with 20 GB root disk at a rate of $0.013 / hr of wall time.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|---------------|-----|-----|-------|---------|-------------|-----------|
|cpu-su.1       |1    |0    |1      |4        |20           |$0.013     |
|cpu-su.2       |2    |0    |2      |8        |40           |$0.026     |
|cpu-su.4       |4    |0    |4      |16       |80           |$0.052     |
|cpu-su.8       |8    |0    |8      |32       |160          |$0.104     |
|cpu-su.16      |16   |0    |16     |64       |320          |$0.256     |

### 2. Memory Optimized Tier

The memory optimized flavor **"mem-su"** is provided from the same servers at
**"cpu-su"** but with 8 GB of memory per core. The base SU is 1 vCPU, 8 GB
memory with 20 GB root disk at a rate of $0.032 / hr of wall time.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|---------------|-----|-----|-------|---------|-------------|-----------|
|mem-su.1       |1    |0    |1      |8        |20           |$0.032     |
|mem-su.2       |2    |0    |2      |16       |40           |$0.064     |
|mem-su.4       |4    |0    |4      |32       |80           |$0.128     |
|mem-su.8       |8    |0    |8      |64       |160          |$0.256     |
|em-su.16       |16   |0    |16     |128      |320          |$0.512     |

### 3. GPU Tier

!!! info "Information"

    NERC also supports the most demanding workloads including Artificial Intelligence
    (AI), Machine Learning (ML) training and Deep Learning modeling, simulation, data
    analytics, data visualization, distributed databases, and more. For such demanding
    workloads, the NERC’s GPU-based distributed computing flavor is recommended, which
    is integrated into a specialized hardware such as GPUs that produce unprecedented
    performance boosts for technical computing workloads.

There are two flavors within the GPU tier, one featuring older the newer
**NVidia A100s**, **NVidia V100s**, and **NVidia A2s**.

The **"gpu-su-a100"** flavor is provided from Lenovo SR670 (2x Intel 8268 2.9 GHz,
48 cores, 384 GB memory, 4x NVidia A100) servers. These latest GPUs deliver
industry-leading high throughput and low latency networking. The base SU is 24
vCPU, 95 GB memory with 20 GB root disk at a rate of $1.803 / hr of wall time.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|---------------|-----|-----|-------|---------|-------------|-----------|
|gpu-su-a100.1  |1    |1    |24     |95       |20           |$1.803     |
|gpu-su-a100.2  |2    |2    |48     |190      |40           |$3.606     |

The **"gpu-su-v100"** flavor has base SU of 24 vCPU, 96 GB memory with 20 GB root
disk.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) |
|---------------|-----|-----|-------|---------|-------------|
|gpu-su-v100.1  |1    |1    |24     |96       |20           |
|gpu-su-v100.1m |2    |2    |48     |192      |20           |

!!! danger "Cost will be available soon!"

    We will update the cost assiciated with **"gpu-su-v100"** flavor soon!

The **"gpu-su-a2"** flavor is provided from Lenovo SR650 (2x Xenon Gold 6448Y
2.10 GHz, 32 Cores, 512 GB memory, 2x NVidia A2s) servers. The base SU is 6
vCPU, 31 GB memory with 20 GB root disk at a rate of $0.463 / hr of wall time.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|---------------|-----|-----|-------|---------|-------------|-----------|
|gpu-su-a2.1    |1    |1    |6      |31       |20           |$0.463     |
|gpu-su-a2.2    |2    |2    |12     |62       |40           |$0.926     |
|gpu-su-a2.4    |4    |4    |24     |124      |80           |$1.852     |

!!! warning "The `gpu-su-v100` and `gpu-su-a2` flavor will be available soon."

    We are still working on setting up the hardware required to enable the cost-effective
    **"gpu-su-v100"** and **"gpu-su-a2"** flavor. We will let you know once it
    is ready and available for your general use.

!!! question "NERC IaaS Storage Tiers Cost"
    Storage both **OpenStack Swift (object storage)** and
    **Cinder (block storage/ volumes)** are charged separately at a rate of
    $0.009 TB/hr or $9.00E-12 KB/hr at a granularity of KB/hr.

---
