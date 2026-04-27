# OpenShift Overview

OpenShift is a multifaceted, container orchestration platform from Red Hat.
OpenShift Container Platform is a cloud-based Kubernetes container platform.
NERC offers a cloud development **Platform-as-a-Service (PaaS)** solution based
on Red Hat's OpenShift Container Platform that provides isolated, multi-tenant
containers for application development and deployment. This is optimized for
continuous containerized application development and multi-tenant deployment
which allows you and your team to focus on solving your research problems and
not infrastructure management.

## Basic Components and Glossary of common terms

OpenShift is a container orchestration platform that provides a number of components
and tools to help you build, deploy, and manage applications. Here are some of the
basic components of OpenShift:

### 1. Organization and Isolation

-   **Project**: A project is a logical grouping of resources in OpenShift. It
    provides isolation between teams, applications, and environments.

-   **Namespace**: A namespace is the underlying Kubernetes construct used to
    isolate resources within the cluster. In OpenShift, each project maps to a unique
    namespace.

-   **Role-Based Access Control (RBAC)**: A security mechanism that ensures users
    and workloads only have access to the resources required for their roles.

### 2. Infrastructure Layer

-   **Nodes**: Physical or virtual machines that run application workloads in the
    OpenShift cluster.

-   **Image**: A read-only template containing the application code, dependencies,
    and runtime configuration.

-   **Container**: A running instance of an image with added runtime components
    such as networking and process execution.

-   **Volume**: Persistent storage attached to containers and pods. It ensures
    data persists even when containers restart.

### 3. Application Deployment Model

#### Pods and Replica Management

-   **Pods**: The smallest deployable unit in OpenShift. A pod can contain one or
    more containers that share storage and network resources.

    !!! info "Understanding Pods and Their Configurations"

        More about Pods is [explained here](../applications/scaling-and-performance-guide.md#understanding-pod).

-   **ReplicaSets**: A Kubernetes resource that ensures a desired number of pod
    replicas are always running. It automatically creates or removes pods to match
    the desired state. ReplicaSets are typically managed by Deployments.

-   **Deployment**: A **Deployment** is a Kubernetes-native resource used in
    OpenShift to manage the lifecycle of applications in a declarative and automated
    way. It defines the desired state of an application, including the container
    image, number of replicas, and update strategy, and ensures that this state
    is continuously maintained. Deployments work by creating and managing **ReplicaSets**,
    which in turn handle the creation and scaling of Pods. When an application
    is updated, the Deployment performs a controlled rolling update by gradually
    replacing old Pods with new ones, helping maintain availability with minimal
    or no downtime. It also supports self-healing by automatically restarting
    failed Pods and allows easy rollback to previous versions if an update causes
    issues. Overall, Deployments provide a reliable, standardized, and
    production-ready approach for deploying and managing applications in OpenShift.

-   **Replicas**: Defines how many pod instances should run. Supports
    [horizontal scaling](../applications/scaling-and-performance-guide.md#creating-a-hpa-by-using-the-web-console).

### 4. Resource Management

**Resources**: Defines CPU and memory allocation for stable performance.

-   **Requests**: Minimum guaranteed CPU and memory allocated to a container.

-   **Limits**: Maximum CPU and memory a container can consume.

!!! warning "What happens if resources are not defined?"

    If you don't explicitly define CPU and memory requests/limits in your
    Pod YAML, OpenShift will automatically apply the default **LimitRange**
    configured for your project namespace. This prevents containers from
    consuming unbounded cluster resources.

    In practice, this means your workload will still run, but with predefined
    defaults that may not align with your application's actual needs. As
    a result, you could experience unexpected throttling, insufficient
    memory allocation, or inefficient scheduling.

    To ensure predictable performance and stability - especially for
    resource-intensive workloads like model inference - it's strongly
    recommended to explicitly define resource requests and limits in your
    configuration.

    More details on compute resource configurations can be found in the [scaling and performance guide](../applications/scaling-and-performance-guide.md#example-pod-configurations).

### 5. Health Monitoring

OpenShift uses **health check probes** to ensure deployments remain healthy and
reliable. These probes work together to improve application stability and reduce
downtime.

-   **Readiness Probe**: Ensures the application is ready before receiving traffic.

-   **Liveness Probe**: Checks whether the application is running and restarts it
    if it becomes unresponsive.

### 6. Networking and Access

Once your application is running, the next step is making it accessible. This is
done in two layers: an internal **Service** and an external **Route**.

#### Internal Access

-   **Service**: Provides a stable internal endpoint for accessing pods. It
    abstracts pod IP changes and enables load balancing across replicas.

### External Access

-   **Route**: Exposes services outside the cluster using a public URL via the
    OpenShift router.

    Routes:

    i. Provide DNS-based access

    ii. Support custom domains

    iii. Can use TLS encryption (Edge termination)

#### Application URL Format

When a **Route** is created, it is assigned a DNS name, making the application easily
accessible. Routes can also be configured with custom hostnames and TLS certificates.
For security, they often use **Edge TLS termination**, which encrypts traffic between
the client and the router while keeping backend communication simple. This approach
balances security with ease of configuration, making it ideal for quickly exposing
APIs and service endpoints.

When an application is added to a project, a unique **DNS** name is automatically
generated via the Route. This name follows a standard format with a hyphen
separating the application name and the project namespace. For web applications,
this DNS name also serves as the access URL.

All names follow the format: `<your-application-name>-<your-namespace>.apps.shift.nerc.mghpcc.org`.

For example: `mytestapp-mynamespace.apps.shift.nerc.mghpcc.org`.

## Deployment Definition

The following example demonstrates a complete OpenShift application setup, including
a **PersistentVolumeClaim (PVC)** for storage, a **Deployment** to run the application,
a **Service** for internal access, and a **Route** for external exposure.

In this deployment definition creates a replica set to bring up one `hello-openshift`
pod:

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: hello-openshift-pvc
  labels:
    app: hello-openshift
spec:
  accessModes:
    - ReadWriteOnce # (1)!
  resources:
    requests:
      storage: 1Gi # (2)!

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-openshift-deployment
  labels:
    app: hello-openshift
    app.kubernetes.io/part-of: hello-openshift # (3)!
spec:
  replicas: 1 # (4)!
  selector:
    matchLabels:
      app: hello-openshift
  template:
    metadata:
      labels:
        app: hello-openshift
    spec:
      volumes:
        - name: data
          persistentVolumeClaim:
            claimName: hello-openshift-pvc # (5)!
      containers:
      - name: hello-openshift
        image: openshift/hello-openshift:latest # (6)!
        imagePullPolicy: IfNotPresent
        ports:
          - name: http
            containerPort: 8080 # (7)!
            protocol: TCP
        volumeMounts:
          - name: data
            mountPath: /data # (8)!
        livenessProbe:
          httpGet:
            path: /
            port: http
            scheme: HTTP
          initialDelaySeconds: 10
          periodSeconds: 30 # (9)!
        readinessProbe:
          httpGet:
            path: /
            port: http
            scheme: HTTP
          initialDelaySeconds: 5
          periodSeconds: 20 # (10)!
        resources:
          limits:
            cpu: "500m"
            memory: "256Mi" # (11)!
          requests:
            cpu: "100m"
            memory: "128Mi" # (12)!
      restartPolicy: Always
  strategy:
    type: Recreate # (13)!

---
apiVersion: v1
kind: Service
metadata:
  name: hello-openshift-service
  labels:
    app: hello-openshift
spec:
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: http # (14)!
  selector:
    app: hello-openshift # (15)!
  type: ClusterIP

---
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: hello-openshift-route
  labels:
    app: hello-openshift
spec:
  port:
    targetPort: http
  tls:
    termination: edge # (16)!
    insecureEdgeTerminationPolicy: Redirect # (17)!
  to:
    kind: Service
    name: hello-openshift-service # (18)!
    weight: 100
```

1.  Defines the access mode for the PVC. `ReadWriteOnce` allows the volume to be
    mounted by a single node.

2.  Requests 1Gi of persistent storage from the cluster.

3.  Groups related resources under a common application label.

4.  Specifies the number of pod replicas to run.

5.  Connects the Deployment to the PVC for persistent storage.

6.  Uses the official `hello-openshift` container image.

7.  Exposes the application on port 8080 inside the container.

8.  Mounts the persistent storage inside the container at `/data`.

9.  Liveness probe checks if the container is still running and healthy.

10. Readiness probe ensures the app is ready before receiving traffic.

11. Maximum resources the container can use.

12. Minimum guaranteed resources for scheduling.

13. Uses `Recreate` strategy, meaning old pods are terminated before new ones start.

14. Maps external service port to the container port.

15. Ensures the Service routes traffic to the correct pods via labels.

16. Enables TLS at the router level (edge termination).

17. Redirects HTTP traffic to HTTPS for security.

18. Connects the Route to the internal Service.

---
