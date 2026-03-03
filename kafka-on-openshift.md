# Apache Kafka on NERC OpenShift

## Apache Kafka Overview

[Apache Kafka](https://kafka.apache.org/) is a distributed event streaming platform
capable of handling trillions of events per day. Originally developed at LinkedIn
and open-sourced in 2011, Kafka is designed for high-throughput, fault-tolerant,
and scalable real-time data pipelines and streaming applications.

Kafka uses a **publish-subscribe** model organized around the following core concepts:

- **Broker**: A Kafka server that stores and serves messages.
- **Topic**: A named stream to which producers publish records and from which
  consumers read records.
- **Partition**: Topics are split into partitions for parallelism and fault tolerance.
- **Producer**: A client application that publishes records to one or more topics.
- **Consumer**: A client application that subscribes to topics and processes records.
- **Consumer Group**: A group of consumers that collectively consume a topic, with
  each partition assigned to exactly one member.

Running Kafka on [NERC OpenShift](https://nerc-project.github.io/nerc-docs/openshift/)
is accomplished using the **[Strimzi Operator](https://strimzi.io/)**,
which is the standard Kubernetes-native method for deploying Kafka on OpenShift.

## Prerequisites

For this guide, you will need:

- Access to a NERC OpenShift project with Kafka already deployed
  (provided by your instructor)
- The bootstrap server address and CA certificate credentials
  (provided by your instructor)
- Your `TEAM_ID` (for authentication to the Kafka broker)
- The `oc` CLI installed (optional, only if you want to inspect the cluster status)

!!! note "Kafka Infrastructure is Pre-Deployed"

    The Strimzi Operator and Kafka cluster have already been deployed by your instructor
    or course staff. You do **not** need to install the operator or create a Kafka cluster
    yourself. You only need to connect to the shared Kafka broker using the provided
    credentials.

## Test the Kafka Cluster

Strimzi ships with pre-built container images with Kafka command-line tools that
you can use to verify your cluster is working correctly.

!!! note "API Deprecation Warnings"

    You may see deprecation warnings about Kafka API versions during deployment and testing.
    These are safe to ignore. The deprecation warnings occur because the v1beta2 API version
    is being phased out in favor of v1. Your cluster will still function correctly.

### Run a Producer

The producer tool lets you send messages to a Kafka topic. In interactive mode,
you can type messages directly:

-   Start a producer pod in interactive mode:

    ```sh
    oc run kafka-producer -ti \
      --image=quay.io/strimzi/kafka:0.50.1-kafka-4.1.1 \
      --rm=true --restart=Never \
      -n <your-project> \
      -- bash -c 'bin/kafka-console-producer.sh \
        --bootstrap-server my-cluster-kafka-bootstrap:9092 \
        --topic my-topic'
    ```

    The `-ti` flags enable **interactive terminal mode**, which allows you to type
    messages at a prompt. The `--rm=true` flag automatically removes the pod after
    it exits.

-   At the prompt, type test messages and press `Enter` after each one:

    ```text
    > Hello from NERC OpenShift!
    > This is a Kafka test message.
    ```

    Press `Ctrl+C` to stop the producer and exit.

    !!! warning "Important: Interactive Mode (`-ti --rm`)"

        The `-ti --rm` flags work together to create an interactive session that
        automatically cleans up the pod. Do not use these flags in scripts or
        CI/CD pipelines—instead,
        pipe your messages to stdin or use a heredoc. For example:

        ```sh
        echo -e "message1\nmessage2" | oc run kafka-producer \
          --image=quay.io/strimzi/kafka:0.50.1-kafka-4.1.1 \
          --restart=Never \
          -n <your-project> \
          -i \
          -- bin/kafka-console-producer.sh \
            --bootstrap-server my-cluster-kafka-bootstrap:9092 \
            --topic my-topic
        ```

### Run a Consumer

-   In a separate terminal, start a consumer pod to read messages from the beginning:

    ```sh
    oc run kafka-consumer -ti \
      --image=quay.io/strimzi/kafka:0.50.1-kafka-4.1.1 \
      --rm=true --restart=Never \
      -n <your-project> \
      -- bash -c 'bin/kafka-console-consumer.sh \
        --bootstrap-server my-cluster-kafka-bootstrap:9092 \
        --topic my-topic \
        --from-beginning'
    ```

    You should see the messages published by the producer:

    ```text
    Hello from NERC OpenShift!
    This is a Kafka test message.
    ```

    Press `Ctrl+C` to stop the consumer.

    !!! tip "Consumer Groups"

        To test multiple consumers sharing a topic workload, add the flag
        `--group <group-name>` to the consumer command. Each consumer in the same
        group will receive messages from a distinct subset of partitions.

## Connecting Applications to Kafka

Applications running inside the same OpenShift project can reach the Kafka broker
using the internal bootstrap address:

```text
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

---
