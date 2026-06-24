# Using Tekton Pipelines on NERC OpenShift

**Contributed by:** DS-551 Data Engineering at Scale, Boston University  
**Tested on:** NERC OpenShift, Spring 2026  

---

## Overview

This page documents how to install and use [Tekton Pipelines](https://tekton.dev) on NERC OpenShift, using the DS-551 course infrastructure as a working reference deployment. In Spring 2026, 12 student teams each built a multi-phase data pipeline on NERC using Tekton as their orchestration engine, running concurrently in isolated namespaces on shared cluster infrastructure.

The pipeline each team built:

```
Kafka (raw events)
  → Tekton Task: validate-events   (schema check, discard invalids)
  → Tekton Task: route-and-enrich  (type routing, metadata enrichment)
  → Kafka (typed topics: hospital_admissions, clinic_visits, ...)
  → Spark analytics job
  → Database (PostgreSQL / TimescaleDB / InfluxDB / ClickHouse / MySQL)
  → Phase 3 features (alerting, ML, dashboards)
```

---

## Prerequisites

- Access to a NERC OpenShift project (namespace)
- `oc` CLI installed and logged in
- Cluster-admin or operator-install permissions for the Tekton operator (one-time, done by NERC staff or PI)

---

## Step 1: Install the Tekton Operator

Tekton is installed cluster-wide via OperatorHub. If it is already installed on your NERC cluster, skip this step.

```yaml
# operator-subscription.yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: tekton-pipelines-operator
  namespace: openshift-operators
spec:
  channel: latest
  installPlanApproval: Automatic
  name: tektoncd-operator
  source: community-operators
  sourceNamespace: openshift-marketplace
```

```bash
oc apply -f operator-subscription.yaml
# Verify the operator is running
oc get pods -n tekton-pipelines
```

Once installed, all namespaces on the cluster can create `Task`, `Pipeline`, and `PipelineRun` resources without any additional setup.

---

## Step 2: Create a ServiceAccount with RBAC

Each team (or project) needs a ServiceAccount that Tekton uses to run tasks. The example below scopes permissions to what a typical data pipeline task needs: reading Secrets, creating Pods, and managing ConfigMaps.

```yaml
# serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pipeline-sa
  namespace: my-namespace
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pipeline-role
  namespace: my-namespace
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log", "secrets", "configmaps"]
    verbs: ["get", "list", "watch", "create", "delete"]
  - apiGroups: ["tekton.dev"]
    resources: ["taskruns", "pipelineruns"]
    verbs: ["get", "list", "watch", "create", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pipeline-rolebinding
  namespace: my-namespace
subjects:
  - kind: ServiceAccount
    name: pipeline-sa
    namespace: my-namespace
roleRef:
  kind: Role
  name: pipeline-role
  apiGroup: rbac.authorization.k8s.io
```

```bash
oc apply -f serviceaccount.yaml
```

---

## Step 3: Define Tasks

A `Task` is a single unit of work — a script that runs inside a container. In the DS-551 pipeline, each task reads from a Kafka topic, processes events, and publishes results to another topic.

```yaml
# task-validate.yaml
apiVersion: tekton.dev/v1
kind: Task
metadata:
  name: validate-events
  namespace: my-namespace
spec:
  params:
    - name: kafka-bootstrap
      type: string
    - name: input-topic
      type: string
    - name: output-topic
      type: string
  steps:
    - name: validate
      image: python:3.11-slim
      script: |
        #!/usr/bin/env sh
        pip install kafka-python-ng --target=/tmp/pkgs --quiet
        PYTHONPATH=/tmp/pkgs python3 - <<'PYEOF'
        import sys; sys.path.insert(0, '/tmp/pkgs')
        from kafka import KafkaConsumer, KafkaProducer
        import json, logging

        logging.basicConfig(level=logging.INFO)

        consumer = KafkaConsumer(
            '$(params.input-topic)',
            bootstrap_servers='$(params.kafka-bootstrap)',
            group_id='my-pipeline-consumer',
            auto_offset_reset='earliest',
            value_deserializer=lambda m: json.loads(m.decode('utf-8'))
        )
        producer = KafkaProducer(
            bootstrap_servers='$(params.kafka-bootstrap)',
            value_serializer=lambda m: json.dumps(m).encode('utf-8')
        )

        for msg in consumer:
            event = msg.value
            if all(k in event for k in ['id', 'timestamp', 'type']):
                producer.send('$(params.output-topic)', event)
            else:
                logging.warning(f"Invalid event discarded: {event}")

        producer.flush()
        PYEOF
```

```bash
oc apply -f task-validate.yaml
```

---

## Step 4: Define a Pipeline

A `Pipeline` chains tasks together using `runAfter` to express dependencies. Parameters flow from the PipelineRun down into each task.

```yaml
# pipeline.yaml
apiVersion: tekton.dev/v1
kind: Pipeline
metadata:
  name: data-pipeline
  namespace: my-namespace
spec:
  params:
    - name: kafka-bootstrap
    - name: raw-topic
    - name: valid-topic
  tasks:
    - name: validate
      taskRef:
        name: validate-events
      params:
        - name: kafka-bootstrap
          value: $(params.kafka-bootstrap)
        - name: input-topic
          value: $(params.raw-topic)
        - name: output-topic
          value: $(params.valid-topic)
    - name: enrich
      taskRef:
        name: route-and-enrich
      runAfter:
        - validate
      params:
        - name: kafka-bootstrap
          value: $(params.kafka-bootstrap)
        - name: input-topic
          value: $(params.valid-topic)
```

```bash
oc apply -f pipeline.yaml
```

---

## Step 5: Run the Pipeline

A `PipelineRun` is a concrete execution of a pipeline with specific parameter values. You can trigger it manually or via a CronJob.

```yaml
# pipelinerun.yaml
apiVersion: tekton.dev/v1
kind: PipelineRun
metadata:
  name: data-pipeline-run-001
  namespace: my-namespace
spec:
  pipelineRef:
    name: data-pipeline
  taskRunSpecs:
    - pipelineTaskName: validate
      serviceAccountName: pipeline-sa
  params:
    - name: kafka-bootstrap
      value: kafka.my-namespace.svc.cluster.local:9092
    - name: raw-topic
      value: my-project.raw
    - name: valid-topic
      value: my-project.valid
```

```bash
oc apply -f pipelinerun.yaml

# Watch execution
oc get pipelineruns -n my-namespace -w

# View logs from a specific task step
oc logs -f <taskrun-pod-name> -n my-namespace
```

---

## Step 6: Schedule Recurring Runs (Optional)

In DS-551, student pipelines ran on a schedule using a Kubernetes CronJob that applied a new PipelineRun manifest on each tick.

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: pipeline-scheduler
  namespace: my-namespace
spec:
  schedule: "0 */6 * * *"   # every 6 hours
  jobTemplate:
    spec:
      template:
        spec:
          serviceAccountName: pipeline-sa
          containers:
            - name: trigger
              image: bitnami/kubectl:latest
              command:
                - /bin/sh
                - -c
                - |
                  kubectl apply -f - <<EOF
                  apiVersion: tekton.dev/v1
                  kind: PipelineRun
                  metadata:
                    generateName: data-pipeline-run-
                    namespace: my-namespace
                  spec:
                    pipelineRef:
                      name: data-pipeline
                    params:
                      - name: kafka-bootstrap
                        value: kafka.my-namespace.svc.cluster.local:9092
                      - name: raw-topic
                        value: my-project.raw
                      - name: valid-topic
                        value: my-project.valid
                  EOF
          restartPolicy: OnFailure
```

---

## Observing Pipeline Runs

```bash
# List all pipeline runs
oc get pipelineruns -n my-namespace

# Describe a run to see task status
oc describe pipelinerun data-pipeline-run-001 -n my-namespace

# Get logs from a failed task
oc get taskruns -n my-namespace
oc logs <taskrun-pod> -n my-namespace

# Optional: forward Tekton dashboard locally
oc port-forward -n tekton-pipelines svc/tekton-dashboard 9097:9097
# Open http://localhost:9097
```

---

## Lessons Learned on NERC (Spring 2026)

These are practical notes from running 12 concurrent student pipelines on NERC OpenShift for a full semester.

**What worked well**
- The Tekton operator installed cleanly cluster-wide; teams had zero operator-level setup to do in their own namespaces
- Isolating each team in their own namespace meant a broken pipeline in one team had no blast radius on others
- Passing Kafka bootstrap servers and topic names as Pipeline params (not hardcoded in Tasks) made the same Task reusable across all 12 teams
- CronJob-triggered PipelineRuns worked reliably for batch analytics that needed to run every 6 hours

**Watch out for**
- **ServiceAccount scope:** Tasks run as the ServiceAccount specified in the PipelineRun — if the SA lacks permissions to read a Secret or create a Pod, the task fails silently or with a confusing RBAC error. Define the Role carefully upfront.
- **Consumer group collisions:** If two PipelineRuns share the same Kafka consumer group ID, the second run will compete for offsets with the first. Use `generateName` on PipelineRuns and include a run ID in the consumer group name if you need concurrent runs.
- **Image pull time:** Tasks using `python:3.11-slim` and installing packages at runtime (via `pip install`) add 30–60 seconds of cold start per run. For production-frequency pipelines, bake dependencies into a custom image.
- **Task timeouts:** The default Tekton task timeout is 1 hour. Long-running Spark jobs or large Kafka backlogs can exceed this. Set `timeout` explicitly in the Pipeline spec.
- **PipelineRun accumulation:** Old PipelineRun objects are not garbage collected automatically. Add a cleanup CronJob or set `ttlSecondsAfterCompletion` to avoid namespace clutter.

---

## Reference Architecture (DS-551 Spring 2026)

```
NERC OpenShift Cluster
├── ds551-2026-spring-9ab13b      ← shared infrastructure namespace
│   ├── Kafka (Strimzi, per-team brokers)
│   └── Event Generator (Deployment — emits synthetic health events)
│
├── ds551-2026-spring-<team-hash> ← one namespace per student team (×12)
│   ├── ServiceAccount + RBAC
│   ├── Tekton Tasks (validate-events, route-and-enrich)
│   ├── Pipeline (validate → enrich)
│   ├── CronJob (triggers PipelineRun every 6h)
│   ├── Spark analytics CronJob
│   ├── Database (PostgreSQL / TimescaleDB / InfluxDB / MySQL / ClickHouse)
│   └── Phase 3 services (alerting, ML CronJobs, dashboards)
```

12 teams ran this architecture concurrently on NERC for the full Spring 2026 semester, processing a continuous stream of synthetic epidemiological events end-to-end from Kafka through Tekton into persistent storage and Phase 3 ML features.

---

## Further Reading

- [Tekton Pipelines documentation](https://tekton.dev/docs/pipelines/)
- [Strimzi Kafka Operator on OpenShift](https://strimzi.io/docs/operators/latest/overview.html)
- [NERC OpenShift documentation](https://nerc-project.github.io/nerc-docs/)
- DS-551 course repository: `github.com/langd0n-classes/data-eng-at-scale`
