# Minishift

## What Is the OKD Architecture?

OKD is a platform for developing and running containerized applications. OKD has
a microservices-based architecture of smaller, decoupled units that work
together. It runs on top of a Kubernetes cluster, with data about the objects
stored in etcd, a reliable clustered key-value store. Those services are broken
down by function:

- REST APIs, which expose each of the core objects.

- Controllers, which read those APIs, apply changes to other objects, and report
status or write back to the object.

![OKD Architecture Overview](images/okd_architecture.png)

For more information on the node types in the architecture overview,
see [Kubernetes Infrastructure](https://docs.okd.io/3.11/architecture/infrastructure_components/kubernetes_infrastructure.html#architecture-infrastructure-components-kubernetes-infrastructure).

## Minishift Quickstart

OKD also offers a comprehensive web console and the custom OpenShift CLI (oc) interface.
The interaction with OpenShift is with the command line tool oc which is copied to
your host.

## Pre-requisite

We will need 1 VM to create a single node kubernetes cluster using `minishift`.
We are using following setting for this purpose:

- 1 Linux machine, ubuntu-20.04-x86_64, m1.large flavor with 4vCPU, 8GB RAM,
10GB storage - also [assign Floating IP](../../create-and-connect-to-the-VM/assign-a-floating-IP.md)
 to this VM.
- setup Unique hostname to the machine using the following command:

```sh
echo "<node_internal_IP> <host_name>" >> /etc/hosts
hostnamectl set-hostname <host_name>
```

For example,

```sh
echo "192.168.0.134 minishift" >> /etc/hosts
hostnamectl set-hostname minishift
```

## Install MiniShift on Ubuntu

Run the below command on the Ubuntu VM:

- SSH into **minishift** machine
- Switch to root user: `sudo su`

You will need to [set up the virtualization environment](https://docs.okd.io/latest/minishift/getting-started/setting-up-virtualization-environment.html)
before installing MiniShift.

- Update the repositories and packages:

```sh
apt-get update && apt-get upgrade -y
```

- Install **libvirt** and **qemu-kvm** on your system:

```sh
apt install qemu-kvm libvirt-daemon libvirt-daemon-system -y
```

- Create group if does not exist:

```sh
addgroup libvirtd
adduser $(whoami) libvirtd
```

- Add yourself to the libvirt(d) group:

```sh
usermod -a -G libvirt $(whoami)
```

**OR,**

```sh
usermod -a -G libvirt $USER
```

- Update your current session to apply the group change:

```sh
newgrp libvirtd
```

- As root, install the KVM driver binary and make it executable as follows:

```sh
curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-ubuntu16.04
-o /usr/local/bin/docker-machine-driver-kvm
chmod +x /usr/local/bin/docker-machine-driver-kvm
```

- Check the status of **libvirtd**:

```sh
systemctl is-active libvirtd
```

- If libvirtd is not active, start the libvirtd service:

```sh
systemctl start libvirtd
```

- Download the archive for your operating system from the
[Minishift Releases](https://github.com/minishift/minishift/releases) page.

```sh
curl -LO https://github.com/minishift/minishift/releases/download/v1.34.3/minishift-1.34.3-linux-amd64.tgz
```

- Unzip and Copy MiniShift in your path

```sh
tar -zxvf minishift-1.34.3-linux-amd64.tgz --strip=1 -C/usr/local/bin minishift-1.34.3-linux-amd64/minishift
```

### Starting Minishift

By running the command: `minishift start`

!!!note "Note":
    cpu, and start memory, If you do not specify a disk-size 2vCPU, 4GB memory, with
    20GB disk. Other customized minishift can be started following this format:
    `minishift start --openshift-version v3.11.0 --iso-url centos --cpus 4 \
    --memory 12GB --disk-size 60GB`

```sh
minishift start
-- Starting local OpenShift cluster using 'kvm' hypervisor...
...
OpenShift server started.

The server is accessible via web console at:
    https://192.168.42.226:8443/console

You are logged in as:
    User:     developer
    Password: <any value> #pragma: allowlist secret

To login as administrator:
    oc login -u system:admin
```

!!!note "Note"
    - The IP is dynamically generated for each OpenShift cluster. To check the IP,
    run the `minishift ip` command.
    - By default, Minishift uses the driver most relevant to the host OS. To
    use a different driver, set the `--vm-driver` flag in `minishift start`. For
    example, to use VirtualBox instead of KVM on Linux operating systems, run
    `minishift start --vm-driver=virtualbox`. To persistent configuration so that
    you to run minishift start without explicitly passing i.e. in global scope the
    `--vm-driver virtualbox` flag each time, run:
    `minishift config set vm-driver virtualbox`.

You can run this command in a shell after starting Minishift to get the URL of the
Web console:

```sh
minishift console --url
```

Use `minishift oc-env` to display the command you need to type into your shell
in order to add the oc binary to your `PATH` environment variable. The output of
`oc-env` will differ depending on OS and shell type.

```sh
$ minishift oc-env
export PATH="/root/.minishift/cache/oc/v3.11.0/linux:$PATH"
# Run this command to configure your shell:
# eval $(minishift oc-env)
```

### Deploying a Sample Application

OpenShift provides various sample applications, such as templates, builder
applications, and quickstarts. The following steps describe how to deploy a sample
Node.js application from the command line.

- Create a Node.js example app:

```sh
oc new-app https://github.com/sclorg/nodejs-ex -l name=myapp
```

- Track the build log until the app is built and deployed:

```sh
oc logs -f bc/nodejs-ex
```

- Expose a route to the service:

```sh
oc expose svc/nodejs-ex
```

- Access the application:

```sh
minishift openshift service nodejs-ex --in-browser
```

- To stop Minishift, use the following command:

```sh
minishift stop
Stopping local OpenShift cluster...
Stopping "minishift"...
```

### Updating Minishift

```sh
minishift update
```

### Uninstalling Minishift

- Delete the Minishift VM and any VM-specific files:

```sh
minishift delete
```

This command deletes everything in the $MINISHIFT_HOME/.minishift/machines/minishift
directory. Other cached data and the persistent configuration are not removed.

- To completely uninstall Minishift, delete everything in the *MINISHIFT_HOME* directory
(default `~/.minishift`) and `~/.kube`:

```sh
rm -rf ~/.minishift
rm -rf ~/.kube
```

- With your hypervisor management tool, confirm that there are no remaining artifacts
related to the Minishift VM. For example, if you use KVM, you need to run the `virsh`
command.

### Connecting to the Minishift VM with SSH

You can use the `minishift ssh` command to interact with the Minishift VM.

```sh
minishift ssh -- docker ps
CONTAINER    IMAGE                COMMAND                CREATED   STATUS       NAMES
71fe8ff16548 openshift/origin:... "/usr/bin/openshift s" 1 sec ago Up 1 second  origin
```

---
