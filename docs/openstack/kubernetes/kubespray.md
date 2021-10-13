# Kubespray

## Pre-requisite

We will need 1 control-plane(master) and 1 worker node to create a single
control-plane kubernetes cluster using `Kubespray`. We are using following setting
for this purpose:

- 1 Linux machine for Ansible master, ubuntu-20.04-x86_64, m1.medium flavor with
2vCPU, 4GB RAM, 10GB storage.
- 1 Linux machine for master, ubuntu-20.04-x86_64, m1.medium flavor with 2vCPU,
4GB RAM, 10GB storage - also [assign Floating IP](../../create-and-connect-to-the-VM/assign-a-floating-IP.md)
 to the master node.
- 1 Linux machines for worker, ubuntu-20.04-x86_64, m1.small flavor with 1vCPU,
 2GB RAM, 10GB storage.
- ssh access to all machines: [Read more here](../../create-and-connect-to-the-VM/bastion-host-based-ssh/index.md)
on how to setup SSH to your remote VMs.
- To allow SSH from **Ansible master** to all **other nodes**: [Read more here](../../create-and-connect-to-the-VM/ssh-to-cloud-VM/#adding-other-peoples-ssh-keys-to-the-instance)
    Generate SSH key for Ansible master node using:

    ```sh
    ssh-keygen -t rsa

    Generating public/private rsa key pair.
    Enter file in which to save the key (/root/.ssh/id_rsa): 
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /root/.ssh/id_rsa
    Your public key has been saved in /root/.ssh/id_rsa.pub
    The key fingerprint is:
    SHA256:OMsKP7EmhT400AJA/KN1smKt6eTaa3QFQUiepmj8dx0 root@ansible-master
    The key's randomart image is:
    +---[RSA 3072]----+
    |=o.oo.           |
    |.o...            |
    |..=  .           |
    |=o.= ...         |
    |o=+.=.o SE       |
    |.+*o+. o. .      |
    |.=== +o. .       |
    |o+=o=..          |
    |++o=o.           |
    +----[SHA256]-----+
    ```

    Copy and append the content of **SSH public key** i.e. `~/.ssh/id_rsa.pub` to
    other nodes's `~/.ssh/authorized_keys` file.
    This will allow `ssh <other_nodes_internal_ip>` from the Ansible master node's
    terminal.

- Create 2 security groups with appropriate [ports and protocols](https://kubernetes.io/docs/reference/ports-and-protocols/):

    i. To be used by the master nodes:
    ![Control plane ports and protocols](../images/control_plane_ports_protocols.png)
    ii. To be used by the worker nodes:
    ![Worker node ports and protocols](../images/worker_nodes_ports_protocols.png)
- setup Unique hostname to each machine using the following command:

```sh
echo "<node_internal_IP> <host_name>" >> /etc/hosts
hostnamectl set-hostname <host_name>
```

For example,

```sh
echo "192.168.0.224 ansible_master" >> /etc/hosts
hostnamectl set-hostname ansible_master
```

In this step, you will update packages and disable `swap` on the all 3 nodes:
    i. 1 Ansible Master Node - ansible_master
    ii. 1 Kubernetes Master Node - kubspray_master
    iii.1 Kubernetes Worker Node - kubspray_worker1

The below steps will be performed on all the above mentioned nodes:

- SSH into all the 3 machines

- Switch as root: `sudo su`

- Update the repositories and packages:

```sh
apt-get update && apt-get upgrade -y
```

- Turn off `swap`

```sh
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab
```

---

## Configure Kubespray on `ansible_master` node using [**Ansible Playbook**](https://www.ansible.com/)

Run the below command on the master node i.e. `master` that you want to setup as
control plane.

- SSH into **ansible_master** machine
- Switch to root user: `sudo su`
- Execute the below command to initialize the cluster:

- Install Python3 and upgrade pip to pip3:

```sh
apt install python3-pip -y
pip3 install --upgrade pip
python3 -V && pip3 -V
pip -V
```

- Clone the *Kubespray* git repository:

```sh
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
```

- Install dependencies from ``requirements.txt``:

```sh
pip install -r requirements.txt
```

- Copy ``inventory/sample`` as ``inventory/mycluster``

```sh
cp -rfp inventory/sample inventory/mycluster
```

- Update Ansible inventory file with inventory builder
This step is little trivial because we need to update `hosts.yml` with the nodes
IP.

Now we are going to declare a variable **"IPS"** for storing the IP address of
other K8s nodes .i.e. kubspray_master(192.168.0.130), kubspray_worker1(192.168.0.32)

```sh
declare -a IPS=(192.168.0.189 192.168.0.116)
CONFIG_FILE=inventory/mycluster/hosts.yml python3 \
    contrib/inventory_builder/inventory.py ${IPS[@]}

DEBUG: Adding group all
DEBUG: Adding group kube_control_plane
DEBUG: Adding group kube_node
DEBUG: Adding group etcd
DEBUG: Adding group k8s_cluster
DEBUG: Adding group calico_rr
DEBUG: adding host node1 to group all
DEBUG: adding host node2 to group all
DEBUG: adding host node1 to group etcd
DEBUG: adding host node1 to group kube_control_plane
DEBUG: adding host node2 to group kube_control_plane
DEBUG: adding host node1 to group kube_node
DEBUG: adding host node2 to group kube_node
```

- After running the above commands do verify the `hosts.yml` and its content:

```sh
cat inventory/mycluster/hosts.yml
```

The content of the `hosts.yml` file should looks like:

```yaml
all:
  hosts:
    node1:
      ansible_host: 192.168.0.76
      ip: 192.168.0.76
      access_ip: 192.168.0.76
    node2:
      ansible_host: 192.168.0.176
      ip: 192.168.0.176
      access_ip: 192.168.0.176
  children:
    kube_control_plane:
      hosts:
        node1:
        node2:
    kube_node:
      hosts:
        node1:
        node2:
    etcd:
      hosts:
        node1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```

- Review and change parameters under ``inventory/mycluster/group_vars``

```sh
cat inventory/mycluster/group_vars/all/all.yml
cat inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
```

- It can be useful to set the following two variables to true in
`inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml`: `kubeconfig_localhost`
(to make a copy of `kubeconfig` on the host that runs Ansible in
`{ inventory_dir }/artifacts`) and `kubectl_localhost`
(to download `kubectl` onto the host that runs Ansible in `{ bin_dir }`).

!!!note "Very Important"
    As **Ubuntu 20 kvm kernel** doesn't have **dummy module** we need to **modify**
    the following two variables in `inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml`:
    `enable_nodelocaldns: false` and `kube_proxy_mode: iptables` which will
    *Disable nodelocal dns cache* and *Kube-proxy proxyMode to iptables* respectively.

- Deploy Kubespray with Ansible Playbook - run the playbook as `root` user.
The option `--become` is required, as for example writing SSL keys in `/etc/`,
installing packages and interacting with various `systemd` daemons. Without
`--become` the playbook will fail to run!

```sh
ansible-playbook -i inventory/mycluster/hosts.yml --become --become-user=root cluster.yml
```

!!!note "Note"
    Running ansible playbook takes little time because it depends on the network
    bandwidth also.

---

## Install **kubectl** on Kubernetes master node .i.e. `kubspray_master`

- Install kubectl binary

```sh
snap install kubectl --classic

kubectl 1.22.2 from Canonical✓ installed
```

- Now verify the kubectl version:

```sh
kubectl version -o yaml
```

---

## Validate all cluster components and nodes are visible on all nodes

- Verify the cluster

```sh
kubectl get nodes

NAME               STATUS        ROLES                  AGE     VERSION
kubspray_master    NotReady      control-plane,master   21m     v1.16.2
kubspray_worker1   Ready         <none>                 9m17s   v1.16.2

```

---

### Deploy A [Hello Minikube Application](minikube.md#deploy-a-hello-minikube-application)

- Use the kubectl create command to create a Deployment that manages a Pod. The Pod
runs a Container based on the provided Docker image.

```sh
kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.4
```

```sh
kubectl expose deployment hello-minikube --type=LoadBalancer --port=8080

service/hello-minikube exposed
```

- View the deployments information:

```sh
kubectl get deployments

NAME             READY   UP-TO-DATE   AVAILABLE   AGE
hello-minikube   1/1     1            1           50s
```

- View the port information:

```sh
kubectl get svc hello-minikube

NAME             TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
hello-minikube   LoadBalancer   10.233.35.126   <pending>     8080:30723/TCP   40s
```

- View the web url for the service:

```sh
minikube service hello-minikube --url
```

- Expose the service locally

```sh
kubectl port-forward svc/hello-minikube 30723:8080
Forwarding from [::1]:30723 -> 8080
Forwarding from 127.0.0.1:30723 -> 8080
Handling connection for 30723
Handling connection for 30723
```

Go to browser, visit `http://<Master-Floating-IP>:8080`
i.e. <http://140.247.152.235:8080/> to check the hello minikube default page.

### Clean up

Now you can clean up the app resources you created in your cluster:

```sh
kubectl delete service my-nginx
kubectl delete deployment my-nginx

kubectl delete service hello-minikube
kubectl delete deployment hello-minikube
```

---
