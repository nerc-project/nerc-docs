# Introduction to GPUs in NERC OpenShift

NERC OCP clusters leverage the [NVIDIA GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html) as well as the [Node Feature Discovery Operator](https://docs.openshift.com/container-platform/4.15/hardware_enablement/psap-node-feature-discovery-operator.html) to manage and deploy GPU worker nodes to clusters.

## NERC GPU Worker Node Arhitectures

The NERC OpenShift environment currently supports two different NVIDIA GPU products: 
1. NVIDIA-A100-SXM4-40GB (A100) 
2. Tesla-V100-PCIE-32GB (V100)

A100 worker nodes contain 4 individual gpus, each with 40GB of memory
V100 worker nodes contain 1 gpu with 32 GB of memory

## Accessing GPU Resources 

Access to GPU nodes is handled via OCP project allocations through NERC ColdFront. By default, user projects in NERC OCP clusters do not have access to GPUs and access must be granted through the user's ColdFront allocation by a NERC admin. 

## Deploying Workloads to GPUs

There are two ways to deploy workloads on GPU nodes:

1. Deploy directly in your OCP namespace:

In your project namespace you can deploy a GPU workload by explicitely requesting a GPU in your manifest, like for instance:
```
apiVersion: v1
kind: Pod
metadata:
  name: sample-gpu-request
spec:
  restartPolicy: Never
  containers:
  - name: sample-gpu-request
    image: <your-image-url>
    ...
    ...
    resources:
      limits:
        nvidia.com/gpu: 1
```

2. Deploy through RHOAI 

See [Populate the data science project with a Workbench](https://github.com/nerc-project/nerc-docs/blob/main/docs/openshift-ai/data-science-project/using-projects-the-rhoai.md#populate-the-data-science-project-with-a-workbench) for selecting GPU options. 