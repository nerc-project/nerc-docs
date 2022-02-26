# Launch a VM using OpenStack CLI

First find the following details using openstack command, we would required
these details during the creation of virtual machine.

- Flavor
- Image
- Network
- Security Group
- Key Name

Get the flavor list using below openstack command:

```sh
  [user@laptop ~]$ openstack flavor list
  +--------------------------------------+---------------------+--------+------+-----------+-------+-----------+
| ID                                   | Name                |    RAM | Disk |
Ephemeral | VCPUs | Is Public |
+--------------------------------------+---------------------+--------+------+-----------+-------+-----------+
| 010668a2-a228-4d9f-814b-33e76bb79ca6 | c1.2xlarge          |  92160 |   10
|         0 |    20 | True      |
| 042c3d1d-5031-48a9-91d8-2748ba2ea892 | c1.xlarge           |  46080 |   10
|         0 |    10 | True      |
| 04f533da-df73-4a07-bfd4-845d92e2236b | m1.s2.xlarge        |  16384 |   25
|         0 |     8 | True      |
| 2540eb5f-b39e-43aa-b9c4-bda7138f69b7 | c1.s2.4xlarge       | 184320 |   25
|         0 |    40 | True      |
| 39dc1cc9-8931-49c4-a6ae-fd56f85ded6f | c2.s2.xlarge        |  32768 |   25
|         0 |    16 | True      |
| 45aa2929-c2a7-49ff-b876-71f9cea3083a | m1.s2.medium        |   4096 |   25
|         0 |     2 | True      |
| 46489535-3bbe-445b-83dc-c24c11c13017 | gpu.A100            |  96256 |   10
|         0 |    12 | True      |
| 57f95588-c3ae-41ee-95d7-b8b5b15814ab | m1.xlarge           |  16384 |   10
|         0 |     8 | True      |
| 58377d5b-528f-4107-b5a4-9c840c76e2f9 | vm.2cpu.8ram        |   8192 |   10
|         0 |     2 | True      |
| 5add4073-0822-4939-b34e-a7bdfadd6157 | custom.8c.32g       |  32768 |   10
|         0 |     8 | True      |
| 5f098b1a-a14c-4c85-be39-4c2af6b0b9c3 | vm.24cpu.64ram.1gpu |  65536 |   50
|         0 |    24 | True      |
| 6e33d0e1-e604-4a99-9440-366f0c15b1f0 | m1.s2.small         |   2048 |   25
|         0 |     1 | True      |
| 8c01d1e5-a29e-4b15-bff9-3738ac55fef7 | custom.8c.64g       |  65536 |   10
|         0 |     8 | True      |
| 8d42c77c-3c4c-4417-991d-ab6bc39f7efb | m1.s2.large         |   8192 |   25
|         0 |     4 | True      |
| 8f41b20c-14b5-4442-987a-1b3081d75364 | m1.small            |   2048 |   10
|         0 |     1 | True      |
| aa182672-a501-46a2-9aa1-c41b23695960 | m1.tiny             |   1024 |   10
|         0 |     1 | True      |
| af4109aa-9571-471c-b8ad-aacce027d1fc | m1.large            |   8192 |   10
|         0 |     4 | True      |
| b602f97d-7870-4392-9cce-608fe8c23e30 | custom.4c.16g       |  16384 |   10
|         0 |     4 | True      |
| b6ac3856-d984-432e-a91e-ddff853e82c8 | c2.s2.2xlarge       |  65536 |   25
|         0 |    32 | True      |
| b7add244-7187-49c8-9cd3-1783bff483d7 | m1.s2.tiny          |   1024 |   25
|         0 |     1 | True      |
| bb4a3292-cdf0-429a-8cbb-05540da7db6c | c2.s2.4xlarge       |  81920 |   25
|         0 |    40 | True      |
| bd7caf51-8d5e-4019-b8ca-7af36d043ef6 | c1.4xlarge          | 184320 |   10
|         0 |    40 | True      |
| befdf5fa-8f8e-44ee-b945-2f2cf269970d | c1.s2.2xlarge       |  92160 |   25
|         0 |    20 | True      |
| cad489ad-3460-4a46-a867-926bdfcb2add | m1.medium           |   4096 |   10
|         0 |     2 | True      |
| e9b78693-9c59-4528-a2b5-47d037c76670 | custom.4c.32g       |  32768 |   10
|         0 |     4 | True      |
| fbedbef9-89dd-4549-86b1-7d34504211f2 | c1.s2.xlarge        |  46080 |   25
|         0 |    10 | True      |
+--------------------------------------+---------------------+--------+------+-----------+-------+-----------+
```

Get the image name and its ID,

```sh
  [user@laptop ~]$ openstack image list  | grep centos
  | f43b9e94-2862-4edc-8844-4a4e348a2d49 | centos-7-x86_64     | active |
  | 482f489c-d8db-47be-8f55-53096fb37c07 | centos-8.4-x86_64   | active |
```

Get Private Virtual network details, which will be attached to the VM:

```sh
  [user@laptop ~]$ openstack network list
  +--------------------------------------+-----------------+--------------------------------------+
  | ID                                   | Name            |
  Subnets                              |
  +--------------------------------------+-----------------+--------------------------------------+
  | 7a9efc40-4624-429d-98b7-1364ab72d8b9 | provider        |
  b7045d5e-892b-4d8c-8837-728f62bd8fe2 |
  | 9aa6c35a-4fce-4a75-b167-8cfe7fb1f2d1 | harvard-network |
  c95c3c17-fbc1-4fb7-bc2c-d463f2c4774f |
  +--------------------------------------+-----------------+--------------------------------------+
```

Find the Security Group:

```sh
  [user@laptop ~]$ openstack security group list
  +--------------------------------------+----------+------------------------+----------------------------------+------+
  | ID                                   | Name     | Description            |
  Project                          | Tags |
  +--------------------------------------+----------+------------------------+----------------------------------+------+
  | 3ca248ac-56ac-4e5f-a57c-777ed74bbd7c | default  | Default security group |
  f01df1439b3141f8b76e68a3b58ef74a | []   |
  | 5cdc5f33-78fc-4af8-bf25-60b8d4e5db2a | ssh_only | Enable SSH access.     |
  f01df1439b3141f8b76e68a3b58ef74a | []   |
  +--------------------------------------+----------+------------------------+----------------------------------+------+
```

Find the Key pair, in my case you can choose your own,

```sh
  [user@laptop ~]$ openstack keypair list | grep -i cloud_key
  | cloud_key | d5:ab:dc:1f:e5:08:44:7f:a6:21:47:23:85:32:cc:04 | ssh  |
```

!!! note "Note"
    Above details will be different for you based on your project and env.

## Launch an instance from an Image

Now we have all the details, let’s create a virtual machine using "openstack
server create" command

Syntax :

```sh
  $ openstack server create --flavor {Flavor-Name-Or-Flavor-ID } \
      --image {Image-Name-Or-Image-ID} \
      --nic net-id={Network-ID} \
      --user-data USER-DATA-FILE \
      --security-group {Security_Group_ID} \
      --key-name {Keypair-Name} \
      --property KEY=VALUE \
      <Instance_Name>
```

**NOTE:** If you boot an instance with an "**Instance_Name**" greater than **63
characters**, Compute truncates it automatically when turning it into a
hostname to ensure the correct functionality of `dnsmasq`.

Optionally, you can provide a key name for access control and a security group
for security.

You can also include metadata key and value pairs: `--key-name {Keypair-Name}`.
For example, you can add a description for your server by providing the
`--property description="My Server"` parameter.

You can pass user data in a local file at instance launch by using the
`--user-data USER-DATA-FILE` parameter. If you do not provide a key pair, you
will be unable to access the instance.

You can also place arbitrary local files into the instance file system at
creation time by using the `--file <dest-filename=source-filename>` parameter.
You can store up to five files.
For example, if you have a special authorized keys file named
*special_authorized_keysfile* that you want to put on the instance rather than
using the regular SSH key injection, you can add the –file option as shown in
the following example.

```sh
  --file /root/.ssh/authorized_keys=special_authorized_keysfile
```

To create a VM in Specific "**Availability Zone and compute Host**" specify
`--availability-zone {Availbility-Zone-Name}:{Compute-Host}` in above syntax.

Example:

```sh
  [user@laptop ~]$ openstack server create --flavor m1.medium \
      --image centos-8.4-x86_64 \
      --nic net-id=e0be93b8-728b-4d4d-a272-7d672b2560a6 \
      --security-group default \
      --key-name cloud_key \
      --property description="My Server" \
      test_vm_using_cli
```

**NOTE:** To get more help on "openstack server create" command , use:

```sh
  [user@laptop ~]$ openstack -h server create
```

Detailed syntax:

```sh
  openstack server create
    (--image <image> | --volume <volume>)
    --flavor <flavor>
    [--security-group <security-group>]
    [--key-name <key-name>]
    [--property <key=value>]
    [--file <dest-filename=source-filename>]
    [--user-data <user-data>]
    [--availability-zone <zone-name>]
    [--block-device-mapping <dev-name=mapping>]
    [--nic <net-id=net-uuid,v4-fixed-ip=ip-addr,v6-fixed-ip=ip-addr,port-id=port-uuid,auto,none>]
    [--network <network>]
    [--port <port>]
    [--hint <key=value>]
    [--config-drive <config-drive-volume>|True]
    [--min <count>]
    [--max <count>]
    [--wait]
    <server-name>
```

!!!note "Note"
    Similarly, we can lauch a VM using "Volume".

Now Verify the test vm status using below commands:

```sh
  [user@laptop ~]$ openstack server list | grep test_vm_using_cli
```

**OR,**

```sh
  [user@laptop ~]$ openstack server show test_vm_using_cli
```

## Associating a Floating IP to VM

To Associate a floating IP to VM, first get the unused floating IP using the
following command:

```sh
  [user@laptop ~]$ openstack floating ip list | grep None | head -2
  | 071f08ac-cd10-4b89-aee4-856ead8e3ead | 169.144.107.154 | None |
  None                                 |
  | 1baf4232-9cb7-4a44-8684-c604fa50ff60 | 169.144.107.184 | None |
  None                                 |
```

Now Associate the first IP to the server using following command:

```sh
  [user@laptop ~]$ openstack server add floating ip test_vm_using_cli 169.144.107.154
```

Use the following command to verify whether floating IP is assigned to the VM
or not:

```sh
  [user@laptop ~]$ openstack server list | grep test_vm_using_cli
  | 056c0937-6222-4f49-8405-235b20d173dd | test_vm_using_cli | ACTIVE  | ...
  nternal=192.168.15.62, 169.144.107.154 |
```

## Remove existing floating ip from the VM

```sh
  openstack server remove floating ip <INSTANCE_NAME_OR_ID> <FLOATING_IP_ADDRESS>
```

### Get all available security group in your project

```sh
  $ openstack security group list
  +--------------------------------------+----------+------------------------+----------------------------------+------+
  | 3ca248ac-56ac-4e5f-a57c-777ed74bbd7c | default  | Default security group |
  f01df1439b3141f8b76e68a3b58ef74a | []   |
  | 5cdc5f33-78fc-4af8-bf25-60b8d4e5db2a | ssh_only | Enable SSH access.     |
  f01df1439b3141f8b76e68a3b58ef74a | []   |
  +--------------------------------------+----------+------------------------+----------------------------------+------+
```

### Add existing security group to the VM

```sh
  openstack server add security group <INSTANCE_NAME_OR_ID> <SECURITY_GROUP>
```

Example:

```sh
  openstack server add security group test_vm_using_cli ssh_only
```

## Remove existing security group from the VM

```sh
  openstack server remove security group <INSTANCE_NAME_OR_ID> <SECURITY_GROUP>
```

Example:

```sh
  openstack server remove security group test_vm_using_cli ssh_only
```

**Alternatively**, you can use the openstack port unset command to remove the
group from a port:

```sh
  openstack port unset --security-group <SECURITY_GROUP> <PORT>
```

## Adding volume to the VM

```sh
  $ openstack server add volume
    [--device <device>]
    <INSTANCE_NAME_OR_ID>
    <VOLUME_NAME_OR_ID>
```

## Remove existing volume from the VM

```sh
  openstack server remove volume <INSTANCE_NAME_OR_ID> <volume>
```

## Deleting Virtual Machine from Command Line

```sh
  [user@laptop ~]$ openstack server delete test_vm_using_cli
```

---
