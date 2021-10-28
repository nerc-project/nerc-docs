# k0s

## Key Features

- Available as a single static binary
- Offers a self-hosted, isolated control plane
- Supports a variety of storage backends, including etcd, SQLite, MySQL (or any
compatible), and PostgreSQL.
- Offers an Elastic control plane
- Vanilla upstream Kubernetes
- Supports custom container runtimes (containerd is the default)
- Supports custom Container Network Interface (CNI) plugins (calico is the default)
- Supports x86_64 and arm64

## Pre-requisite

We will need 1 VM to create a single node kubernetes cluster using `k0s`.
We are using following setting for this purpose:

- 1 Linux machine, ubuntu-20.04-x86_64, m1.medium flavor with 2vCPU,
4GB RAM, 10GB storage - also [assign Floating IP](../../create-and-connect-to-the-VM/assign-a-floating-IP.md)
 to this VM.
- setup Unique hostname to the machine using the following command:

```sh
echo "<node_internal_IP> <host_name>" >> /etc/hosts
hostnamectl set-hostname <host_name>
```

For example,

```sh
echo "192.168.0.252 k0s" >> /etc/hosts
hostnamectl set-hostname k0s
```

## Install k0s on Ubuntu

Run the below command on the Ubuntu VM:

- SSH into **k0s** machine
- Switch to root user: `sudo su`

- Update the repositories and packages:

```sh
apt-get update && apt-get upgrade -y
```

- Download k0s:

```sh
curl -sSLf https://get.k0s.sh | sudo sh
```

- Install k0s as a service:

```sh
k0s install controller --single

INFO[2021-10-12 01:45:52] no config file given, using defaults
INFO[2021-10-12 01:45:52] creating user: etcd
INFO[2021-10-12 01:46:00] creating user: kube-apiserver
INFO[2021-10-12 01:46:00] creating user: konnectivity-server
INFO[2021-10-12 01:46:00] creating user: kube-scheduler
INFO[2021-10-12 01:46:01] Installing k0s service
```

- Start `k0s` as a service:

```sh
k0s start
```

- Check service, logs and `k0s` status:

```sh
k0s status

Version: v1.22.2+k0s.1
Process ID: 16625
Role: controller
Workloads: true
```

- Access your cluster using `kubectl`:

```sh
k0s kubectl get nodes

NAME   STATUS   ROLES    AGE    VERSION
k0s    Ready    <none>   8m3s   v1.22.2+k0s
```

```sh
alias kubectl='k0s kubectl'
kubectl get nodes -o wide
```

```sh
kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   38s
```

## Uninstall k0s

- Stop the service:

```sh
sudo k0s stop
```

- Execute the `k0s reset` command - cleans up the installed system service, data
directories, containers, mounts and network namespaces.

```sh
sudo k0s reset
```

- Reboot the system

---
