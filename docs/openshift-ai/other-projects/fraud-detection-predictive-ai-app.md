# Credit Card Fraud Detection Application

Here you will use an example fraud detection model to complete the following tasks:

-   Train your own fraud detection model.

-   Explore a pre-trained fraud detection model by using a Jupyter notebook.

-   Deploy the model by using OpenShift AI model serving.

-   Refine and train the model by using automated pipelines.

-   Deploy the "Credit Card Fraud Detection" application on NERC OpenShift, which
connects to the deployed model.

## About the example fraud detection model

The example fraud detection model monitors credit card transactions for potential
fraudulent activity by analyzing the following details:

-   **Distance** from the cardholder's home and previous transaction.

-   **Purchase amount**, compared to the user's median transaction price.

-   **Retailer history**, indicating whether the merchant has been used before.

-   **Authentication method**, such as PIN usage.

-   **Transaction type**, distinguishing between online and in-person purchases.

Based on the above mentioned factors, the model determines the likelihood of a
transaction being fraudulent.

## Navigating to the OpenShift AI dashboard

Please follow [these steps](../logging-in/access-the-rhoai-dashboard.md) to access
the NERC OpenShift AI dashboard.

## Setting up your Data Science Project in the NERC RHOAI

**Prerequisites**:

-   Before proceeding, confirm that you have an active GPU quota that has been approved
    for your current NERC OpenShift Allocation through NERC ColdFront. Read
    more about [How to Access GPU Resources](../../openshift/gpus/intro-to-gpus-on-nerc-ocp.md#accessing-gpu-resources)
    on NERC OpenShift Allocation.

### 1. Storing data with connections

For this tutorial, you will need **two S3-compatible object storage buckets**,
such as **NERC OpenStack Container (Ceph)**, **MinIO**, or **AWS S3**. You can
either use your own storage buckets or run a provided script that automatically
creates the following **local S3 storage (MinIO) buckets**:

-   **my-storage** – Use this bucket to store your models and data. You can reuse
this bucket and its connection for notebooks and model servers.

-   **pipeline-artifacts** – Use this bucket to store pipeline artifacts. A pipeline
    artifacts bucket is required when setting up a pipeline server. For clarity,
    this tutorial keeps it separate from the first storage bucket, as it is considered
    best practice to use dedicated storage buckets for different purposes.

You must also create a connection to each storage bucket. For this tutorial, you
have two options depending on whether you want to use your own storage buckets
or a script to create local S3 storage (MinIO) buckets:

#### 1.1. **Using your own S3-compatible storage buckets**

**Procedure**:

Manually create two connections: **My Storage** and **Pipeline Artifacts**
by following [How to create a connection](../data-science-project/model-serving-in-the-rhoai.md#create-a-connection).

**Verification**:

You should see two connections listed under your RHOAI Dashboard **My Storage**
and **Pipeline Artifacts** as shown below:

![Connections](images/data-connections.png)

#### 1.2. **Using a script to set up local S3 storage (MinIO)**

Alternatively, if you want to run a script that automates the setup by completing
the following tasks:

-   **Deploys a MinIO instance** in your project namespace.

-   **Creates two storage buckets** within the MinIO instance.

-   **Generates a random user ID and password** for the MinIO Console.

-   **Establishes two connections** in your project - one for each bucket -
    using the same generated credentials.

-   Installs all required **network policies**.

**Procedure**:

i. From the OpenShift AI dashboard, you can return to OpenShift Web Console
by using the application launcher icon (the black-and-white icon that looks
like a grid), and choosing the "OpenShift Console" as shown below:

![The NERC OpenShift Web Console Link](images/the-nerc-openshift-web-console-link.png)

ii. From your [NERC's OpenShift Web Console](https://console.apps.shift.nerc.mghpcc.org/),
navigate to your project corresponding to the _NERC RHOAI Data Science Project_
and select the "Import YAML" button, represented by the "+" icon in the top
navigation bar as shown below:

![YAML Add Icon](images/yaml-upload-plus-icon.png)

iii. Verify that you selected the correct project.

![Correct Project Selected for YAML Editor](images/project-verify-yaml-editor.png)

iv. Copy the following code and paste it into the Import YAML editor.

??? note "Local S3 storage (MinIO) Creation YAML Script"

    ```yaml
    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: minio-setup
      labels:
        app: minio
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: minio-setup-edit
      labels:
        app: minio
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: edit
    subjects:
    - kind: ServiceAccount
      name: minio-setup
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: minio-pvc
      labels:
        app: minio
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 10Gi # Adjust the size according to your needs
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: minio-deployment
      labels:
        app: minio
        app.kubernetes.io/part-of: minio
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: minio
      strategy:
        type: Recreate
      template:
        metadata:
          labels:
            app: minio
        spec:
          containers:
          - args:
            - minio server /data --console-address :9090
            command:
            - /bin/bash
            - -c
            envFrom:
            - secretRef:
                name: minio-root-user
            image: quay.io/minio/minio:latest
            name: minio
            ports:
            - containerPort: 9000
              name: api
              protocol: TCP
            - containerPort: 9090
              name: console
              protocol: TCP
            resources:
              limits:
                cpu: "2"
                memory: 2Gi
              requests:
                cpu: 200m
                memory: 1Gi
            volumeMounts:
            - mountPath: /data
              name: minio-volume
          volumes:
          - name: minio-volume
            persistentVolumeClaim:
              claimName: minio-pvc
          - emptyDir: {}
            name: empty
    ---
    apiVersion: batch/v1
    kind: Job
    metadata:
      name: create-ds-connections
      labels:
        app: minio
        app.kubernetes.io/part-of: minio
    spec:
      selector: {}
      template:
        spec:
          containers:
          - args:
            - -ec
            - |-
              echo -n 'Waiting for minio route'
              while ! oc get route minio-s3 2>/dev/null | grep -qF minio-s3; do
                echo -n .
                sleep 5
              done; echo

              echo -n 'Waiting for minio root user secret'
              while ! oc get secret minio-root-user 2>/dev/null | grep -qF minio-root-user; do
                echo -n .
                sleep 5
              done; echo

              MINIO_ROOT_USER=$(oc get secret minio-root-user -o template --template '{{.data.MINIO_ROOT_USER}}')
              MINIO_ROOT_PASSWORD=$(oc get secret minio-root-user -o template --template '{{.data.MINIO_ROOT_PASSWORD}}')
              MINIO_HOST=https://$(oc get route minio-s3 -o template --template '{{.spec.host}}')

              cat << EOF | oc apply -f-
              apiVersion: v1
              kind: Secret
              metadata:
                annotations:
                  opendatahub.io/connection-type: s3
                  openshift.io/display-name: My Storage
                labels:
                  opendatahub.io/dashboard: "true"
                  opendatahub.io/managed: "true"
                name: aws-connection-my-storage
              data:
                AWS_ACCESS_KEY_ID: ${MINIO_ROOT_USER}
                AWS_SECRET_ACCESS_KEY: ${MINIO_ROOT_PASSWORD}
              stringData:
                AWS_DEFAULT_REGION: us-east-1
                AWS_S3_BUCKET: my-storage
                AWS_S3_ENDPOINT: ${MINIO_HOST}
              type: Opaque
              EOF
              cat << EOF | oc apply -f-
              apiVersion: v1
              kind: Secret
              metadata:
                annotations:
                  opendatahub.io/connection-type: s3
                  openshift.io/display-name: Pipeline Artifacts
                labels:
                  opendatahub.io/dashboard: "true"
                  opendatahub.io/managed: "true"
                name: aws-connection-pipeline-artifacts
              data:
                AWS_ACCESS_KEY_ID: ${MINIO_ROOT_USER}
                AWS_SECRET_ACCESS_KEY: ${MINIO_ROOT_PASSWORD}
              stringData:
                AWS_DEFAULT_REGION: us-east-1
                AWS_S3_BUCKET: pipeline-artifacts
                AWS_S3_ENDPOINT: ${MINIO_HOST}
              type: Opaque
              EOF
            command:
            - /bin/bash
            image: image-registry.openshift-image-registry.svc:5000/openshift/tools:latest
            imagePullPolicy: IfNotPresent
            name: create-ds-connections
          restartPolicy: Never
          serviceAccount: minio-setup
          serviceAccountName: minio-setup
    ---
    apiVersion: batch/v1
    kind: Job
    metadata:
      name: create-minio-buckets
      labels:
        app: minio
        app.kubernetes.io/part-of: minio
    spec:
      selector: {}
      template:
        metadata:
          labels:
            app: minio
        spec:
          containers:
          - args:
            - -ec
            - |-
              oc get secret minio-root-user
              env | grep MINIO
              cat << 'EOF' | python3
              import boto3, os

              s3 = boto3.client("s3",
                                endpoint_url="http://minio-service:9000",
                                aws_access_key_id=os.getenv("MINIO_ROOT_USER"),
                                aws_secret_access_key=os.getenv("MINIO_ROOT_PASSWORD"))
              bucket = 'pipeline-artifacts'
              print('creating pipeline-artifacts bucket')
              if bucket not in [bu["Name"] for bu in s3.list_buckets()["Buckets"]]:
                s3.create_bucket(Bucket=bucket)
              bucket = 'my-storage'
              print('creating my-storage bucket')
              if bucket not in [bu["Name"] for bu in s3.list_buckets()["Buckets"]]:
                s3.create_bucket(Bucket=bucket)
              EOF
            command:
            - /bin/bash
            envFrom:
            - secretRef:
                name: minio-root-user
            image: image-registry.openshift-image-registry.svc:5000/redhat-ods-applications/s2i-generic-data-science-notebook:2023.2
            imagePullPolicy: IfNotPresent
            name: create-buckets
          initContainers:
          - args:
            - -ec
            - |-
              echo -n 'Waiting for minio root user secret'
              while ! oc get secret minio-root-user 2>/dev/null | grep -qF minio-root-user; do
              echo -n .
              sleep 5
              done; echo

              echo -n 'Waiting for minio deployment'
              while ! oc get deployment minio-deployment 2>/dev/null | grep -qF minio-deployment; do
                echo -n .
                sleep 5
              done; echo
              oc wait --for=condition=available --timeout=60s deployment/minio-deployment
              sleep 10
            command:
            - /bin/bash
            image: image-registry.openshift-image-registry.svc:5000/openshift/tools:latest
            imagePullPolicy: IfNotPresent
            name: wait-for-minio
          restartPolicy: Never
          serviceAccount: minio-setup
          serviceAccountName: minio-setup
    ---
    apiVersion: batch/v1
    kind: Job
    metadata:
      name: create-minio-root-user
      labels:
        app: minio
        app.kubernetes.io/part-of: minio
    spec:
      backoffLimit: 4
      template:
        metadata:
          labels:
            app: minio
        spec:
          containers:
          - args:
            - -ec
            - |-
              if [ -n "$(oc get secret minio-root-user -oname 2>/dev/null)" ]; then
                echo "Secret already exists. Skipping." >&2
                exit 0
              fi
              genpass() {
                  < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c"${1:-32}"
              }
              id=$(genpass 16)
              secret=$(genpass)
              cat << EOF | oc apply -f-
              apiVersion: v1
              kind: Secret
              metadata:
                name: minio-root-user
              type: Opaque
              stringData:
                MINIO_ROOT_USER: ${id}
                MINIO_ROOT_PASSWORD: ${secret}
              EOF
            command:
            - /bin/bash
            image: image-registry.openshift-image-registry.svc:5000/openshift/tools:latest
            imagePullPolicy: IfNotPresent
            name: create-minio-root-user
          restartPolicy: Never
          serviceAccount: minio-setup
          serviceAccountName: minio-setup
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: minio-service
      labels:
        app: minio
    spec:
      ports:
      - name: api
        port: 9000
        targetPort: api
      - name: console
        port: 9090
        targetPort: 9090
      selector:
        app: minio
      sessionAffinity: None
      type: ClusterIP
    ---
    apiVersion: route.openshift.io/v1
    kind: Route
    metadata:
      name: minio-console
      labels:
        app: minio
    spec:
      port:
        targetPort: console
      tls:
        insecureEdgeTerminationPolicy: Redirect
        termination: edge
      to:
        kind: Service
        name: minio-service
        weight: 100
      wildcardPolicy: None
    ---
    apiVersion: route.openshift.io/v1
    kind: Route
    metadata:
      name: minio-s3
      labels:
        app: minio
    spec:
      port:
        targetPort: api
      tls:
        insecureEdgeTerminationPolicy: Redirect
        termination: edge
      to:
        kind: Service
        name: minio-service
        weight: 100
      wildcardPolicy: None
    ```

!!! warning "Very Important Note"

    In this YAML file, the size of the storage is set as 10Gi. Change it if
    you need to.

v. Click **Create**.

**Verification**:

i. Once Resource is successfully created, you will see a "Resources successfully
created" message and the following resources listed:

![Resources successfully created Importing More YAML](images/yaml-import-success.png)

ii. Once the deployment is successful, you will be able to see all resources
are created and grouped under "minio" application grouping on the
**Topology View** menu, as shown below:

![MinIO Under Topology](images/minio-topology.png)

Once successfully initiated, click on the **minio** deployment and select the
"Resources" tab to review created *Pods*, *Services*, and *Routes*.

![MinIO Deployemnt Resources](images/minio-deployment-resources.png)

Please note the **minio-console** route URL by navigating to the "Routes" section
under the _Location_ path. When you click on the **minio-console** route URL, it
will open the MinIO web console that looks like below:

![MinIO Web Console](images/minio-web-console.png)

!!! info "MinIO Web Console Login Credential"

    The Username and Password for the MinIO web console can be retrieved from
    the Connection's **Access key** and **Secret key**.

iii. Navigate back to the OpenShift AI dashboard.

a. Select Data Science Projects and then click the name of your project, i.e.
**Fraud detection**.

b. Click **Connections**. You should see two connections listed:
*My Storage* and *Pipeline Artifacts* as shown below:

![Connections](images/data-connections.png)

c. Verify the buckets are created on the MinIO Web Console:

-   Click on any connection from the list that was created and then click
the action menu (⋮) at the end of the selected connection row. Choose
"Edit connection" from the dropdown menu. This will open a pop-up
 window as shown below:

    ![Edit Connection Pop up](images/edit-data-connection.png)

-   Note both  *Access key* (by clicking eye icon near the end of the textbox) and
*Secret key*.

    !!! note "Alternatively, Run `oc` commands to get *Access key* and *Secret key*"

        Alternatively, you can run the following `oc` commands:

        i. To get *Access key* run:

        `oc get secret minio-root-user -o template --template '{{.data.MINIO_ROOT_USER}}' | base64 --decode`

        ii. And to get *Secret key* run:

        `oc get secret minio-root-user -o template --template '{{.data.MINIO_ROOT_PASSWORD}}' | base64 --decode`

-   Return to the **MinIO Web Console** using the provided URL. Enter the
**Access Key** as the **Username** and the **Secret Key** as the **Password**.
This will open the **Object Browser**, where you should verify that both
buckets: **my-storage** and **pipeline-artifacts** are visible as shown below:

    ![MinIO Object Browser](images/minio-object-browser.png)

!!! note "Alternatively, Running a script to install local MinIO object storage"

    Alternatively, you can run a script to install local object storage
    buckets and create connections using the OpenShift CLI (`oc`).
    For that, you need to install and configure the OpenShift CLI by
    following the [setup instructions](../../openshift/logging-in/setup-the-openshift-cli.md#installing-the-openshift-cli).
    Once the OpenShift CLI is set up, execute the following command to
    install MinIO object storage along with local S3 storage (MinIO) buckets
    and necessary connections:

    `oc apply -f https://raw.githubusercontent.com/nerc-project/fraud-detection/main/setup/setup-s3.yaml`

!!! tip "Clean Up"

    To delete all resources if not necessary just run `oc delete -f https://raw.githubusercontent.com/nerc-project/fraud-detection/main/setup/setup-s3.yaml`
    or `oc delete all,sa,rolebindings,pvc,job -l app=minio`.

!!! danger "Important Note"

    The script is based on a [guide for deploying MinIO](https://ai-on-openshift.io/tools-and-applications/minio/minio/).
    The MinIO-based Object Storage that the script creates is not meant for production usage.

### 2. Enabling data science pipelines

In this section, you prepare your workbench environment so that you can use data
science pipelines.

**Procedure**:

i. From the OpenShift AI dashboard, click the **Pipelines** tab.

ii. Click **Configure pipeline server**.

![Pipelines Section](images/pipelines.png)

iii. In the **Configure pipeline server** form, in the **Access key** field
next to the key icon, click the dropdown menu and then click **Pipeline Artifacts**
to populate the **Configure pipeline server** form with credentials for the
connection.

![Selecting the Pipeline Artifacts connection](images/ds-project-create-pipeline-server-form.png)

iv. Leave the database configuration as the default.

v. Click **Configure pipeline server**.

vi. Wait until the loading spinner disappears and **Start by importing a pipeline**
is displayed.

!!! note "Important Note"

    You must wait until the pipeline configuration is complete before you continue
    and create your workbench. If you continue and [create your workbench](#3-creating-a-workbench-and-a-notebook)
    **before** the pipeline server is ready, your workbench will not be able to
    submit pipelines to it.

    If you have waited **more than 5 minutes**, and the pipeline server configuration
    does not complete, you can delete the pipeline server and create it again.

    ![Delete pipeline server](images/ds-project-delete-pipeline-server.png)

**Verification**:

a. Navigate to the **Pipelines** tab for the project.

b. Next to **Import pipeline**, click the action menu (⋮) and then select
**View pipeline server configuration**.

![View pipeline server configuration menu](images/ds-project-pipeline-server-view.png)

An information box opens and displays the object storage connection information
for the pipeline server. as shown below:

![View pipeline server configuration](images/ds-project-pipeline-server-pop-up.png)

### 3. Creating a workbench and a notebook

#### Creating a workbench and selecting a notebook image

**Procedure**:

Prepare your Jupyter notebook server for using a GPU, you need to have:

Select the correct data science project and create workbench, see
[Populate the data science project](../data-science-project/using-projects-the-rhoai.md#populate-the-data-science-project-with-a-workbench)
for more information.

Please ensure that you start your Jupyter notebook server with options as
depicted in the following configuration screen. This screen provides you
with the opportunity to select a notebook image and configure its options,
including the Accelerator and Number of accelerators (GPUs).

![Fraud detection Workbench Information](images/fraud-detection-workbench.png)

For our example project, let's name it "Fraud detection". We'll select the
**TensorFlow** image with Recommended Version (selected by default), choose
a **Deployment size** of **Small**, choose **Accelerator** of
**NVIDIA V100 GPU**, **Number of accelerators** as **1**, and allocate
a **Cluster storage** space of **20GB** (Selected By Default).

Here, you will use **Environment Variables** to specify the Key/Value pairs related
to the S3-compatible object storage bucket for storing your model.

To add Environment variables please follow the following steps:

i. Click on **"Add variable"**.

ii. Select **"Config Map"** from the dropdown for the environment variable type.

iii. Choose **"Key / Value"** and enter the following keys along with their corresponding
values, which you have retrieved while "Editing connection":

![Edit Connection Pop up](images/edit-data-connection.png)

**Environment Variables**:

    Key: AWS_ACCESS_KEY_ID
    Value: <Access key>

    Key: AWS_SECRET_ACCESS_KEY
    Value: <Secret key>

    Key: AWS_S3_ENDPOINT
    Value: <Endpoint>

    Key: AWS_DEFAULT_REGION
    Value: <Region>

    Key: AWS_S3_BUCKET
    Value: <Bucket>

!!! note "Alternatively, Running `oc` commands"

    Alternatively, you can run the following `oc` commands:

    i. To get *Access key* run:

    `oc get secret minio-root-user -o template --template '{{.data.MINIO_ROOT_USER}}' | base64 --decode`

    ii. And to get *Secret key* run:

    `oc get secret minio-root-user -o template --template '{{.data.MINIO_ROOT_PASSWORD}}' | base64 --decode`

    iii. And to get *Endpoint* run:

    `oc get route minio-s3 -o template --template '{{.spec.host}}'`

    You need to add `https://` in the front of the endpoint host url.

!!! info "Running Workbench without GPU"

    If you do not require GPU resources for your task, you can leave the
    **Accelerator** field set to its default **None** selection.

    ![Workbench accelerator](images/workbench-without-gpu-accelerator.png)

**Verification**:

If this procedure is successful, you have started your Jupyter notebook
server. When your workbench is ready and the status changes to _Running_, click
the open icon (![Open Workbench](images/open.png)) next to your workbench's name,
or click the workbench name directly to access your environment:

![Open Fraud Detection JupyterLab Environment](images/open-fraud-detection-jupyter-lab.png)

!!! info "Note"

    If you made a mistake, you can edit the workbench to make changes. Please
    make sure you set the _Running_ status of your workbench to _Stopped_
    prior clicking the action menu (⋮) at the end of the selected workbench row
    as shown below:

    ![Workbench edit](images/ds-project-workbench-list-edit.png)

Once you have successfully authenticated by clicking "**mss-keycloak**" when
prompted, as shown below:

![Authenticate](images/authenticate-user.png)

Next, you should see the NERC RHOAI JupyterLab Web Interface, as shown below:

![RHOAI JupyterLab Web Interface](images/jupyterlab_web_interface.png)

The Jupyter environment is currently empty. To begin, populate it with content
using *Git*. On the left side of the navigation pane, locate the **Name** explorer
panel, where you can create and manage your project directories.

!!! note "Learn More About Working with Notebooks"

    For detailed guidance on using notebooks on NERC RHOAI JupyterLab, please
    refer to [this documentation](../data-science-project/explore-the-jupyterlab-environment.md#working-with-notebooks).

#### Importing the tutorial files into the Jupyter environment

Bring the content of this tutorial inside your Jupyter environment:

On the toolbar, click the Git Clone icon:

![Git Clone icon](images/jupyter-git-icon.png)

Enter the following **Git Repo URL**: [https://github.com/nerc-project/fraud-detection](https://github.com/nerc-project/fraud-detection)

Check the Include submodules option, and then click Clone.

![Clone A Repo](images/clone-a-repo.png)

In the file browser, double-click the newly-created **fraud-detection** folder.

![Jupyter file browser](images/jupyter-file-browser.png)

**Verification**:

In the file browser, you should see the notebooks that you cloned from Git.

![Jupyter file browser - fraud-detection](images/jupyter-file-browser-2.png)

#### Training a model

In your Jupyter notebook environment, within the root folder path of `fraud-detection`,
find the Jupyter notebook file `1_experiment_train.ipynb` that demonstrates how
to train a model within the NERC RHOAI. Please follow the instructions directly
in the notebook environment. The instructions guide you through some simple data
exploration, experimentation, and model training tasks. To run it you need to
double click it and execute the "Run" button to run all notebook cells at once.

!!! warning "Very Important: Monitoring Your Model Training Process"

    In the `1_experiment_train.ipynb` Jupyter notebook file, find the
    **"Monitor the Training"** section where you can use [ClearML](https://clear.ml/)
    to monitor your model training process.

    Please register your account at [https://app.clear.ml/login](https://app.clear.ml/login).
    After successfully registering your account, get **Application API Credentials**
    at: [https://app.clear.ml/settings/workspace-configuration](https://app.clear.ml/settings/workspace-configuration).

    Please update `CLEARML_API_ACCESS_KEY` and `CLEARML_API_SECRET_KEY` with your
    own ClearML Application API credentials, then uncomment the following code in
    the specified cell:

    ![Monitor the Training using ClearML](images/monitor-the-training.png)

**Verification**:

This process will take some time to complete. At the end, it will generate and
save the model `model.onnx` within the `models/fraud/1/` folder path of `fraud-detection`.

##### Adding MLflow to Training Code

!!! info "What is MLflow?"

    [MLflow](../../other-tools/mlflow/mlflow-overview.md) is an open-source platform
    that helps manage the entire machine learning lifecycle, including experimentation,
    reproducibility, deployment, and model management. For more information about
    how to set up your own MLflow server, read [this user guide](../../other-tools/mlflow/mlflow-server-setup.md).

In your Jupyter notebook environment, within the root folder path of `fraud-detection`,
find the `mlflow` directory. It contains the following files:

- `model.ipynb`: This Jupyter notebook contains the end-to-end machine learning
    workflow, including data preprocessing, model training, and MLflow logging.

- `requirements.txt`: This file lists all the Python package dependencies needed
    to run the code in `model.ipynb`.

Go back to your "Fraud detection" workbench and add a new  **Environment Variable**
to specify the Key/Value pairs related to the your MLflow server by clicking the
action menu (⋮) at the end of your workbench.

To add Environment variable please follow the following steps:

i. Click on **"Add another key / value pair"** under existing "Environment variables"
section:

ii. Choose **"Key / Value"** and enter the following keys along with their corresponding
values, which you have retrieved while "Editing connection":

**Environment Variables**:

    Key: MLFLOW_ROUTE
    Value: https://mlflow-route-<your-namespace>.apps.shift.nerc.mghpcc.org

![MLflow Route Environment Variable](images/mlflow-route-environment-var.png)

Once you execute the provided `model.ipynb`, the training process logs model
parameters, metrics, and artifacts to the MLflow tracking server. After training
and tuning hyperparameters, the final model artifact is logged to the tracking
server to record a link between the model, the input data it was trained on, and
the code used to generate it.

![MLflow Logging](images/mlflow-logging.png)

You'll be able to track the entire training lifecycle by navigating to your MLflow
tracking server at: `https://mlflow-route-<your-namespace>.apps.shift.nerc.mghpcc.org`.

### 4. Preparing a model for deployment

**Procedure**:

In your JupyterLab environment, open the notebook file `2_save_model.ipynb`. Follow
the instructions in the notebook to store the model and save it in the portable
**ONNX** format.

**Verification**:

After completing the notebook steps, verify that the `models/fraud/1/model.onnx`
file is stored in the object storage corresponding to the **My Storage** data
connection. Once saved, the model is now ready for use by your model server.

### 5. Deploying and testing a model

#### Deploying a model

Now that the model is stored and saved in the portable **ONNX** format, you can
deploy it as an API using an OpenShift AI **Model Server**.

OpenShift AI offers two options for model serving:

-  Single-model serving:

    Each model in the project is deployed on its own model server. This platform
    works well for large models or models that require dedicated resources.

-   Multi-model serving:

    All models in the project are deployed on the same model server. This platform
    is suitable for sharing resources among deployed models.

!!! note "Learn More about Model Serving"

    To learn more about how Model Serving works in the NERC RHOAI environment,
    [read this page](../data-science-project/model-serving-in-the-rhoai.md#create-a-model-server).

In this project, you are deploying only one model, so you can select either serving
type. The steps for deploying the fraud detection model depend on the type of model
serving platform you select:

-   [Deploying a model on a single-model server](#deploying-a-model-on-a-single-model-server)

-   [Deploying a model on a multi-model server](#deploying-a-model-on-a-multi-model-server)

##### Deploying a model on a single-model server

OpenShift AI single-model servers host only one model at a time. To deploy a model,
you first create a new model server and then deploy your model to it.

**Procedure**:

In the OpenShift AI dashboard, navigate to the data science project details page
and click the **Models** tab.

In the "Single-model serving platform" tile, click **Select single-model**.

You will be able to deploy the model by clicking the **Deploy model** button, as
shown below:

![Single-model serving platform](images/single-model-serving.png)

In the pop-up window that appears, depicted as shown below, you can specify the
following details:

For **Model deployment name**, type **fraud**.

For **Serving runtime**, select **OpenVINO Model Server**.

For **Model framework (name - version)**, select **onnx-1**.

For **Deployment mode**, select **Advanced** (*selected by default*).

For **Existing connection**, select **My Storage**.

Type the path that leads to the version folder that contains your model file: **models/fraud**

Leave the other fields with the default settings.

![Deploy model form for single-model serving](images/deploy-model-form-sm.png)

Click **Deploy**.

**Verification**:

When you return to the Deployed models page, you will see your newly deployed model.
Notice the loading symbol under the **Status** section. When the model has finished
deploying, the status icon will be a **green checkmark** indicating the model deployment
is complete as shown below:

![Deployed model status](images/ds-project-model-list-status-sm.png)

##### Deploying a model on a multi-model server

NERC RHOAI multi-model servers can host multiple models simultaneously. You can
create a new model server and deploy your model to it.

**Procedure**:

In the OpenShift AI dashboard, navigate to the data science project details page
and click the **Models** tab.

In the **Multi-model serving platform** tile, click **Select multi-model**.

You will be able to create a new model server by clicking the **Add model server**
button, as shown below:

![Add A Model Server](images/add-multi-model-server.png)

In the pop-up window that appears, depicted as shown below, you can specify the
following details:

For **Model server name**, type a name, for example **Model Server**.

For **Serving runtime**, select **OpenVINO Model Server**.

Leave the other fields with the default settings.

![Create model server form](images/create-model-server-form.png)

Click **Add**.

In the **Models** list, next to the new model server, click **Deploy** model.

![Create model server form](images/ds-project-workbench-list-deploy.png)

In the form, provide the following values:

For **Model deployment name**, type **fraud**.

For **Model framework (name - version)**, select **onnx-1**.

For **Existing connection**, select **My Storage**.

Type the path that leads to the version folder that contains your model file: **models/fraud**

Leave the other fields with the default settings.

![Deploy model form for multi-model serving](images/deploy-model-form-mm.png)

Click **Deploy**.

**Verification**:

When you return to the Deployed models page, you will see your newly deployed model.
You should click on the 1 on the Deployed models tab to see details. Notice the
loading symbol under the **Status** section. When the model has finished deploying,
the status icon will be a **green checkmark** indicating the model deployment is
complete as shown below:

![Deployed model status](images/ds-project-model-list-status-mm.png)

#### Testing the model API

Now that you've deployed the model, you can test its API endpoints.

**Procedure**:

-   In the OpenShift AI dashboard, navigate to the project details page and click
the **Models** tab.

-   Take note of the model's Inference endpoint URL. You need this information when
you test the model API.

    ![Deployed Multi-model Serving Inference Endpoints](images/deploy-model-inference-endpoints-fraud-mm.png)  

    The **Inference endpoint** field contains an **Internal Service** link, click
    the link to open a popup that shows the URL details, and then take note of
    the **grpcUrl** and **restUrl** values.

    !!! note "Single-model Serving Inference Endpoints"

        In the case of single-model serving, the **Inference endpoint** field
        contains an **Internal Service** link. Click the link to open a popup that
        displays the URL details. Take note of the **url** value if you want to
        access the inference endpoint from within the cluster. If you are accessing
        the model from outside the cluster, be sure to also note the **External**
        value.

        ![Deployed Single-model Serving Inference Endpoints](images/deploy-model-inference-endpoints-fraud-sm.png)

-   Return to the Jupyter notebook environment and test your new inference endpoints.

    If you deployed your model with the **multi-model serving platform**, follow
    the instructions in `3_rest_requests_multi_model.ipynb` to make a REST API call.
    Be sure to update the *rest_url* with your own **restUrl** value (as noted above).
    To make a gRPC API call, follow the instructions in `4_grpc_requests_multi_model.ipynb`,
    updating the *grpc_host* with your own **grpcUrl** value (as noted above).

    If you deployed your model with the **single-model serving platform**, follow
    the directions in `5_rest_requests_single_model.ipynb` to try a REST API call.
    Be sure to update the *rest_url* with your own *url* or *External* value (as
    noted above).

### 6. Implementing pipelines

!!! question "Important Note"

    If you create your workbench before the pipeline server is ready, it won't
    be able to submit pipelines. If the pipeline server was configured **after**
    your workbench was created, you'll need to **stop** and then **restart**
    your workbench. Wait until the workbench status shows as *Running*.

#### Automating workflows with data science pipelines

In previous sections of this tutorial, you used a notebook to train and save your
model. Alternatively, you can automate these tasks using
**Red Hat OpenShift AI pipelines**.

Pipelines allow you to automate the execution of multiple notebooks and Python scripts.
By using pipelines, you can run long training jobs or schedule model retraining
without manually executing notebooks.

In this section, you will create a simple pipeline using the **GUI pipeline editor**.

This pipeline will:

-   Use the same notebook from the previous sections to train the model.

-   Save the trained model to **S3 storage** bucket.

Your completed pipeline should resemble the one in the `6 Train Save.pipeline` file.

!!! note "Note"

    To explore the **pipeline editor**, follow the steps in the next procedure to
    create your own pipeline. Alternatively, you can **skip the procedure** and
    instead feel free to run and use the provided `6 Train Save.pipeline` file.

##### Create a pipeline

i. Open your workbench's JupyterLab environment. If the launcher is not visible,
click + to open it.

![Pipeline buttons](images/wb-pipeline-launcher.png)

ii. Click **Pipeline Editor**.

![Pipeline Editor button](images/wb-pipeline-editor-button.png)

You've created a blank pipeline.

iii. Set the default runtime image for when you run your notebook or Python code.

a. In the pipeline editor, click **Open Panel**.

![Open Panel](images/wb-pipeline-panel-button-loc.png)

b. Select the **Pipeline Properties** tab.

![Pipeline Properties Tab](images/wb-pipeline-properties-tab.png)

c. In the **Pipeline Properties** panel, scroll down to **Generic Node Defaults**
and **Runtime Image**. Set the value to `TensorFlow with CUDA and Python 3.11 (UBI9)`.

![Pipeline Runtime Image](images/wb-pipeline-runtime-image.png)

iv. **Save** the pipeline.

##### Add nodes to your pipeline

Add some steps, or **nodes** in your pipeline. Your two nodes will use the
`1_experiment_train.ipynb` and `2_save_model.ipynb` notebooks.

i. From the file-browser panel, drag the `1_experiment_train.ipynb` and
`2_save_model.ipynb` notebooks onto the pipeline canvas.

![Drag and Drop Notebooks](images/wb-pipeline-drag-drop.png)

ii. Click the output port of `1_experiment_train.ipynb` and drag a connecting
line to the input port of `2_save_model.ipynb`.

![Connect Nodes](images/wb-pipeline-connect-nodes.png)

iii. **Save** the pipeline.

##### Specify the training file as a dependency

Set node properties to specify the training file as a dependency.

!!! danger "Very Important"

    If you don't set this file dependency, the file won't be included in the
    node when it runs and the training job would fail.

i. Click the `1_experiment_train.ipynb` node.

![Select Node 1](images/wb-pipeline-node-1.png)

ii. In the Properties panel, click the **Node Properties** tab.

iii. Scroll down to the **File Dependencies** section and then click **Add**.

![Add File Dependency](images/wb-pipeline-node-1-file-dep.png)

iv. Set the value to `data/*.csv` which contains the data to train your model.

v. Select the **Include Subdirectories** option.

![Set File Dependency Value](images/wb-pipeline-node-1-file-dep-form.png)

vi. **Save** the pipeline.

##### Create and store the ONNX-formatted output file

In node 1, the notebook creates the `models/fraud/1/model.onnx` file. In node 2,
the notebook uploads that file to the S3 storage bucket. You must set
`models/fraud/1/model.onnx` file as the output file for both nodes.

i. Select node 1.

ii. Select the **Node Properties** tab.

iii. Scroll down to the **Output Files** section, and then click **Add**.

iv. Set the value to `models/fraud/1/model.onnx`.

![Set file dependency value](images/wb-pipeline-node-1-file-output-form.png)

v. Repeat steps ii-iv for node 2.

vi. **Save** the pipeline.

##### Configure the connection to the S3 storage bucket

In node 2, the notebook uploads the model to the S3 storage bucket.

You must set the S3 storage bucket keys by using the secret created by the
**My Storage** connection that you set up in the [Storing data with connections](#1-storing-data-with-connections)
section of this tutorial.

You can use this secret in your pipeline nodes without having to save the
information in your pipeline code. This is important, for example, if you want
to save your pipelines - without any secret keys - to source control.

In this example, the secret is named `aws-connection-my-storage`.

!!! tip "How to get the secret name?"

    If you named your connection something other than **"My Storage"**, you can
    obtain the secret name in the OpenShift AI dashboard by hovering over the
    help (?) icon in the Connections tab.

    ![My Storage Secret Name](images/dsp-dc-secret-name.png)

    **Very Important:** *Make sure to replace all instances of `aws-connection-my-storage`
    secret with your own.*

The `aws-connection-my-storage` secret includes the following fields:

    AWS_ACCESS_KEY_ID

    AWS_DEFAULT_REGION

    AWS_S3_BUCKET

    AWS_S3_ENDPOINT

    AWS_SECRET_ACCESS_KEY

You must set the secret name and key for each of these fields.

**Procedure**:

i. Remove any pre-filled environment variables.

a. Select node 2, and then select the Node Properties tab.

Under **Additional Properties**, note that some environment variables have
been pre-filled. The pipeline editor inferred that you need them from the
notebook code.

Since you don't want to save the value in your pipelines, remove all of
these environment variables.

b. Click **Remove** for each of the pre-filled environment variables.

![Remove Env Var](images/wb-pipeline-node-remove-env-var.png)

ii. Add the S3 bucket and keys by using the Kubernetes secret.

a. Under **Kubernetes Secrets**, click **Add**.

![Add Kubernetes Secret](images/wb-pipeline-add-kube-secret.png)

b. Enter the following values and then click **Add**.

🔸  **Environment Variable**: *AWS_ACCESS_KEY_ID*

-   **Secret Name**: *aws-connection-my-storage*

-   **Secret Key**: *AWS_ACCESS_KEY_ID*

![Secret Form](images/wb-pipeline-kube-secret-form.png)

iii. Repeat **Step ii** for each of the following Kubernetes secrets:

🔸  **Environment Variable**: *AWS_SECRET_ACCESS_KEY*

-   **Secret Name**: *aws-connection-my-storage*

-   **Secret Key**: *AWS_SECRET_ACCESS_KEY*

🔸  **Environment Variable**: AWS_S3_ENDPOINT

-   **Secret Name**: aws-connection-my-storage

-   **Secret Key**: AWS_S3_ENDPOINT

🔸  **Environment Variable**: AWS_DEFAULT_REGION

-   **Secret Name**: aws-connection-my-storage

-   **Secret Key**: AWS_DEFAULT_REGION

🔸  **Environment Variable**: AWS_S3_BUCKET

-   **Secret Name**: aws-connection-my-storage

-   **Secret Key**: AWS_S3_BUCKET

iv.Select File -> Save Pipeline As to save and rename the *.pipeline* file. For
example, rename it to **My Train Save.pipeline**.

##### Run the Pipeline

You can use your own newly created pipeline or the pipeline in the provided
`6 Train Save.pipeline` file.

**Procedure**:

i. Click the **play** button in the toolbar of the pipeline editor.

![Pipeline Run Button](images/wb-pipeline-run-button.png)

ii. In the next popup:

![pipeline expanded](images/run-pipeline-ok.png)

-   Enter a name for your pipeline i.e. `My Train Save`.

-   Verify that the **Runtime Configuration**: is set to **Data Science Pipeline**.

-   Click **OK**.

!!! failure "Troubleshooting Help"

    If you see an error message stating that "no runtime configuration for Data
    Science Pipeline is defined", you might have created your workbench before
    the pipeline server was available. If you configured the pipeline server
    after you created your workbench, you need to stop the workbench and then started
    your workbench.

iii. In the OpenShift AI dashboard, open your data science project and expand the
newly created pipeline.

![New pipeline expanded](images/dsp-pipeline-complete.png)

iv. Click **View runs**.

![View runs for selected pipeline](images/dsp-view-run.png)

v. Click your run and then view the pipeline run in progress.

![Pipeline run progress](images/pipeline-run-complete.png)

The result should be a `models/fraud/1/model.onnx` file in your S3 bucket which
you can serve, just like you did manually in the [Preparing a model for deployment](#4-preparing-a-model-for-deployment)
section.

#### Running a data science pipeline generated from Python code

In the previous section, you created a simple pipeline using the graphical pipeline
editor. However, it's often preferable to define pipelines in code, allowing for
version control and easier collaboration.

The [Kubeflow pipelines (kfp)](https://github.com/kubeflow/pipelines) SDK offers
a Python API for building pipelines programmatically. You can install the SDK
using the following command:

    pip install kfp

With this package, you can write pipeline definitions in Python, compile them into
YAML format, and then import the resulting YAML into OpenShift AI.

!!! info "Note"

    In OpenShift AI, the current version of kfp uses **Argo Workflows** as its
    execution backend.

The [GitHub repository](https://github.com/nerc-project/fraud-detection) provides
the files for you to view and upload.

1. Optionally, view the provided Python code in your JupyterLab environment by
navigating to the `fraud-detection` project's `pipeline` directory. It contains
the following files:

    - `7_get_data_train_upload-tekton.yaml` is unused older version of pipeline
    YAML file using the [OpenShift Pipeline (Tekton)](https://tekton.dev/).

    - `7_get_data_train_upload.py` is the main pipeline code.

    - `build.sh` is a script that builds the pipeline and creates the YAML file.

    For your convenience, the output of the `build.sh` script is available in the
    top-level `fraud-detection` directory. The file is named `7_get_data_train_upload.yaml`,
    as shown below:

    ![Pipeline Files and Folder](images/pipeline-files-folder.png)

    !!! info "Note"

        You can also run the `build.sh` script manually from your local terminal
        by executing the following command from the `pipeline` directory of the
        `fraud-detection` project:

            sh ./build.sh

2. Right-click the `7_get_data_train_upload.yaml` file and then click **Download**.

3. Upload the `7_get_data_train_upload.yaml` file to OpenShift AI.

    i. In the OpenShift AI dashboard, navigate to your data science project page.
    Click the **Pipelines** tab and then click **Import pipeline**.

    ii. Enter values for **Pipeline name** and **Pipeline description**.

    iii. Click **Upload** and then select `7_get_data_train_upload.yaml` from your
    local files to upload the pipeline.

    ![Pipeline Upload](images/ds-pipeline-upload.png)

    iv. Click **Import pipeline** to import and save the pipeline.

    The pipeline shows in graphic view as shown below:

    ![Pipeline Graph](images/ds-pipeline-graph.png)

4. Select **Actions** >> **Create run**.

5. On the Create run page, provide the following values:

    i. For **Experiment**, leave the value as `Default`.

    ii. For **Name**, type any name, for example `Run 1`.

    iii. For **Pipeline**, select the pipeline that you uploaded.

    You can leave the other fields with their default values.

    ![Create Pipeline Run](images/ds-create-pipeline-run.png)

6. Click **Create run** to create the run.

    A new run starts immediately.

    ![Create Pipeline Run](images/ds-pipeline-run.png)

#### Schedule execution

We can also **schedule** an execution so that the confidence check is executed at
regular intervals.

To do that:

-   Go back to the OpenShift AI dashboard, open your data science project

-   Find the pipeline you just ran in the Pipelines tab

-   Click the 3 dots at the very end of the pipeline row, and click "Create schedule".

    ![Create schedule](images/create-schedule.png)

-   On the next screen:

    i. keep the **Experiment** to `Default`,

    ii. Set a **Name**,

    iii. select a `Periodic` **Trigger type**,

    iv. run it every **Day** with Maximum concurrent runs of **3**.

    v. keep the `My Train Save` **Pipeline** and **Version** (*The Pipeline's name
        we set while running the Pipeline for the first time*)

    vi. and click **Create schedule**:

    ![Daily Pipeline Run Schedule](images/dailyrun-3.png)

    vii. This will shows the Graph view of the Scheduled Pipeline Run:

    ![Scheduled Pipeline Run](images/dailyrun-scheduled.png)

    viii. In **Data Science Pipelines** -> **Runs**, click the **Schedules** tab
    to verify that the **Scheduled** run is visible, as shown below:

    ![Schedule Run](images/schedule-run.png)

    It will run daily **3** runs, and will inform us if anything goes wrong with
    your training and saving the model process.

## Deploy the Model Application on NERC OpenShift

The **model application** includes a visual user interface (UI) powered by [Gradio](https://www.gradio.app/),
allowing users to interact with the [trained model](#training-a-model). This
interface enables users to input transaction data and receive predictions on
potential fraud, providing an intuitive way to test the model's performance.
Additionally, example inputs are provided within the UI to help users understand
the expected data format and interact with the model effectively.

The model application code is located in the `application` folder within the
root directory of `fraud-detection`. You can find this folder in the **GitHub repository**
you cloned during the step: [Importing the tutorial files into the Jupyter environment](#importing-the-tutorial-files-into-the-jupyter-environment).

![Model Application Folder](images/Model_Application_Folder_fraud-detection.png)

If you look inside it `model_application.py`, you will find two crucial lines of
code for retrieving environment variables:

```python
# Get a few environment variables. These are so we:
# - Know what endpoint we should request
# - Set server name and port for Gradio
MODEL_NAME = os.getenv("MODEL_NAME", "fraud")   <----------
REST_URL = os.getenv("INFERENCE_ENDPOINT")   <----------
INFER_URL = f"{REST_URL}/v2/models/{MODEL_NAME}/infer"
...

    response = requests.post(INFER_URL, json=payload, headers=headers)    <----------
```

This is how you send a request to the NERC RHOAI Model Server with the data that
you want it to process for a prediction.

We will deploy the application on OpenShift by linking it to the [GitHub repository](https://github.com/nerc-project/fraud-detection).
OpenShift will fetch the repository, build a container image using the **Dockerfile**,
and publish it automatically.

To accomplish this, from the OpenShift AI dashboard, navigate to the OpenShift Web
Console:

![The NERC OpenShift Web Console Link](images/the-nerc-openshift-web-console-link.png)

Ensure you are in **Developer** view and have selected the correct data science
project. Then, click on "**+Add**" in the left menu and select "**Import from Git**".

![Import from Git](images/Import_from_Git.png)

In the "Git Repo URL" enter: `https://github.com/nerc-project/fraud-detection` (this
is the same repository you [pulled into RHOAI earlier](#importing-the-tutorial-files-into-the-jupyter-environment)).
Then press "Show advanced Git options" and set "Context dir" to "/application"
where the application **Dockerfile** is located as shown below:

![Import Git Repo With Dockerfile](images/import_fraud_detection_git_repo.png)

At the **General** section, select "Create application" option under **Application**
and then give unique **Application name** i.e. `fraud-detection-application` and
also **Name** i.e. `fraud-detection-application` as shown below:

![General Application Information](images/general-fraud-detection-application-info.png)

Finally, at the **Deploy** section, press "Show advanced Deployment option".

Set these values in the **Environment variables (runtime only)** fields:

![Deployment Options](images/deploy-fraud-detection-advance-option.png)

**Name**: *MODEL_NAME*

**Value**: From the RHOAI projects interface ([from the previous section](#testing-the-model-api)),
copy the **Model name** value. For example: `fraud`.

**Name**: *INFERENCE_ENDPOINT*

**Value**: From the RHOAI projects interface ([from the previous section](#testing-the-model-api)),
copy the **restUrl** value. For example: `http://modelmesh-serving.<your-namespace>:8008`.

![Deployed Model Serving Inference Endpoints](images/deploy-model-inference-endpoints-fraud-mm.png)

Your full settings page should look something like this:

![Import from Git Settings](images/Import_from_Git_fraud_detection-settings.png)

!!! note "Target Port"

    Under "Advanced options," make sure to set the **Target Port** to **8080**,
    which corresponds to the exposed port in the application's [Dockerfile](https://github.com/nerc-project/fraud-detection/blob/main/application/Dockerfile#L14).

Press **Create** to start deploying the application.

You should now see a new object is added in your topology map for the application
that you just added. When the circle of your deployment turns dark blue it means
that it has finished deploying.

If you want more details on how the deployment is going, you can press the circle
and look at **Resources** in the right menu that opens up. There you can see how
the build is going and what's happening to the pod.

![Fraud Detection Deployment Resources](images/fraud_detection_deployment_resources.png)

The application will be ready when the build is complete and the pod is "Running".

When the application has been deployed successfully, you can either open the
application URL using the **Open URL** icon as shown below or you can naviate to
the route URL by navigating to the "Routes" section under the _Location_ path as
shown below:

![Application deployed](images/fraud-detection-application_deployed.png)

This will open the application interface in a new tab.

Congratulations, you now have an application running your AI model!

Try entering a few values and click "Submit" to see if it predicts it as a credit
fraud or not. You can select one of the example rows at the bottom of the application
page, this will auto-populate the values to the form.

![Predict Credit Card Fraud App Gradio Interface](images/gradio_application_interface.png)

---
