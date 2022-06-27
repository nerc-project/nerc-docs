# Nova flavors

In NERC OpenStack, flavors define the compute, memory, and storage capacity of
nova computing instances. In other words, a flavor is an available hardware
configuration for a server.

## Currently, our setup supports the following flavors

| Instance Name | RAM (MB)  | Disk storage (GB) | VCPUs     |
|---------------|-----------|-------------------|-----------|
| m1.tiny       | 1024      | 10                | 1         |
| m1.small      | 2048      | 10                | 1         |
| m1.medium     | 4096      | 10                | 2         |
| m1.large      | 8192      | 10                | 4         |
| m1.xlarge     | 16384     | 10                | 8         |
| c1.xlarge     | 46080     | 10                | 10        |
| c1.2xlarge    | 92160     | 10                | 20        |
| c1.4xlarge    | 184320    | 10                | 40        |
| custom.4c.16g | 16384     | 10                | 4         |
| custom.4c.32g | 32768     | 10                | 4         |
| custom.8c.32g | 32768     | 10                | 8         |
| custom.8c.64g | 65536     | 10                | 8         |
| m1.s2.tiny    | 1024      | 25                | 1         |
| m1.s2.small   | 2048      | 25                | 1         |
| m1.s2.medium  | 4096      | 25                | 2         |
| m1.s2.large   | 8192      | 25                | 4         |
| m1.s2.xlarge  | 16384     | 25                | 8         |
| c1.s2.xlarge  | 46080     | 25                | 10        |
| c1.s2.2xlarge | 92160     | 25                | 20        |
| c1.s2.4xlarge | 184320    | 25                | 40        |
| c2.s2.xlarge  | 32768     | 25                | 16        |
| c2.s2.2xlarge | 65536     | 25                | 32        |
| c2.s2.4xlarge | 81920     | 25                | 40        |

NERC also supports the most demanding workloads including Artificial Intelligence
(AI), Machine Learning (ML) training and Deep Learning modeling, simulation, data
analytics, data visualization, distributed databases, and more. For such demanding
workloads, the NERC’s GPU based distributed computing flavor is recommended, which
is integrated to a specialized hardware such as GPUs that produce unprecedented
performance boosts for technical computing workloads. They are powered by the
latest **NVIDIA A100 Tensor Core GPUs** and deliver industry-leading high throughput
and low latency networking.

| Instance Name | GPUs      | VCPUs     | RAM (MB)  | Disk storage (GB) |
|---------------|-----------|-----------|-----------|-------------------|
| gpu.A100      | 8         | 12        | 96256     | 10                |

Each flavor includes enforced quotas for disk limits through
maximum disk read, write, and total bytes per second and disk limits through
maximum disk read, write, and total I/O operations per second. They also
include enforced network bandwidth limits through inbound and outbound average.

So, while launching a VM choose the flavor for your instance that fits your
requirements and use-cases.

---
