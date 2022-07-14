# Nova flavors

In NERC OpenStack, flavors define the compute, memory, and storage capacity of
nova computing instances. In other words, a flavor is an available hardware
configuration for a server.

## Currently, our setup supports and offers the following flavors

NERC offers the following flavors based on our Infrastructure-as-a-Service
(IaaS) - OpenStack offerings (Tiers of Service).

### 1. Standard Compute Tier

The standard compute flavor **"cpu-a"** is provided from Lenovo SD530 (2x Intel 8268
2.9 GHz, 48 core, 384 GB memory) server. The base service unit (SU) is 1 vCPU, 2
GB memory at a rate of $0.016 / hr of wall time. Multiples of the `cpu-a` SU are
available with 20 GB root disk, and the price scales accordingly:

| Flavor        | SUs    | Cost / hr    |
|---------------|--------|--------------|
| cpu-a.1       | 1      | $0.016       |
| cpu-a.2       | 2      | $0.032       |
| cpu-a.4       | 4      | $0.064       |
| cpu-a.8       | 8      | $0.128       |
| cpu-a.16      | 16     | $0.256       |

### 2. Memory Optimized Tier

The memory optimized flavor **"mem-a"** is provided from the same servers at **"cpu-a"**
but with 8 GB of memory per core. The base service unit (SU) is 1 vCPU, 8 GB
memory at a rate of $0.030 / hr of wall time. Multiples of the `mem-a` SU are
available with 20 GB root disk, and the price scales accordingly:

| Flavor        | SUs    | Cost / hr    |
|---------------|--------|--------------|
| mem-a.1       | 1      | $0.030       |
| mem-a.2       | 2      | $0.060       |
| mem-a.4       | 4      | $0.120       |
| mem-a.8       | 8      | $0.240       |
| mem-a.16      | 16     | $0.480       |

### 3. GPU Tier

!!! info "Information"

    NERC also supports the most demanding workloads including Artificial Intelligence
    (AI), Machine Learning (ML) training and Deep Learning modeling, simulation, data
    analytics, data visualization, distributed databases, and more. For such demanding
    workloads, the NERC’s GPU-based distributed computing flavor is recommended, which
    is integrated into a specialized hardware such as GPUs that produce unprecedented
    performance boosts for technical computing workloads.

There are two flavors within the GPU tier, one featuring older **NVidia K80s**
and the newer **NVidia A100s technology**.

The **"gpu-k80"** flavor is provided from Supermicro (2x Intel E5-2620 v3, 24 core,
128GB memory, 2x NVidia K80s) servers. The base service unit is 25% of a whole
server, so 1 SU provides 6 vCPU, 32 GB memory, 1 NVidia K80 at a rate of
$0.190 /  hr of wall time. Multiples of the `gpu-k80` SU are available with
20 GB root disk.

| Flavor        | SUs    | Cost / hr    |
|---------------|--------|--------------|
| gpu-k80.1     | 1      | $0.190       |
| gpu-k80.2     | 2      | $0.380       |
| gpu-k80.4     | 4      | $0.760       |

!!! warning "The `gpu-k80` flavor will be available soon."

    We are still working on setting up the hardware required to enable the cost-effective
    **"gpu-k80"** flavor. We will let you know once it is ready
    and available for your general use.

The **"gpu-a100"** flavor is provided from Lenovo SR670 (2x Intel 8268 2.9 GHz, 48
core, 384 GB memory, 4x NVidia A100) servers. These latest GPUs deliver
industry-leading high throughput and low latency networking. The base service unit
is 25% of a whole server, so 1 SU provides 12 vCPU, 96 GB memory, 1 NVidia A100
at a rate of $0.537 / hr of wall time. Multiples of the `gpu-a100` SU are available
with 20 GB root disk.

| Flavor        | SUs    | Cost / hr    |
|---------------|--------|--------------|
| gpu-a100.1    | 1      | $0.537       |
| gpu-a100.2    | 2      | $1.074       |
| gpu-a100.4    | 4      | $2.148       |

!!! tip "Pro Tip"

    Choose a flavor for your instance that suits your requirements, use-cases, and budget when launching a VM.

---
