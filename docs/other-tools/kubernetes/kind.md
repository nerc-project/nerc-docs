# Kind

## Pre-requisite

We will need 1 VM to create a single node kubernetes cluster using `kind`.
We are using following setting for this purpose:

- 1 Linux machine, `almalinux-9-x86_64`, `cpu-su.2` flavor with 2vCPU, 8GB RAM,
20GB storage - also [assign Floating IP](../../openstack/create-and-connect-to-the-VM/assign-a-floating-IP.md)
 to this VM.

- setup Unique hostname to the machine using the following command:

    ```sh
    echo "<node_internal_IP> <host_name>" >> /etc/hosts
    hostnamectl set-hostname <host_name>
    ```

    For example:

    ```sh
    echo "192.168.0.167 kind" >> /etc/hosts
    hostnamectl set-hostname kind
    ```

## Install docker on AlmaLinux

Run the below command on the AlmaLinux VM:

- SSH into **kind** machine

- Switch to root user: `sudo su`

- Execute the below command to initialize the cluster:

    Please remove `container-tools` module that includes stable versions of podman,
    buildah, skopeo, runc, conmon, etc as well as dependencies and will be removed
    with the module. If this module is not removed then it will conflict with Docker.
    Red Hat does recommend Podman on RHEL 8.

    ```sh
    dnf module remove container-tools

    dnf update -y

    dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

    dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin

    systemctl start docker
    systemctl enable --now docker
    systemctl status docker

    docker -v
    ```

## Install kubectl on AlmaLinux

```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/bin/kubectl
chmod +x /usr/bin/kubectl
```

- Test to ensure that the `kubectl` is installed:

    ```sh
    kubectl version --client
    ```

## Install kind

```sh
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/bin
```

```sh
which kind

/bin/kind
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

    Have a nice day! 👋
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
    k8s-kind-cluster1-control-plane  Ready  control-plane,master  5m26s  v1.21.1
    ```

## Deleting a Cluster

If you created a cluster with kind create cluster then deleting is equally simple:

```sh
kind delete cluster
```

---
