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
  +--------------------------------------+------------+--------+------+-----------+-------+-----------+
  | ID                                   | Name       |    RAM | Disk | Ephemeral | VCPUs | Is Public |
  +--------------------------------------+------------+--------+------+-----------+-------+-----------+
  | 12ded228-1a7f-4d35-b994-7dd394a6ca90 | gpu-a100.2 | 196608 |   20 |         0 |    24 | True      |
  | 15581358-3e81-4cf2-a5b8-c0fd2ad771b4 | mem-a.8    |  65536 |   20 |         0 |     8 | True      |
  | 17521416-0ecf-4d85-8d4c-ec6fd1bc5f9d | cpu-a.1    |   2048 |   20 |         0 |     1 | True      |
  | 2b1dbea2-736d-4b85-b466-4410bba35f1e | cpu-a.8    |  16384 |   20 |         0 |     8 | True      |
  | 2f33578f-c3df-4210-b369-84a998d77dac | mem-a.4    |  32768 |   20 |         0 |     4 | True      |
  | 4498bfdb-5342-4e51-aa20-9ee74e522d59 | mem-a.1    |   8192 |   20 |         0 |     1 | True      |
  | 4e43e6df-3637-4363-a7cd-732fbf9e7cfd | gpu-a100.4 | 393216 |   20 |         0 |    48 | True      |
  | 7f2f5f4e-684b-4c24-bfc6-3fce9cf1f446 | mem-a.16   | 131072 |   20 |         0 |    16 | True      |
  | 8c05db2f-6696-446b-9319-c32341a09c41 | cpu-a.16   |  32768 |   20 |         0 |    16 | True      |
  | 9662b5b2-aeaa-4d56-9bd3-450deee668af | cpu-a.4    |   8192 |   20 |         0 |     4 | True      |
  | b3377fdd-fd0f-4c88-9b4b-3b5c8ada0732 | gpu-a100.1 |  98304 |   20 |         0 |    12 | True      |
  | e9125ab0-c8df-4488-a252-029c636cbd0f | mem-a.2    |  16384 |   20 |         0 |     2 | True      |
  | ee6417bd-7cd4-4431-a6ce-d09f0fba3ba9 | cpu-a.2    |   4096 |   20 |         0 |     2 | True      |
  +--------------------------------------+------------+--------+------+-----------+-------+-----------+
```

Get the image name and its ID,

```sh
  [user@laptop ~]$ openstack image list  | grep centos
  | 41eafa05-c264-4840-8c17-746e6a388c2d | centos-7-x86_64     | active |
```

Get Private Virtual network details, which will be attached to the VM:

```sh
  [user@laptop ~]$ openstack network list
  +--------------------------------------+-----------------+--------------------------------------+
  | ID                                   | Name            | Subnets                              |
  +--------------------------------------+-----------------+--------------------------------------+
  | 43613b84-e1fb-44a4-b1ea-c530edc49018 | provider        | 1cbbb98d-3b57-4f6d-8053-46045904d910 |
  | 8a91900b-d43c-474d-b913-930283e0bf43 | default_network | e62ce2fd-b11c-44ce-b7cc-4ca943e75a23 |
  +--------------------------------------+-----------------+--------------------------------------+
```

Find the Security Group:

```sh
  [user@laptop ~]$ openstack security group list
  +--------------------------------------+----------------------------------+------------------------+----------------------------------+------+
  | ID                                   | Name                             | Description            | Project                          | Tags |
  +--------------------------------------+----------------------------------+------------------------+----------------------------------+------+
  | 8285530a-34e3-4d96-8e01-a7b309a91f9f | default                          | Default security group | 8ae3ae25c3a84c689cd24c48785ca23a | []   |
  | bbb738d0-45fb-4a9a-8bc4-a3eafeb49ba7 | ssh_only                         |                        | 8ae3ae25c3a84c689cd24c48785ca23a | []   |
  +--------------------------------------+----------------------------------+------------------------+----------------------------------+------+
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

!!! note "Important Note"
    If you boot an instance with an "**Instance_Name**" greater than **63
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
  [user@laptop ~]$ openstack server create --flavor cpu-a.2 \
      --image centos-7-x86_64 \
      --nic net-id=8ee63932-464b-4999-af7e-949190d8fe93 \
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

!!! note "Note"
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
