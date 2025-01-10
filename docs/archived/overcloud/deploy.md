Title: Overcloud Deploy
Date: 2021-06-17 08:53
Modified: 2021-06-17 08:53
Category: HowTo
Tags: overcloud, director, OSP
Slug: overcloud-deploy
Authors: Justin Riley
Summary: How to deploy the NERC overcloud

# Installing the base overcloud images

To install the base overcloud images needed for overcloud deployment:

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ sudo dnf install rhosp-director-images rhosp-director-images-ipa-x86_64
```

Next unpack the latest 16.1 x86_64 overcloud-full images and push them to the
undercloud image service:

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ mkdir ~/images
(undercloud) [stack@nerc-undercloud01 ~]$ cd ~/images
(undercloud) [stack@nerc-undercloud01 ~]$ tar xvf /usr/share/rhosp-director-images/overcloud-full-latest-16.1-x86_64.tar
(undercloud) [stack@nerc-undercloud01 ~]$ tar xvf /usr/share/rhosp-director-images/ironic-python-agent-latest-16.1-x86_64.tar
(undercloud) [stack@nerc-undercloud01 ~]$ openstack overcloud image upload --image-path /home/stack/images/
```

Verify the images were uploaded successfully:

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ openstack image list
+--------------------------------------+------------------------+--------+
| ID                                   | Name                   | Status |
+--------------------------------------+------------------------+--------+
| fc83125f-e040-4f59-94d2-bcf59f596393 | overcloud-full         | active |
| 72021c60-2ad6-4ed5-9683-33e029d32483 | overcloud-full-initrd  | active |
| 28314af5-5a23-4204-ba79-7043ef08a644 | overcloud-full-vmlinuz | active |
+--------------------------------------+------------------------+--------+
```

# Importing the host inventory into undercloud's ironic

Once the base overcloud images have been uploaded it's time to import our
baremetal node configs which can be found in the `nerc-osp-config` repo which
should be checked out on the undercloud host at `/home/stack/nerc-osp-config`

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ openstack overcloud node import ~/nerc-osp-config/nodes/nodes.json
Waiting for messages on queue 'tripleo' with no timeout.
38 node(s) successfully moved to the "manageable" state.
Successfully registered node UUID ffc0d684-5ac3-484f-bcbc-8b93a085f1f4
Successfully registered node UUID 9a0e0c45-c7ec-4521-9f16-64553165670d
Successfully registered node UUID 94921ee3-d8d8-46f0-867c-639bc039adb4
Successfully registered node UUID 0fa54bc7-8598-476a-9f08-080dc3d7ff6e
Successfully registered node UUID 24f64b45-ffee-4212-a773-2030e0efb46f
Successfully registered node UUID 1e547fc6-490c-4edc-910a-bec34bbfbbf6
Successfully registered node UUID 5d567181-30de-4e8e-a3e8-ecf5aad49331
Successfully registered node UUID 070ba59b-aaf2-4792-bc4f-7005075ef797
Successfully registered node UUID 21bf4dde-d0d1-482d-b5a3-641c3062e7d9
Successfully registered node UUID 8c755927-b3fb-43bb-a3bd-ca2e7aaa6aca
Successfully registered node UUID ca1ff31f-6470-4194-a509-90c769d02c2f
Successfully registered node UUID 72fbd648-8d67-43d0-90a0-f7e7a703a61e
Successfully registered node UUID e68b1122-c647-46d0-8318-a08446ab4208
Successfully registered node UUID 763454a0-2c80-49ef-a377-5f04fcc3e1bb
Successfully registered node UUID 9a6507e2-5988-44f2-bb7c-eeb5715af3bc
Successfully registered node UUID 742ba714-e06e-4d41-92e2-86cefecebd7e
Successfully registered node UUID c3c0c093-7a9e-49ba-8001-8c279e5707f0
Successfully registered node UUID e8e49dcf-15ba-43dd-8e27-e56fe8000ff5
Successfully registered node UUID f099ba7b-6aba-4335-8519-5a1089ace349
Successfully registered node UUID 11ae79a2-8bdb-4d12-8686-af4b21088e59
Successfully registered node UUID 2c52a12c-581d-4d5d-b99f-0a4633525dc3
Successfully registered node UUID 844d36e0-ebc0-4798-9412-f822e74766ce
Successfully registered node UUID 4c911600-77df-4222-92da-8b014648ffa3
Successfully registered node UUID e24a4e21-b7bb-4a87-89bf-8d4d87bcc412
Successfully registered node UUID be68d00d-8b26-451f-a208-8ff658bb095e
Successfully registered node UUID 7a58514f-36d7-450e-9302-4c93bd86a807
Successfully registered node UUID 12c27424-e38c-4a81-98ad-e50506621cfd
Successfully registered node UUID 3cb78a45-5d3c-4cea-af27-acd2dc5b3321
Successfully registered node UUID 8f77df5b-d0b8-41b3-b2ba-85f4e3cb1078
Successfully registered node UUID cea9d015-f9ba-4133-a5a6-fa4f317788f9
Successfully registered node UUID bd6bca98-cf4d-43ff-a428-99497b87b066
Successfully registered node UUID 1ef1333e-64e9-457a-9ae9-de51ecac91ba
Successfully registered node UUID a6c41c2a-ebbd-46b0-8967-5305d2b87e32
Successfully registered node UUID 9a2dab35-02eb-4ccd-be1b-d7b999f0f8c5
Successfully registered node UUID fb942abc-67f2-465a-acbc-91e666035eb9
Successfully registered node UUID be92a070-b37d-43c9-b84d-c4d2516d010b
Successfully registered node UUID 3aacbe9d-531e-40de-9d65-2f544cd531a1
Successfully registered node UUID e3f59f32-cb13-41d3-9a30-234ee5f8eed3
```

Verify the hosts now show up in the baremetal node inventory on the undercloud:

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ openstack baremetal node list
+--------------------------------------+---------------------+---------------+-------------+--------------------+-------------+
| UUID                                 | Name                | Instance UUID | Power State | Provisioning State | Maintenance |
+--------------------------------------+---------------------+---------------+-------------+--------------------+-------------+
| ffc0d684-5ac3-484f-bcbc-8b93a085f1f4 | controller-r430-0   | None          | power on    | manageable         | False       |
| 9a0e0c45-c7ec-4521-9f16-64553165670d | controller-r430-1   | None          | power on    | manageable         | False       |
| 94921ee3-d8d8-46f0-867c-639bc039adb4 | controller-r430-2   | None          | power on    | manageable         | False       |
| 0fa54bc7-8598-476a-9f08-080dc3d7ff6e | compute-r430-0      | None          | power on    | manageable         | False       |
| 24f64b45-ffee-4212-a773-2030e0efb46f | compute-m915-0      | None          | power on    | manageable         | False       |
| 1e547fc6-490c-4edc-910a-bec34bbfbbf6 | compute-m915-1      | None          | power on    | manageable         | False       |
| 5d567181-30de-4e8e-a3e8-ecf5aad49331 | compute-m915-2      | None          | power on    | manageable         | False       |
| 070ba59b-aaf2-4792-bc4f-7005075ef797 | compute-m915-3      | None          | power on    | manageable         | False       |
| 21bf4dde-d0d1-482d-b5a3-641c3062e7d9 | compute-m915-4      | None          | power on    | manageable         | False       |
| 8c755927-b3fb-43bb-a3bd-ca2e7aaa6aca | compute-m915-5      | None          | power on    | manageable         | False       |
| ca1ff31f-6470-4194-a509-90c769d02c2f | compute-m915-6      | None          | power on    | manageable         | False       |
| 72fbd648-8d67-43d0-90a0-f7e7a703a61e | compute-m915-7      | None          | power on    | manageable         | False       |
| e68b1122-c647-46d0-8318-a08446ab4208 | compute-sd530-0     | None          | power off   | manageable         | False       |
| 763454a0-2c80-49ef-a377-5f04fcc3e1bb | compute-sd530-1     | None          | power off   | manageable         | False       |
| 9a6507e2-5988-44f2-bb7c-eeb5715af3bc | compute-sd530-2     | None          | power off   | manageable         | False       |
| 742ba714-e06e-4d41-92e2-86cefecebd7e | compute-sd530-3     | None          | power off   | manageable         | False       |
| c3c0c093-7a9e-49ba-8001-8c279e5707f0 | compute-sd530-4     | None          | power off   | manageable         | False       |
| e8e49dcf-15ba-43dd-8e27-e56fe8000ff5 | compute-sd530-5     | None          | power off   | manageable         | False       |
| f099ba7b-6aba-4335-8519-5a1089ace349 | compute-sd530-6     | None          | power off   | manageable         | False       |
| 11ae79a2-8bdb-4d12-8686-af4b21088e59 | compute-sd530-7     | None          | power off   | manageable         | False       |
| 2c52a12c-581d-4d5d-b99f-0a4633525dc3 | compute-sd530-8     | None          | power off   | manageable         | False       |
| 844d36e0-ebc0-4798-9412-f822e74766ce | compute-sd530-9     | None          | power off   | manageable         | False       |
| 4c911600-77df-4222-92da-8b014648ffa3 | compute-sd530-10    | None          | power off   | manageable         | False       |
| e24a4e21-b7bb-4a87-89bf-8d4d87bcc412 | compute-sd530-11    | None          | power off   | manageable         | False       |
| be68d00d-8b26-451f-a208-8ff658bb095e | compute-sd530-12    | None          | power off   | manageable         | False       |
| 7a58514f-36d7-450e-9302-4c93bd86a807 | compute-sd530-13    | None          | power on    | manageable         | False       |
| 12c27424-e38c-4a81-98ad-e50506621cfd | compute-sd530-14    | None          | power off   | manageable         | False       |
| 3cb78a45-5d3c-4cea-af27-acd2dc5b3321 | compute-sd530-15    | None          | power off   | manageable         | False       |
| 8f77df5b-d0b8-41b3-b2ba-85f4e3cb1078 | compute-sd530-16    | None          | power off   | manageable         | False       |
| cea9d015-f9ba-4133-a5a6-fa4f317788f9 | compute-sd530-17    | None          | power off   | manageable         | False       |
| bd6bca98-cf4d-43ff-a428-99497b87b066 | compute-sd530-18    | None          | power off   | manageable         | False       |
| 1ef1333e-64e9-457a-9ae9-de51ecac91ba | compute-sd530-19    | None          | power off   | manageable         | False       |
| a6c41c2a-ebbd-46b0-8967-5305d2b87e32 | compute-sd530-20    | None          | power on    | manageable         | False       |
| 9a2dab35-02eb-4ccd-be1b-d7b999f0f8c5 | compute-sd530-21    | None          | power on    | manageable         | False       |
| fb942abc-67f2-465a-acbc-91e666035eb9 | compute-sd530-22    | None          | power on    | manageable         | False       |
| be92a070-b37d-43c9-b84d-c4d2516d010b | compute-sd530-23    | None          | power on    | manageable         | False       |
| 3aacbe9d-531e-40de-9d65-2f544cd531a1 | compute-gpu-sd530-0 | None          | power on    | manageable         | False       |
| e3f59f32-cb13-41d3-9a30-234ee5f8eed3 | compute-gpu-sd530-1 | None          | power on    | manageable         | False       |
+--------------------------------------+---------------------+---------------+-------------+--------------------+-------------+
```

# Introspect all baremetal hosts

To introspect a baremetal host in the undercloud:

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ openstack baremetal node manage controller-r430-0
(undercloud) [stack@nerc-undercloud01 ~]$ openstack overcloud node introspect --provide controller-r430-0
```

It's recommended that you watch console on at least the first couple of nodes
to check for any hiccups in the PXE boot process and then in the
ironic-python-agent introspection image boot.

When a node finishes the introspection process it posts its introspection data
back to the ironic service running in the undercloud. The `--provide` flag
flips the baremetal node state to available if the introspection succeeds.

You can check introspection status using:

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ openstack baremetal introspection list
```

A successful introspection should set the `capabilities` property on the baremetal host in ironic:

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ openstack baremetal node show --fields=properties compute-sd530-0
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                           |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| properties | {'capabilities': 'boot_mode:uefi,cpu_vt:true,cpu_aes:true,cpu_hugepages:true,cpu_hugepages_1g:true,cpu_txt:true', 'local_gb': '446', 'cpus': '96', 'cpu_arch': 'x86_64', 'memory_mb': '393216'} |
+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

and you should be able to list the network interfaces on the baremetal host:

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ openstack baremetal introspection interface list compute-sd530-0
+---------------+-------------------+----------------------+-------------------+----------------+
| Interface     | MAC Address       | Switch Port VLAN IDs | Switch Chassis ID | Switch Port ID |
+---------------+-------------------+----------------------+-------------------+----------------+
| ens5f0        | 0c:42:a1:5f:a0:40 | []                   | dc:77:4c:44:22:88 | Ethernet1/1    |
| eno1          | 08:94:ef:b5:76:a0 | []                   | None              | None           |
| enp0s20f0u1u6 | 0a:94:ef:b5:70:cd | []                   | None              | None           |
| ens5f1        | 0c:42:a1:5f:a0:41 | []                   | None              | None           |
| eno2          | 08:94:ef:b5:76:a1 | []                   | None              | None           |
+---------------+-------------------+----------------------+-------------------+----------------+
```

This is useful when updating the NIC aliases in
`/home/stack/nerc-osp-config/templates/net-config-data-lookup.yaml`

# Set baremetal node capabilities

Role

## Setting overcloud role
```sh
$ openstack baremetal node set --property capabilities='node:compute-lacp-0' compute-m915-0
```

## Hosts in UEFI mode

The introspection process should detect whether or not a node is booted in
`UEFI` mode and set the `boot_mode:uefi` capability automatically if necessary.

You can check whether that's the case using, e.g.:

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ openstack baremetal node show -f json -c properties compute-sd530-0
```

Replace `compute-sd530-0` in the above command with the target baremetal node
name.

If, for whatever reason, this is not the case you can set that property
manually using:

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ CAPS=$(openstack baremetal node show -f json -c properties compute-sd530-0  | jq -r '.properties | .capabilities')
(undercloud) [stack@nerc-undercloud01 ~]$ openstack baremetal node set --property "capabilities='boot_mode=uefi,${CAPS}'" compute-sd530-0
```

The first command sets a variable, `CAPS`, to capture the existing capabilities
property set by the introspection process. This variable is then used to append
to the existing set of capabilities for the node. This is necessary because the
subsequent `openstack baremetal node set --property` command will completely
override the capabilities property with whatever is provided.

# Configure role counts

Bump the `[ROLE]Count' parameters as necessary in
`/home/stack/nerc-osp-config/templates/environments/node-info.yaml`. As of July
2021, we have the following roles and counts:

```
(undercloud) [stack@nerc-undercloud01 ~]$ grep Count: /home/stack/nerc-osp-config/templates/environments/node-info.yaml
  ControllerCount: 3
  ComputeCount: 26
  ComputeLacpCount: 1
  ComputeLacpCustomCount: 8
```

The roles are as follows:

- `Controller` - default controller role
- `Compute` - default compute role with no LACP/bond setup
- `ComputeLacp` - default compute role with LACP bond setup
- `ComputeLacpCustom` - default compute role with LACP bond setup that uses a
  customized deploy image (`overcloud-full-custom`). This is currently only used for
  the `M915` hosts which require a deprecated (by RedHat) driver (`mpt3sas`)
  for the root disks.

# Run the overcloud deployment

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ mkdir -p /home/stack/logs/deploys
(undercloud) [stack@nerc-undercloud01 ~]$ time bash deploy.sh &> logs/deploys/deploy-$(date +"%Y-%m-%d_%H%M%S").log
```

A successful deploy will report that "ansible passed" at the end of the log, e.g.:

```sh
...
nerc-hyp-lacp-custom-6     : ok=295  changed=172  unreachable=0    failed=0    skipped=139  rescued=0    ignored=0
nerc-hyp-lacp-custom-7     : ok=295  changed=172  unreachable=0    failed=0    skipped=139  rescued=0    ignored=0
undercloud                 : ok=156  changed=31   unreachable=0    failed=0    skipped=50   rescued=0    ignored=0

Thursday 15 July 2021  19:01:01 -0400 (0:00:00.071)       0:53:45.004 *********
===============================================================================
tripleo-ceph-run-ansible : run ceph-ansible --------------------------- 574.54s
Pre-fetch all the containers ------------------------------------------ 363.27s
tripleo-kernel : Reboot after kernel args update ---------------------- 212.76s
tripleo-kernel : Reboot after kernel args update ---------------------- 147.82s
tripleo-kernel : Reboot after kernel args update ---------------------- 147.24s
Wait for containers to start for step 2 using paunch ------------------ 130.46s
Wait for containers to start for step 3 using paunch ------------------- 75.24s
Wait for container-puppet tasks (generate config) to finish ------------ 70.56s
Wait for containers to start for step 4 using paunch ------------------- 67.77s
tripleo-network-config : Run NetworkConfig script ---------------------- 41.20s
Wait for containers to start for step 5 using paunch ------------------- 39.38s
Pre-fetch all the containers ------------------------------------------- 34.04s
Wait for puppet host configuration to finish --------------------------- 30.97s
Wait for puppet host configuration to finish --------------------------- 23.74s
tripleo-hieradata : Render hieradata from template --------------------- 17.73s
Wait for puppet host configuration to finish --------------------------- 16.37s
Wait for puppet host configuration to finish --------------------------- 16.34s
Wait for puppet host configuration to finish --------------------------- 16.15s
Run tripleo-container-image-prepare logged to: /var/log/tripleo-container-image-prepare.log -- 13.44s
Wait for container-puppet tasks (bootstrap tasks) for step 4 to finish -- 13.41s

Ansible passed.
Overcloud configuration completed.
Overcloud Endpoint: https://nerc.rc.fas.harvard.edu:13000
Overcloud Horizon Dashboard URL: https://nerc.rc.fas.harvard.edu:443/dashboard
Overcloud rc file: /home/stack/nercrc
Overcloud Deployed without error
```

# Post-deploy ansible run

After a successful overcloud deployment, run the post-deploy ansible playbook
to setup flavors, images, networks, etc. for the overcloud:

**NOTE**: this requires a successful overcloud deployment that generates
`/home/stack/nercrc` file at the end. Please confirm the existence of this
environment file before running the following commands

```sh
(undercloud) [stack@nerc-undercloud01 ~]$ podman build /home/stack/nerc-osp-config/playbooks -t ansible-openstacksdk:latest
(undercloud) [stack@nerc-undercloud01 ~]$ bash /home/stack/nerc-osp-config/playbooks/run.sh 
```

See the `README.md` file in the `nerc-osp-config` repo under the `playbooks` directory for more info.
