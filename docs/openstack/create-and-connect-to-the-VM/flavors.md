# Nova flavors

In NERC OpenStack, flavors define the compute, memory, and storage capacity of
nova computing instances. In other words, a flavor is an available hardware
configuration for a server.

## Currently, our setup supports the following flavors

| Field                        | Value         |
|------------------------------|---------------|
| disk                         | 10            |
| name                         | m1.tiny       |
| ram                          | 1024          |
| vcpus                        | 1             |
|                              |               |
| disk                         | 10            |
| name                         | m1.small      |
| ram                          | 2048          |
| vcpus                        | 1             |
|                              |               |
| disk                         | 10            |
| name                         | m1.medium     |
| ram                          | 4096          |
| vcpus                        | 2             |
|                              |               |
| disk                         | 10            |
| name                         | m1.large      |
| ram                          | 8192          |
| vcpus                        | 4             |
|                              |               |
| disk                         | 10            |
| name                         | m1.xlarge     |
| ram                          | 16384         |
| vcpus                        | 8             |
|                              |               |
| disk                         | 10            |
| name                         | c1.xlarge     |
| ram                          | 46080         |
| vcpus                        | 10            |
|                              |               |
| disk                         | 10            |
| name                         | c1.2xlarge    |
| ram                          | 92160         |
| vcpus                        | 20            |
|                              |               |
| disk                         | 10            |
| name                         | c1.4xlarge    |
| ram                          | 184320        |
| vcpus                        | 40            |
|                              |               |
| disk                         | 10            |
| name                         | gpu.A100      |
| ram                          | 96256         |
| vcpus                        | 12            |
|                              |               |
| disk                         | 10            |
| name                         | custom.4c.16g |
| ram                          | 16384         |
| vcpus                        | 4             |
|                              |               |
| disk                         | 10            |
| name                         | custom.4c.32g |
| ram                          | 32768         |
| vcpus                        | 4             |
|                              |               |
| disk                         | 10            |
| name                         | custom.8c.32g |
| ram                          | 32768         |
| vcpus                        | 8             |
|                              |               |
| disk                         | 10            |
| name                         | custom.8c.64g |
| ram                          | 65536         |
| vcpus                        | 8             |
|                              |               |
| disk                         | 25            |
| name                         | m1.s2.tiny    |
| ram                          | 1024          |
| vcpus                        | 1             |
|                              |               |
| disk                         | 25            |
| name                         | m1.s2.small   |
| ram                          | 2048          |
| vcpus                        | 1             |
|                              |               |
| disk                         | 25            |
| name                         | m1.s2.medium  |
| ram                          | 4096          |
| vcpus                        | 2             |
|                              |               |
| disk                         | 25            |
| name                         | m1.s2.large   |
| ram                          | 8192          |
| vcpus                        | 4             |
|                              |               |
| disk                         | 25            |
| name                         | m1.s2.xlarge  |
| ram                          | 16384         |
| vcpus                        | 8             |
|                              |               |
| disk                         | 25            |
| name                         | c1.s2.xlarge  |
| ram                          | 46080         |
| vcpus                        | 10            |
|                              |               |
| disk                         | 25            |
| name                         | c1.s2.2xlarge |
| ram                          | 92160         |
| vcpus                        | 20            |
|                              |               |
| disk                         | 25            |
| name                         | c1.s2.4xlarge |
| ram                          | 184320        |
| vcpus                        | 40            |
|                              |               |
| disk                         | 25            |
| name                         | c2.s2.xlarge  |
| ram                          | 32768         |
| vcpus                        | 16            |
|                              |               |
| disk                         | 25            |
| name                         | c2.s2.2xlarge |
| ram                          | 65536         |
| vcpus                        | 32            |
|                              |               |
| disk                         | 25            |
| name                         | c2.s2.4xlarge |
| ram                          | 81920         |
| vcpus                        | 40            |

Each flavor includes enforced quotas for disk limits through
maximum disk read, write, and total bytes per second and disk limits through
maximum disk read, write, and total I/O operations per second. They also
include enforced network bandwidth limits through inbound and outbound average.

So, while launching a VM choose the flavor for your instance that fits your
requirements and use-cases.

---
