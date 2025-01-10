Title: Undercloud Bootstrap
Date: 2021-06-11 14:38
Modified: 2021-06-11 14:38
Category: HowTo
Tags: undercloud, director, OSP
Slug: undercloud-bootstrap
Authors: Justin Riley
Summary: How to bootstrap the undercloud VM for NERC OpenStack deployment

# Creating the Undercloud VM

To create the "base" undercloud VM host:

```sh
[root@nerc-admin01]$ mkdir -p /srv/{repos,isos,kickstarts,qcow2s}
[root@nerc-admin01]$ (cd /srv/isos/ && curl -LO https://url/to/rhel-8.2-x86_64-dvd.iso)
[root@nerc-admin01]$ git clone https://gitlab-int.rc.fas.harvard.edu/nerc/nerc-osp-config.git /srv/repos/nerc-osp-config
# insert root, admin, and stack crypted pw hashes as well as redhat subscription org and key in kickstart
[root@nerc-admin01]$ ln -s /srv/repos/nerc-osp-config/undercloud/kickstarts/undercloud.cfg /srv/kickstarts/undercloud.cfg
[root@nerc-admin01]$ cd /srv/repos/nerc-osp-config/undercloud
# tweak bin/build-undercloud-vm.sh env variables as desired (e.g. root disk size, cpus, ram, etc)
[root@nerc-admin01]$ bash bin/build-undercloud-vm.sh
```

This will create the qcow2 for the root disk and boot the RHEL8.2 installer.
You can connect using VNC to watch the install process. Often times it's useful
to look around the destination root disk (mounted at `/mnt/sysimage`), process
table (e.g. `pgrep -lfa dnf`), etc. while the installer is running:

```sh
[root@nerc-admin01]$ virsh vncdisplay nerc-undercloud01
:0
```

Connect to `nerc-admin01.rc.fas.harvard.edu` with a VNC viewer and specify the
above number as the display. If your VNC viewer requires a network port instead
of display number, add 5900 to the display number and use that for the
port value.

Once the install has completed the VM will power off. Start the VM to boot
from the root disk:

```sh
[root@nerc-admin01]$ virsh start nerc-undercloud01
```

After the VM boots you should be able to ssh there using `nerc-admin01` ssh key
as both `root` and `stack` users:

```sh
[root@nerc-admin01]$ ssh root@nerc-undercloud01
[root@nerc-admin01]$ ssh stack@nerc-undercloud01
```

# Sanity checks

Inspect `/root/kickstart-post.log` for errors and make adjustments to the
kickstart as necessary. If adjustments were needed please submit a pull/merge
request to the nerc-osp-config repo.

## Retrying a previously failed virt-install

To retry a previously failed virt-install attempt, undefine the domain and
delete the root disk and run `build-undercloud-vm.sh` again:

```sh
[root@nerc-admin01]$ virsh destroy nerc-undercloud01
[root@nerc-admin01]$ virsh undefine nerc-undercloud01
[root@nerc-admin01]$ rm -rf /srv/qcow2s/nerc-undercloud01.qcow2
[root@nerc-admin01]$ bash /srv/repos/nerc-osp-config/undercloud/bin/build-undercloud-vm.sh
```

# Deploying the undercloud services

## Preparation

First clone the nerc-osp-config repo and setup symlinks:

```sh
[stack@nerc-undercloud01]$ cd $HOME
[stack@nerc-undercloud01]$ rm -rf templates
[stack@nerc-undercloud01]$ git clone https://gitlab-int.rc.fas.harvard.edu/nerc/nerc-osp-config
[stack@nerc-undercloud01]$ ln -s nerc-osp-config/templates
[stack@nerc-undercloud01]$ mkdir -p $HOME/bin && ln -s $HOME/nerc-osp-config/bin/deploy.sh $HOME/bin/
[stack@nerc-undercloud01]$ ln -s nerc-osp-config/undercloud/undercloud.conf
```

Next edit the containers-prepare-parameter.yaml config and add the redhat
registry credentials:

```sh
[stack@nerc-undercloud01]$ vim ~/templates/containers-prepare-parameter.yaml
```

## Install
To kick off the undercloud install:

**NOTE**: This command expects undercloud.conf to be in the `$HOME` directory.

**NOTE**: **THIS COMMAND WILL FAIL THE FIRST TIME YOU RUN IT - KEEP READING**.

```sh
[stack@nerc-undercloud01]$ openstack undercloud install
```

The very first run will eventually modify the host's networking setup to
configure a `br-ctlplane` device for the undercloud which breaks the default
route. This in turn causes any networking operation which requires outbound
internet access (e.g. simple dnf package installs) to fail which fails the
install.

This happens due to the fact that we use a single network for both management
and provisioning instead of the required/recommended separate networks on
separate NICs. With the recommended setup, the management interface holds the
default route and is untouched by the undercloud deploy (only provisioning NIC
gets specified in the undercloud.conf). See:
https://access.redhat.com/solutions/2923521 for more details. Unfortunately in
our setup this breaks outbound internet access.

Run the following to temporarily fix the default route after the first failed
run:

```sh
[stack@nerc-undercloud01]$ sudo ip route add default via 10.255.0.1 dev br-ctlplane
```

Then run the deploy again which, hopefully, will succeed this time:

```sh
[stack@nerc-undercloud01]$ openstack undercloud install
```

Once the install succeeds, run the following command to make the default route
persist a reboot:

```sh
[stack@nerc-undercloud01]$ echo "0.0.0.0/0 via 10.255.0.1 dev br-ctlplane" | sudo tee -a /etc/sysconfig/network-scripts/route-br-ctlplane >/dev/null
```

**NOTE**: From this point on, any future undercloud install run will break the
default route and you have to play the same game all over again: temporarily
fix the issue with `ip route add`, try the run again, if it succeeds update the
custom `route-br-ctlplane` config to persist a reboot.

This is due to the fact that the ansible run reverts our update to the
`route-br-ctlplane` config and restarts the network service which removes the
default route and breaks outbound internet access again. Unfortunately, we've
yet to find a way to define this default route in the undercloud config to
prevent this issue. Therefore, only update the `route-br-ctlplane` config when
you're done running undercloud installs (ie on success).
