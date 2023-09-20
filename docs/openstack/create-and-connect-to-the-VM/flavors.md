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
8268 2.9 GHz, 48 cores, 384 GB memory) server. The base unit is 1 vCPU, 4 GB
memory with default of 20 GB root disk at a rate of $0.013 / hr of wall time.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|---------------|-----|-----|-------|---------|-------------|-----------|
|cpu-su.1       |1    |0    |1      |4        |20           |$0.013     |
|cpu-su.2       |2    |0    |2      |8        |20           |$0.026     |
|cpu-su.4       |4    |0    |4      |16       |20           |$0.052     |
|cpu-su.8       |8    |0    |8      |32       |20           |$0.104     |
|cpu-su.16      |16   |0    |16     |64       |20           |$0.256     |

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

!!! info "Information"

    NERC also supports the most demanding workloads including Artificial Intelligence
    (AI), Machine Learning (ML) training and Deep Learning modeling, simulation, data
    analytics, data visualization, distributed databases, and more. For such demanding
    workloads, the NERC’s GPU-based distributed computing flavor is recommended, which
    is integrated into a specialized hardware such as GPUs that produce unprecedented
    performance boosts for technical computing workloads.

There are two flavors within the GPU tier, one featuring the newer
**NVidia A100s** along with **NVidia V100s**.

The **"gpu-su-a100"** flavor is provided from Lenovo SR670 (2x Intel 8268 2.9 GHz,
48 cores, 384 GB memory, 4x NVidia A100) servers. These latest GPUs deliver
industry-leading high throughput and low latency networking. The base unit is 24
vCPU, 95 GB memory with default of 20 GB root disk at a rate of $1.803 / hr of
wall time.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|---------------|-----|-----|-------|---------|-------------|-----------|
|gpu-su-a100.1  |1    |1    |24     |95       |20           |$1.803     |
|gpu-su-a100.2  |2    |2    |48     |190      |20           |$3.606     |

The **"gpu-su-v100"** flavor is provided from Dell R740xd (2x Intel Xeon Gold 6148,
40 core, 768GB memory, 1x NVidia V100) servers. The base unit is 24 vCPU, 96 GB
memory at a rate of $0.902 / hr of wall time. There is also a related "gpu-su-v100.1m"
consumable that provides doubled vCPU and memory in comparision to "gpu-su-v100.1".
Both gpu-su-v100 consumables are available with a 20 GB root disk.

| Flavor        | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|---------------|-----|-----|-------|---------|-------------|-----------|
|gpu-su-v100.1  |1    |1    |24     |96       |20           |$0.902     |
|gpu-su-v100.1m |2    |1    |48     |192      |20           |$1.214     |

The **"gpu-su-k80"** flavor is provided from Supermicro X10DRG-H (2x Intel
E5-2620 2.40GHz, 24 core, 128GB memory, 4x NVidia K80) servers. The base unit
is 6 vCPU, 31 GB memory with default of 20 GB root disk at a rate of $0.463 /
hr of wall time.

| Flavor       | SUs | GPU | vCPU  | RAM(GB) | Storage(GB) | Cost / hr |
|--------------|-----|-----|-------|---------|-------------|-----------|
|gpu-su-k80.1  |1    |1    |6      |31       |20           |$0.463     |
|gpu-su-k80.2  |2    |2    |12     |62       |20           |$0.926     |
|gpu-su-k80.4  |4    |4    |24     |124      |20           |$1.852     |

!!! question "NERC IaaS Storage Tiers Cost"
    Storage both **OpenStack Swift (object storage)** and
    **Cinder (block storage/ volumes)** are charged separately at a rate of
    $0.009 TB/hr or $9.00E-12 KB/hr at a granularity of KB/hr.

---
