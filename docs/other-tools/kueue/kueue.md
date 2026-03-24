# Kueue

Kueue is an open-source Kubernetes controller designed to manage and
schedule batch jobs efficiently in environments with limited resources.
Instead of immediately running every job, Kueue introduces a queueing
system that decides which jobs should run, wait, or share resources based
on availability and policies.

## Pre-requisite

First ensure that Kueue is installed on the cluster.

### To install:

Find the version you wish to install here:
<https://github.com/kubernetes-sigs/kueue/releases>

**Install by kubectl** <br>
To install a released version of Kueue in your cluster by kubectl, run
the following command: <br>

```sh
kubectl apply --server-side -f \
  https://github.com/kubernetes-sigs/kueue/releases/download/v0.16.4/manifests.yaml
```

To wait for Kueue to be fully available, run:

```sh
kubectl wait deploy/kueue-controller-manager -nkueue-system \
  --for=condition=available --timeout=5m
```

**Install by Helm** <br>
To install a released version of Kueue in your cluster by Helm, run the
following command:<br>

```sh
helm install kueue oci://registry.k8s.io/kueue/charts/kueue \
  --version=0.16.4 \
  --namespace kueue-system \
  --create-namespace \
  --wait --timeout 300s
```

You can also use the following command:<br>

```sh
helm install kueue \
  https://github.com/kubernetes-sigs/kueue/releases/download/v0.16.4/kueue-0.16.4.tgz \
  --namespace kueue-system \
  --create-namespace \
  --wait --timeout 300s
```

This installs Kueue, but Kueue will be unmanaged, so it won't allow for
automated updates.<br>
To change it to be managed, in your overlays add: <br>

``` yaml
apiVersion: datasciencecluster.opendatahub.io/v1
kind: DataScienceCluster
metadata:
  name: default-dsc
spec:
  components:
    codeflare:
      managementState: Managed
    kserve:
      managementState: Managed
      nim:
        managementState: Managed
      rawDeploymentServiceConfig: Headless
      serving:
        ingressGateway:
          certificate:
            type: OpenshiftDefaultIngress
        managementState: Managed
        name: knative-serving
    modelregistry:
      managementState: Managed
      registriesNamespace: rhoai-model-registries
    trustyai:
      managementState: Managed
    ray:
      managementState: Managed
    kueue:
      managementState: Managed
    workbenches:
      managementState: Managed
    dashboard:
      managementState: Managed
    modelmeshserving:
      managementState: Managed
    datasciencepipelines:
      managementState: Managed
    trainingoperator:
      managementState: Removed
```

## Configure

1. Use the `ResourceFlavor` to establish the types of nodes you will be
   scheduling on. For instance if using a100, v100s, and h100s:

   ``` yaml
   apiVersion: kueue.x-k8s.io/v1beta1
   kind: ResourceFlavor
   metadata:
     name: v100-flavor
   spec:
     tolerations:
       - key: "nvidia.com/gpu.product"
         operator: "Equal"
         value: "Tesla-V100-PCIE-32GB"
         effect: "NoSchedule"
   ---
   apiVersion: kueue.x-k8s.io/v1beta1
   kind: ResourceFlavor
   metadata:
     name: a100-flavor
   spec:
     tolerations:
       - key: "nvidia.com/gpu.product"
         operator: "Equal"
         value: "NVIDIA-A100-SXM4-40GB"
         effect: "NoSchedule"
   ---
   apiVersion: kueue.x-k8s.io/v1beta1
   kind: ResourceFlavor
   metadata:
     name: h100-flavor
   spec:
     tolerations:
       - key: "nvidia.com/gpu.product"
         operator: "Equal"
         value: "NVIDIA-H100-80GB-HBM3"
         effect: "NoSchedule"
   ```

2. Use the clusterqueues to establish quotas:
   For each kind of `ResourceFlavor` you're using, you can establish its
   clusterqueue. You specify the name of that clusterqueue, what
   `ResourceFlavor` it handles, and the `nominalQuota` for each resource.
   For example, here are two clusterqueues for a100 and v100 GPUs:

   ``` yaml
   apiVersion: kueue.x-k8s.io/v1beta1
   kind: ClusterQueue
   metadata:
     name: v100-clusterqueue
   spec:
     namespaceSelector: {}
     resourceGroups:
       - coveredResources: ["nvidia.com/gpu", "cpu", "memory"]
         flavors:
           - name: "v100-flavor"   # reference the flavor you defined previously
             resources:
               - name: "nvidia.com/gpu"
                 nominalQuota: 5
               - name: "cpu"
                 nominalQuota: 20
               - name: "memory"
                 nominalQuota: 50Gi
   ---
   apiVersion: kueue.x-k8s.io/v1beta1
   kind: ClusterQueue
   metadata:
     name: a100-clusterqueue
   spec:
     namespaceSelector: {}
     resourceGroups:
       - coveredResources: ["nvidia.com/gpu", "cpu", "memory"]
         flavors:
           - name: "a100-flavor"
             resources:
               - name: "nvidia.com/gpu"
                 nominalQuota: 1
               - name: "cpu"
                 nominalQuota: 20
               - name: "memory"
                 nominalQuota: 50Gi
   ```

   If we wanted to have a resource on your cluster be inaccessible, you
   can set the `nominalQuota` value to `0`. For instance:

   ``` yaml
   apiVersion: kueue.x-k8s.io/v1beta1
   kind: ClusterQueue
   metadata:
     name: h100-clusterqueue
   spec:
     namespaceSelector: {}
     resourceGroups:
       - coveredResources: ["nvidia.com/gpu", "cpu", "memory"]
         flavors:
           - name: "h100-flavor"
             resources:
               - name: "nvidia.com/gpu"
                 nominalQuota: 0   # set to 0 if you have h100 nodes that
                                   # you don't want users to access
               - name: "cpu"
                 nominalQuota: 20
               - name: "memory"
                 nominalQuota: 50Gi
   ```

3. For a user to actually submit a job, they must have a `localqueue`
   pointing to the larger `clusterqueue` in their namespace. Otherwise,
   their job will be left pending/suspended. For example:

   ``` yaml
   apiVersion: kueue.x-k8s.io/v1beta1
   kind: LocalQueue
   metadata:
     name: v100-localqueue
     namespace: <NAMESPACE-NAME>
   spec:
     clusterQueue: v100-clusterqueue   # reference the clusterqueue name exactly
   ---
   apiVersion: kueue.x-k8s.io/v1beta1
   kind: LocalQueue
   metadata:
     name: a100-localqueue
     namespace: <NAMESPACE-NAME>
   spec:
     clusterQueue: a100-clusterqueue   # reference the clusterqueue name exactly
   ---
   apiVersion: kueue.x-k8s.io/v1beta1
   kind: LocalQueue
   metadata:
     name: h100-localqueue
     namespace: <NAMESPACE-NAME>
   spec:
     clusterQueue: h100-clusterqueue   # reference the clusterqueue name exactly
   ```

4. Now that the queues are set up, the user must have appropriate
   rolebindings to get information about the queues, create and view jobs.
   These can be adaptable to what the user wants to do.

   For instance, to view the queue — ClusterRoles to create and bind to:

   ``` yaml
   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRole
   metadata:
     name: <clusterqueue-reader-role-name>   # e.g. clusterqueue-reader
   rules:
     - apiGroups: ["kueue.x-k8s.io"]
       resources: ["clusterqueues"]
       verbs: ["get", "list", "watch"]   # or whatever verbs you plan to allow
   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRoleBinding
   metadata:
     name: <clusterqueue-reader-binding-name>   # e.g. clusterqueue-reader-binding
   roleRef:
     apiGroup: rbac.authorization.k8s.io
     kind: ClusterRole
     name: <clusterqueue-reader-role-name>      # must match above
   subjects:
     - kind: Group                         # can be User / ServiceAccount / Group
       name: <subject-name>                # e.g. cs599-pmpp or user@something.com
       apiGroup: rbac.authorization.k8s.io
   ```

5. Once you have the appropriate RBAC setup, you can submit a job to a
   queue:

   ``` yaml
   apiVersion: batch/v1
   kind: Job
   metadata:
     name: sample-job-9ab4cf
     annotations:
       kueue.x-k8s.io/queue-name: a100-localqueue   # specify the localqueue
   spec:
     parallelism: 3
     completions: 3
     template:
       spec:
         containers:
         - name: example-batch-workload
           image: registry.example/batch/calculate-pi:3.14
           args: ["30s"]
           resources:
             requests:
               cpu: 1
         restartPolicy: Never
   ```

If you are interested in using job based submission, we have a batchtools
cli to simplify job submission with Kueue:
[https://github.com/OCP-on-NERC/python-batchtools](https://github.com/OCP-on-NERC/python-batchtools)
