# Rclone

[Rclone](https://rclone.org/) is a program to manage files on cloud storage. It
is a feature-rich alternative to cloud vendors' web storage interfaces. Different
cloud storage products support rclone including S3 object stores, business &
consumer file storage services, as well as standard transfer protocols. Rclone
is mature, open-source software originally inspired by **rsync** and written in Go.

## Deployment

### Deploying as a Workbench Using a Data Science Project (DSP) on NERC RHOAI

1.  Navigating to the OpenShift AI dashboard.

    Please follow [these steps](../../openshift-ai/logging-in/access-the-rhoai-dashboard.md)
    to access the NERC OpenShift AI dashboard.

2.  Please ensure that you start your Rclone Web server with options as depicted
    in the following configuration screen. This screen provides you with the opportunity
    to select a notebook image and configure its options, including the Accelerator
    and Number of accelerators (GPUs).

    ![Rclone Workbench Information](images/rclone-workbench.png)

    For our example project, let's name it "Rclone Workbench". We'll select the
    **Rclone** image, choose a **Deployment size** of **Small**, choose **Accelerator**
    of **None**, and allocate a **Cluster storage** space of **100Mi**.

    !!! tip "Tip"

        The dashboard currently enforces a minimum storage volume size of 20GB, which
        exceeds the requirements for the Rclone configuration. Please ensure that you
        change it to **100Mi** in **Cluster Storage**.

3.  If this procedure is successful, you have started your Rclone web server. When
    your workbench is ready, the status will change to _Running_ and you can select
    "Open" to go to your environment:

    ![Open Rclone Web Server](images/open-rclone-web-server.png)

4.  Once you have successfully authenticated by clicking "**mss-keycloak**" when
    prompted, as shown below:

    ![Authenticate](images/authenticate-user.png)

    Next, you should see the Rclone WebUI Login page, as shown below:

    ![Rclone Login](images/RHOAI-Rclone-login.png)

    !!! info "What are the Username and Password for Accessing the Rclone Web Interface?"

        **No username or password** is required for this setup. Simply click on
        "Login" to access the Rclone Web Interface.

### Deploying Rclone on NERC OpenShift as a Standalone Application

-   **Prerequisites**:

    Setup the OpenShift CLI (`oc`) Tools locally and configure the OpenShift CLI
    to enable `oc` commands. Refer to [this user guide](../../openshift/logging-in/setup-the-openshift-cli.md).

#### Steps

1.  **Clone** or navigate to [this repository](https://github.com/nerc-project/rclone-web-on-openshift.git).

    To get started, clone the repository using:

    ```sh
    git clone https://github.com/nerc-project/rclone-web-on-openshift.git
    cd rclone-web-on-openshift
    ```

    In the `standalone/deploy` folder, you will find the following YAML files:

    i. `01-pvc.yaml`: Creates a persistent volume to store the configuration.

    ii. `02-deployment.yaml`: Deploys the application.

    !!! danger "Very Important: Change provided admin username and password"

        Modify the admin account and password to restrict access (highly recommended).

    iii. `03-service.yaml`, `04-route.yaml`: Set up external access to connect to
    the Web UI.

2. Run this `oc` command: `oc apply -f ./standalone/deploy/.` to execute all YAML
files located in the **standalone/deploy** folder.

## Configuration

-   You will see the `rclone-app` application on OpenShift Web Dashboard.

-   Once the application is deployed and the route is set up, it can be accessed
    at a web URL similar to `https://rclone-<your-namespace>.apps.shift.nerc.mghpcc.org`
    by clicking any one of the links as shown here:

    ![Rclone Web Link](images/Rclone-route-link.png)

-   Users will be prompted to log in with a username and password set in
    `02-deployment.yaml` as [environment variables](https://github.com/nerc-project/rclone-web-on-openshift/blob/main/standalone/deploy/02-deployment.yaml#L40-L43)
    before gaining access to the Rclone Login page, as shown below:

    ![Rclone Web Login](images/rclone-web-login.png)  

-   Once authenticated, log in to the Rclone WebUI Login page again using the same
    username and password.

    ![Rclone Login](images/Rclone-login.png)

-   Create a configuration for your endpoints.

    !!! info "Rclone to connect the NERC OpenStack Object Storage"

        For example, here we are setting up an S3 configuration to connect to a
        container (bucket) on the NERC OpenStack. You must have already created
        this container and gathered all the necessary details: the endpoint,
        access key, secret key, and container name. Refer to [this guide](../../openstack/persistent-storage/object-storage.md#configuring-the-aws-cli)
        to learn how to retrieve this information from your NERC OpenStack project.

    i. In Rclone, click on "**Configs**" Menu.  

    ii. Click on "Create a New Config" button to create a new Remote.

    ![Rclone Configs Menu](images/Rclone-configs-menu.png)

    iii. Create a new configuration, give it a name i.e. `myBucket`, and select
    "Amazon S3 Compliant Storage Providers...", which support the NERC OpenStack
    Object Storage/ Swift.

    ![Rclone New Remote](images/Rclone-config-setup.png)

    iv. Enter the connection details by providing the **AWS Access Key ID**,
    **AWS Secret Access Key**, and the **S3 Endpoint** under
    _"Endpoint for S3 API"_ (e.g., `https://stack.nerc.mghpcc.org:13808`, the
    default S3 Endpoint URL for NERC OpenStack Object Storage). The final value
    is automatically copied into other fields - this is expected behavior.

    !!! info "Very Important: Endpoint for S3 API for the NERC Object Storage/ Swift"

        The default endpoint for S3 API for the NERC Object Storage/ Swift is `https://stack.nerc.mghpcc.org:13808`.

    ![Rclone Connection Info](images/Rclone-connection-info.png)

    v. Finalize the config by clicking on "Next" at the bottom.

    Now that you have completed the remote setup, go to the **Explorer** menu,
    select the remote, and start browsing!

    ![Rclone Explore](images/Rclone-explore.png)

## Usage

In this simple example, we will transfer a sample dump from Wikipedia. Wikimedia
publishes these dumps daily, and they are mirrored by various organizations.

In a "standard" setup, loading this data into your object store wouldn't be very
practical, as it often requires downloading it locally first before uploading it
to your storage.

This is how we can do it with Rclone:

-   Create another remote of type "HTTP" named as `wikidump`.

    ![Rclone A New Remote](images/Rclone-wiki-config.png)

-   Enter the address of one of the mirrors. Here we use `https://dumps.wikimedia.your.org/wikidatawiki/`.

    ![Rclone Wiki Remote HTTP](images/Rclone-wiki-http.png)

-   Open the Explorer view, set it in dual-pane layout:

    ![Rclone Dual Pane Layout Explorer](images/Rclone-dual-pane-layout.png)

    In the first pane, open your first remote, i.e., `myBucket`, and in the other
    pane, open the remote `wikidump`, which should look like this:

    ![Rclone Two Pane View](images/Rclone-two-pane-view.png)

    Browse to the folder you want, select a file or folder, and simply drag and
    drop it from `wikidump` to your NERC OpenStack Object Storage container/bucket.

    For a more interesting test, try selecting a larger file!

-   Click on the "Dashboard" menu, where you will see the file transfer happening
    in the background.

    ![Rclone Dashboard View](images/Rclone-dashboard.png)

That's it! No installation required, high-speed optimized transfer, and you can
even perform multiple transfers in the background...

---
