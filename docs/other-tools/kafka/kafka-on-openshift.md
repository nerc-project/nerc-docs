# Apache Kafka on NERC OpenShift

## Apache Kafka Overview

[Apache Kafka](https://kafka.apache.org/) is a distributed event streaming platform
capable of handling trillions of events per day. Originally developed at LinkedIn and
open-sourced in 2011, Kafka is designed for high-throughput, fault-tolerant, and
scalable real-time data pipelines and streaming applications.

Kafka uses a **publish-subscribe** model organized around the following core concepts:

- **Broker**: A Kafka server that stores and serves messages.
- **Topic**: A named stream to which producers publish records and from which consumers
  read records.
- **Partition**: Topics are split into partitions for parallelism and fault tolerance.
- **Producer**: A client application that publishes records to one or more topics.
- **Consumer**: A client application that subscribes to topics and processes records.
- **Consumer Group**: A group of consumers that collectively consume a topic, with each
  partition assigned to exactly one member.

Running Kafka on [NERC OpenShift](https://nerc-project.github.io/nerc-docs/openshift/)
is the recommended approach for course workloads requiring persistent, scalable message
streaming. This guide uses the **[Strimzi Operator](https://strimzi.io/)**, which is
the standard Kubernetes-native method for deploying Kafka on OpenShift.

## Prerequisites

Before proceeding, ensure you have:

- Access to a [NERC OpenShift project](https://nerc-project.github.io/nerc-docs/openshift/logging-in/access-the-openshift-web-console/)
- The `oc` CLI installed and authenticated to the NERC OpenShift cluster
- Sufficient quota in your project (at least 3 vCPUs and 6 GiB memory recommended
  for a minimal Kafka cluster)

!!! note "Checking Your Quota"

    You can view your project's resource quota by running:

    ```sh
    oc describe quota -n <your-project>
    ```

    If you need additional resources, contact your project PI or NERC support.

## Deploy Kafka Using the Strimzi Operator

Strimzi provides a Kubernetes Operator that manages the full lifecycle of Kafka
clusters on OpenShift. On NERC OpenShift, you will install Strimzi into your own
namespace.

### Install the Strimzi Operator

-   Log in to the NERC OpenShift cluster and switch to your project namespace:

    ```sh
    oc login <your-openshift-api-url>
    oc project <your-project>
    ```

    For example:

    ```sh
    oc login https://api.shift.nerc.mghpcc.org:6443
    oc project ds551-kafka
    ```

-   Download the Strimzi installation YAML files. Always check the
    [Strimzi releases page](https://github.com/strimzi/strimzi-kafka-operator/releases)
    for the latest version:

    ```sh
    STRIMZI_VERSION="0.45.0"
    wget https://github.com/strimzi/strimzi-kafka-operator/releases/download/${STRIMZI_VERSION}/strimzi-${STRIMZI_VERSION}.tar.gz
    tar -xzf strimzi-${STRIMZI_VERSION}.tar.gz
    cd strimzi-${STRIMZI_VERSION}
    ```

    !!! warning "Very Important Note"

        Check the [Strimzi compatibility matrix](https://strimzi.io/downloads/) to
        confirm the Strimzi version supports the Kafka version and Kubernetes/OpenShift
        version running on NERC. Mismatched versions can prevent the operator from
        starting.

-   Update the installation files to use your project namespace. Replace all
    occurrences of `myproject` with your actual namespace:

    ```sh
    sed -i 's/namespace: .*/namespace: <your-project>/' install/cluster-operator/*RoleBinding*.yaml
    ```

    For example:

    ```sh
    sed -i 's/namespace: .*/namespace: ds551-kafka/' install/cluster-operator/*RoleBinding*.yaml
    ```

-   Apply the Strimzi Cluster Operator installation files:

    ```sh
    oc apply -f install/cluster-operator/ -n <your-project>
    ```

-   Verify the operator pod is running:

    ```sh
    oc get pods -n <your-project> -l name=strimzi-cluster-operator
    ```

    The output should look similar to:

    ```
    NAME                                        READY   STATUS    RESTARTS   AGE
    strimzi-cluster-operator-7d96bf8c59-kfzwp   1/1     Running   0          45s
    ```

    !!! note "Note"

        It may take 1–2 minutes for the operator pod to reach `Running` status.

### Create a Kafka Cluster

Once the Strimzi Operator is running, you can deploy a Kafka cluster by creating
a `Kafka` custom resource.

-   Create a file named `kafka-cluster.yaml` with the following minimal cluster
    definition. This deploys a single-broker Kafka cluster with 3 ZooKeeper replicas
    and ephemeral (non-persistent) storage suitable for development and testing:

    ```yaml
    apiVersion: kafka.strimzi.io/v1beta2
    kind: Kafka
    metadata:
      name: my-cluster
      namespace: <your-project>
    spec:
      kafka:
        version: 3.8.0
        replicas: 1
        listeners:
          - name: plain
            port: 9092
            type: internal
            tls: false
          - name: tls
            port: 9093
            type: internal
            tls: true
        config:
          offsets.topic.replication.factor: 1
          transaction.state.log.replication.factor: 1
          transaction.state.log.min.isr: 1
          default.replication.factor: 1
          min.insync.replicas: 1
        storage:
          type: ephemeral
      zookeeper:
        replicas: 3
        storage:
          type: ephemeral
      entityOperator:
        topicOperator: {}
        userOperator: {}
    ```

    !!! warning "Very Important Note"

        This configuration uses `ephemeral` storage, meaning all Kafka data will
        be lost if pods restart. For persistent storage across pod restarts, change
        the `storage` type to `persistent-claim` and specify a `size` and
        `storageClass`. See the
        [Strimzi storage documentation](https://strimzi.io/docs/operators/latest/full/deploying.html#type-EphemeralStorage-reference)
        for details.

-   Apply the Kafka cluster definition:

    ```sh
    oc apply -f kafka-cluster.yaml -n <your-project>
    ```

-   Watch the cluster come up. It may take 3–5 minutes for all pods to reach
    `Running` status:

    ```sh
    oc get pods -n <your-project> -l strimzi.io/cluster=my-cluster -w
    ```

    A healthy cluster will show output similar to:

    ```
    NAME                                          READY   STATUS    RESTARTS   AGE
    my-cluster-entity-operator-6d7f9c7d4b-xqtlp   2/2     Running   0          2m
    my-cluster-kafka-0                             1/1     Running   0          3m
    my-cluster-zookeeper-0                         1/1     Running   0          4m
    my-cluster-zookeeper-1                         1/1     Running   0          4m
    my-cluster-zookeeper-2                         1/1     Running   0          4m
    ```

### Create a Kafka Topic

-   Create a file named `kafka-topic.yaml`:

    ```yaml
    apiVersion: kafka.strimzi.io/v1beta2
    kind: KafkaTopic
    metadata:
      name: my-topic
      namespace: <your-project>
      labels:
        strimzi.io/cluster: my-cluster
    spec:
      partitions: 3
      replicas: 1
      config:
        retention.ms: 7200000
        segment.bytes: 1073741824
    ```

-   Apply the topic:

    ```sh
    oc apply -f kafka-topic.yaml -n <your-project>
    ```

-   Verify the topic was created:

    ```sh
    oc get kafkatopic my-topic -n <your-project>
    ```

    Expected output:

    ```
    NAME       CLUSTER      PARTITIONS   REPLICATION FACTOR   READY
    my-topic   my-cluster   3            1                    True
    ```

## Test the Kafka Cluster

Strimzi ships with example producer and consumer jobs you can use to verify your
cluster is working correctly.

### Run a Producer

-   Start a producer pod that sends 100 messages to `my-topic`:

    ```sh
    oc run kafka-producer -ti \
      --image=quay.io/strimzi/kafka:0.45.0-kafka-3.8.0 \
      --rm=true --restart=Never \
      -- bin/kafka-console-producer.sh \
      --bootstrap-server my-cluster-kafka-bootstrap:9092 \
      --topic my-topic
    ```

-   Type a few test messages at the prompt and press `Enter` after each:

    ```
    > Hello from NERC OpenShift!
    > This is a Kafka test message.
    ```

    Press `Ctrl+C` to stop the producer.

### Run a Consumer

-   In a separate terminal, start a consumer pod to read messages from the beginning:

    ```sh
    oc run kafka-consumer -ti \
      --image=quay.io/strimzi/kafka:0.45.0-kafka-3.8.0 \
      --rm=true --restart=Never \
      -- bin/kafka-console-consumer.sh \
      --bootstrap-server my-cluster-kafka-bootstrap:9092 \
      --topic my-topic \
      --from-beginning
    ```

    You should see the messages published by the producer:

    ```
    Hello from NERC OpenShift!
    This is a Kafka test message.
    ```

    Press `Ctrl+C` to stop the consumer.

    !!! tip "Consumer Groups"

        To simulate multiple consumers sharing a topic workload, add the flag
        `--group <group-name>` to the consumer command. Each consumer in the same
        group will receive messages from a distinct subset of partitions.

## Connecting Applications to Kafka

Applications running inside the same OpenShift project can reach the Kafka broker
using the internal bootstrap address:

```
my-cluster-kafka-bootstrap:9092   # plaintext (no TLS)
my-cluster-kafka-bootstrap:9093   # TLS
```

For Python applications, use the [kafka-python](https://kafka-python.readthedocs.io/)
or [confluent-kafka](https://docs.confluent.io/kafka-clients/python/current/overview.html)
client libraries:

```python
from kafka import KafkaProducer, KafkaConsumer

# Producer example
producer = KafkaProducer(bootstrap_servers='my-cluster-kafka-bootstrap:9092')
producer.send('my-topic', b'Hello from Python!')
producer.flush()

# Consumer example
consumer = KafkaConsumer(
    'my-topic',
    bootstrap_servers='my-cluster-kafka-bootstrap:9092',
    auto_offset_reset='earliest',
    group_id='my-group'
)
for msg in consumer:
    print(f"Received: {msg.value.decode()}")
```

!!! note "Note"

    The bootstrap address `my-cluster-kafka-bootstrap` is an OpenShift Service
    created automatically by Strimzi. It is only reachable from within the same
    project namespace. If you need external access, configure a `route` or
    `loadbalancer` type listener in the Kafka CR.

## Clean Up Resources

When you are finished, remove all Kafka resources to free up project quota:

```sh
# Delete the Kafka topic
oc delete kafkatopic my-topic -n <your-project>

# Delete the Kafka cluster (also removes ZooKeeper and Entity Operator pods)
oc delete kafka my-cluster -n <your-project>

# Remove the Strimzi Operator
oc delete -f install/cluster-operator/ -n <your-project>
```

!!! danger "Very Important Note"

    Deleting the Kafka cluster with ephemeral storage permanently destroys all
    messages stored in that cluster. Make sure you have consumed or exported any
    data you need before running these commands.