# OpenShift Overview

OpenShift is a multifaceted, container orcheastration platform from Red Hat.
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

- **Project**: A project is a logical grouping of resources in the NERC's OpenShift
platform that provides isolation from others resources.

- **Nodes**: Nodes are the physical or virtual machines that run the applications
and services in your OpenShift cluster.

- **Image**: An image is a non-changing, definition of file structures and programs
for running an application.

- **Container**: A container is an instance of an image with the addition of other
operating system components such as networking and running programs. Containers are
used to run applications and services in OpenShift.

- **Pods**: Pods are the smallest deployable units defined, deployed, and managed
in OpenShift, that group related one or more containers that need to share resources.

- **Services**: Services are logical representations of a set of pods that provide
a network endpoint for access to the application or service. Services can be used
to load balance traffic across multiple pods, and they can be accessed using a
stable DNS name. Services are assigned an IP address and port and proxy connections
to backend pods. This allows the pods to change while the connection details of the
service remain consistent.

- **Volume**: A volume is a persistent file space available to pods and containers
for storing data. Containers are immutable and therefore upon a restart any
contents are cleared and reset to the original state of the image used to create
the container. Volumes provide storage space for files that need to persist
through container restarts.

- **Routes**: Routes can be used to expose services to external clients to connections
outside the platform. A route is assigned a name in DNS when set up to make it easily
accessible. They can be configured with custom hostnames and TLS certificates.

- **Replication Controllers**: A replication controller (rc) is a built-in mechanism
that ensures a defined number of pods are running at all times. An asset that indicates
how many pod replicas are required to run at a time. If a pod unexpectedly quits
or is deleted, a new copy of the pod is created and started. Additionally, if more
pods are running than the defined number, the replication controller will delete
the extra pods to get down to the defined number.

- **Namespace**: A Namespace is a way to logically isolate resources within the Cluster.
In our case every project gets an unique namespace.

- **Role-based access control (RBAC)**: A key security control to ensure that cluster
users and workloads have only access to resources required to execute their roles.

- **Deployment Configurations**: A deployment configuration (dc) is an extension
of a replication controller that is used to push out a new version of application
code. Deployment configurations are used to define the process of deploying
applications and services to OpenShift. Deployment configurations
can be used to specify the number of replicas, the resources required by the
application, and the deployment strategy to use.

- **Application URL Components**: When an application developer adds an application
to a project, a unique DNS name is created for the application via a Route. All
application DNS names will have a hyphen separator between your application name
and your unique project namespace. If the application is a web application, this
DNS name is also used for the URL to access the application. All names are in
the form of `<appname>-<mynamespace>.apps.shift.nerc.mghpcc.org`.
For example: `mytestapp-mynamespace.apps.shift.nerc.mghpcc.org`.

---
