# K3s with High Availability setup

First, Kubernetes HA has **two possible setups**: embedded or external database
(DB). We’ll use the **external DB** in this HA K3s cluster setup. For which `MySQL`
is the external DB as shown here:
[k3s HA architecture with external database][../images/k3s_ha_architecture.jpg]

In the diagram above, both the user running `kubectl` and each of the two agents
connect to the TCP **Load Balancer**. The Load Balancer uses a list of private IP
addresses to balance the traffic between the **three servers**. If one of the
servers crashes, it is be removed from the list of IP addresses.

The servers use the **SQL data store** to synchronize the cluster’s state.

## Requirements

i. Managed TCP Load Balancer
ii. Managed MySQL service
iii. Three VMs to run as K3s servers
iv. Two VMs to run as K3s agents

There are some strongly recommended [Kubernetes HA best practices](https://kubernetes.io/docs/tasks/administer-cluster/highly-available-master/#best-practices-for-replicating-masters-for-ha-clusters)
and also there is [Automated HA master deployment doc](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/cluster-lifecycle/ha_master.md)

## Managed TCP Load Balancer

Create a load balancer using `nginx`:
The `nginx.conf` located at `etc/nginx/nginx.conf` contains upstream that is pointing
to the 3 K3s Servers on port 6443 as shown below:

```sh
events {}
...

stream {
  upstream k3s_servers {
    server <k3s_server1-Internal-IP>:6443;
    server <k3s_server2-Internal-IP>:6443;
    server <k3s_server3-Internal-IP>:6443;
  }

  server {
    listen 6443;
    proxy_pass k3s_servers;
  }
}
```

## Managed MySQL service

Create a MySQL database setver with a **new database** and create a new
**mysql user and password** with granted permission to read/write the new database.
In this example, you can create:

database name: `<YOUR_DB_NAME>`
database user: `<YOUR_DB_USER_NAME>`
database password: `<YOUR_DB_USER_PASSWORD>` #pragma: allowlist secret

## Three VMs to run as K3s servers

Create 3 K3s Master VMs and perform the following steps on each of them:
i. Export the datastore endpoint:

```sh
export K3S_DATASTORE_ENDPOINT='mysql://<YOUR_DB_USER_NAME>:<YOUR_DB_USER_PASSWORD>@tcp(<MySQL-Server-Internal-IP>:3306)/<YOUR_DB_NAME>'
```

ii. Install the K3s with setting not to deploy any pods on this server
(opposite of affinity) unless critical addons and `tls-san` set `<Loadbalancer-Internal-IP>`
as alternative name for that tls certificate.

```sh
curl -sfL https://get.k3s.io | sh -s - server \
    --node-taint CriticalAddonsOnly=true:NoExecute \
    --tls-san <Loadbalancer-Internal-IP_or_Hostname>
```

- Verify all master nodes are visible to eachothers:

```sh
sudo k3s kubectl get node
```

- Generate **token** from one of the K3s Master VMs:
You need to extract a token form the master that will be used to join the nodes
to the control plane by running following command on one of the K3s master node:

```sh
sudo cat /var/lib/rancher/k3s/server/node-token
```

You will then obtain a token that looks like:

```sh
K1097aace305b0c1077fc854547f34a598d23330ff047ddeed8beb3c428b38a1ca7::server:6cc9fbb6c5c9de96f37fb14b5535c778
```

## Two VMs to run as K3s agents

Set the `K3S_URL` to point to the Loadbalancer’s internal IP and set the `K3S_TOKEN`
from the clipboard on both of the agent nodes:

```sh
curl -sfL https://get.k3s.io | K3S_URL=https://<Loadbalancer-Internal-IP_or_Hostname>:6443
    K3S_TOKEN=<Token_From_Master> sh -
```

Once both Agents are running, if you run the following command on Master Server,
you can see all nodes:

```sh
`sudo k3s kubectl get node`
```

### Simulate a failure

To simulate a failure, stop the K3s service on one or more of the K3s servers manually,
then run the `kubectl get nodes` command:

```sh
sudo systemctl stop k3s
```

**The third server will take over at this point.**

- To restart servers manually:

```sh
sudo systemctl restart k3s
```

### On your local development machine

!!!note "Important Requirement"
    Your local development machine must have installed `kubectl`.

Copy the `kubeconfig` file's content located at the K3s master node at `/etc/rancher/k3s/k3s.yaml`
to your local machine's `~/.kube/config` file. Before saving, please change the cluster
server path from **127.0.0.1** to **`<Loadbalancer-Internal-IP>`**. This will allow
your local machine to see the cluster nodes:

```sh
kubectl get nodes
```

## Kubernetes Dashboard

check [releases](https://github.com/kubernetes/dashboard/releases) for the command
to use for *Installation*:

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
```

- Dashboard RBAC Configuration:

`dashboard.admin-user.yml`

```sh
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
```

`dashboard.admin-user-role.yml`

```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

- Deploy the `admin-user` configuration:

!!!note "Important Note"
    If you’re doing this from your local development machine, remove `sudo k3s` and
    just use `kubectl`)

```sh
sudo k3s kubectl create -f dashboard.admin-user.yml -f dashboard.admin-user-role.yml
```

- Get bearer **token**

sudo k3s kubectl -n kubernetes-dashboard describe secret admin-user-token
    | grep ^token

- Start *dashboard* locally:

```sh
sudo k3s kubectl proxy
```

Then you can sign in at this URL using your *token* we got in the previous step:

`http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`

### Deploying Nginx using deployment

- Create a deployment `nginx.yaml`:

```sh
vi nginx.yaml
```

- Copy and paste the following conent on `nginx.yaml`:

```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysite
  labels:
    app: mysite
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysite
  template:
    metadata:
      labels:
        app : mysite
    spec:
      containers:
        - name : mysite
          image: nginx
          ports:
            - containerPort: 80
```

```sh
sudo k3s kubectl apply -f nginx.yaml
```

- Verify the nginx pod is on **Running** state:

```sh
sudo k3s kubectl get pods --all-namespaces
```

- Scale the pods to available agents:

```sh
sudo k3s kubectl scale --replicas=2 deploy/mysite
```

- View all deployment status:

```sh
sudo k3s kubectl get deploy mysite

NAME     READY   UP-TO-DATE   AVAILABLE   AGE
mysite   2/2     2            2           85s
```

- Delete the nginx deployment and pod:

```sh
sudo k3s kubectl delete -f nginx.yaml
```

**OR,**

```sh
sudo k3s kubectl delete deploy mysite
```

---
