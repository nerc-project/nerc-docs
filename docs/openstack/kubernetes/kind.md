# Kind

## Pre-requisite

We will need 1 VM to create a single node kubernetes cluster using `kind`.
We are using following setting for this purpose:

- 1 Linux machine, centos-7-x86_64, m1.medium flavor with 2vCPU, 4GB RAM,
10GB storage - also [assign Floating IP](../../create-and-connect-to-the-VM/assign-a-floating-IP.md)
 to this VM.
- setup Unique hostname to the machine using the following command:

```sh
echo "<node_internal_IP> <host_name>" >> /etc/hosts
hostnamectl set-hostname <host_name>
```

For example,

```sh
echo "192.168.0.167 kind" >> /etc/hosts
hostnamectl set-hostname kind
```

## Install docker on CentOS7

Run the below command on the CentOS7 VM:

- SSH into **kind** machine
- Switch to root user: `sudo su`
- Execute the below command to initialize the cluster:

```sh
yum -y install epel-release; yum -y install docker; systemctl enable --now docker;
systemctl status docker
```

```sh
docker version
```

## Install kubectl on CentOS7

```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl
```

- Test to ensure the version you installed is up-to-date:

```sh
kubectl version --client
```

## Install kind

```sh
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin
```

```sh
which kind

/usr/local/bin/kind
```

```sh
kind version

kind v0.11.1 go1.16.4 linux/amd64
```

- To communicate with cluster, just give the cluster name as a context in kubectl:

```sh
kind create cluster --name k8s-kind-cluster1

Creating cluster "k8s-kind-cluster1" ...
 ✓ Ensuring node image (kindest/node:v1.21.1) 🖼 
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-k8s-kind-cluster1"
You can now use your cluster with:

kubectl cluster-info --context kind-k8s-kind-cluster1
Thanks for using kind! 😊
```

- Get the cluster details:

```sh
kubectl cluster-info --context kind-k8s-kind-cluster1

Kubernetes control plane is running at https://127.0.0.1:38646
CoreDNS is running at https://127.0.0.1:38646/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

```sh
kubectl get all

NAME                TYPE       CLUSTER-IP  EXTERNAL-IP  PORT(S)  AGE
service/kubernetes  ClusterIP  10.96.0.1   <none>       443/TCP  5m25s
```

```sh
kubectl get nodes

NAME                             STATUS  ROLES                AGE    VERSION
k8s-kind-cluster1-control-plane  Ready  control-plane,master  5m26s  v1.21.11
```

### Deleting a Cluster

If you created a cluster with kind create cluster then deleting is equally simple:

```sh
kind delete cluster
```

---
