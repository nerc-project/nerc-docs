# Test the Model in the NERC RHOAI

Now that the [model server is ready](model-serving-in-the-rhoai.md) to receive requests,
we can test it.

!!! tip "How to get access to the NERC RHOAI Dashboard from JupyterLab Environment?"

    If you had closed the NERC RHOAI dashboard, you can access it from your currently
    opened JupyterLab IDE by clicking on _File -> Hub Control Panel_ as shown below:

    ![Jupyter Hub Control Panel Menu](images/juyter-hub-control-panel-menu.png)

## Using the Model Server Inference Endpoint

As [described here](model-serving-in-the-rhoai.md#deploy-the-model), once your
model is successfully deployed using **Models and model servers**, the model is
accessible through the inference API endpoints as shown below:

![Successfully Deployed Model Inference endpoints Info](images/deployed-model-inference-endpoints.png)

The **Inference endpoint** field contains an **Internal Service** link, click
the link to open a popup that shows the URL details, and then take note of
the **grpcUrl** and **restUrl** values.

### Using the model server to do an inference using gRPC

-   In your project in JupyterLab, open the notebook `03_remote_inference_grpc.ipynb`
    and follow the instructions to see how the model can be queried.

-   Update the `grpc_url` with your own **grpcUrl** value as [previously noted](#using-the-model-server-inference-endpoint).

    ![Change grpcUrl Value](images/change-grpc-url-value.png)

-   Once you've completed the notebook's instructions, the object detection model
    can isolate and recognize T-shirts, bottles, and hats in pictures, as shown below:

    ![Model Test to Detect Objects In An Image](images/model-test-object-detection.png)

### Using the model server to do an inference using REST

-   In your project in JupyterLab, open the notebook `04-remote_inference_rest.ipynb`
    and follow the instructions to see how the model can be queried.

-   Update the `rest_url` with the **restUrl** as [previously noted](#using-the-model-server-inference-endpoint).

    ![Change restUrl Value](images/change-rest-url-value.png)

-   Once you've completed the notebook's instructions, the object detection model
    can isolate and recognize T-shirts, bottles, and hats in pictures, as shown below:

    ![Model Test to Detect Objects In An Image](images/model-test-object-detection.png)

## Building and deploying an intelligent application

The application we are going to deploy is a simple example of how you can add an
intelligent feature powered by AI/ML to an application. It is a webapp that you
can use on your phone to discover coupons on various items you can see in a store,
in an augmented reality way.

### Architecture

The different components of this intelligent application are:

• **The Frontend**: a React application, typically running on the browser of your
phone,

• **The Backend**: a NodeJS server, serving the application and relaying API calls,

• **The Pre-Post Processing Service**: a Python FastAPI service, doing the image
pre-processing, calling the model server API, and doing the post-processing before
sending the results back.

• **The Model Server**: the RHOAI component serving the model as an API to do
the inference.

### Application Workflow Steps

1. Pass the image to the pre-post processing service

2. Pre-process the image and call the model server

3. Send back the inference result

4. Post-process the inference and send back the result

5. Pass the result to the frontend for display

### Deploy the application

The deployment of the application is really easy, as we already created for you
the necessary YAML files. They are included in the Git project we used for this
example project. You can find them in the **deployment** folder inside your JupyterLab
environment, or directly [here](https://github.com/nerc-project/nerc_rhoai_mlops/tree/main/deployment).

To deploy the Pre-Post Processing Service service and the Application:

-   From your [NERC's OpenShift Web Console](https://console.apps.shift.nerc.mghpcc.org/),
    navigate to your project corresponding to the _NERC RHOAI Data Science Project_
    and select the "Import YAML" button, represented by the "+" icon in the top
    navigation bar as shown below:

    ![YAML Add Icon](images/yaml-upload-plus-icon.png)

-   Verify that you selected the correct project.

    ![Correct Project Selected for YAML Editor](images/project-verify-yaml-editor.png)

-   Either drag and drop `https://github.com/nerc-project/nerc_rhoai_mlops/blob/main/deployment/pre_post_processor_deployment.yaml`
    or copy and paste the contents of this `pre_post_processor_deployment.yaml`
    file into the opened Import YAML editor box. If you have named your model
    **coolstore** as instructed, you're good to go. If not, modify the value on
    **[line # 35](https://github.com/nerc-project/nerc_rhoai_mlops/blob/main/deployment/pre_post_processor_deployment.yaml#L35)**
    with the name you set. You can then click the **Create** button as shown below:

    ![YAML Editor Add Pre-Post Processing Service Content](images/pre_post_processor_deployment-yaml-content.png)

-   Once Resource is successfully created, you will see the following screen:

    ![Resources successfully created Importing More YAML](images/yaml-import-new-content.png)

-   Click on "Import more YAML" and Copy/Paste the content of the file `intelligent_application_deployment.yaml`
    inside the opened YAML editor. Nothing to change here, you can then click the
    **Create** button as shown below:

    ![YAML Editor Pre-Post Processing Service Content](images/intelligent_application_deployment-yaml-content.png)

-   If both deployments are successful, you will be able to see both of them grouped
    under "intelligent-application" on the **Topology View** menu, as shown below:

    ![Intelligent Application Under Topology](images/intelligent_application-topology.png)

### Use the application

The application is relatively straightforward to use. Click on the URL for the
Route `ia-frontend` that was created.

You have first to allow it to use your camera, this is the interface you get:

![Intelligent Application Frontend Interface](images/intelligent-application-frontend-interface.png)

You have:

-   The current view of your camera.

-   A button to take a picture as shown here:

    ![Capture Camera Image](images/capture-camera-image.png)

-   A button to switch from front to rear camera if you are using a phone:

    ![Switch Camera View](images/switch-camera-view.png)

-   A **QR code** that you can use to quickly open the application on a phone
    (much easier than typing the URL!):

    ![QR code](images/QR-code.png)

When you take a picture, it will be sent to the `inference` service, and you will
see which items have been detected, and if there is a promotion available as shown
below:

![Object Detection Via Phone Camera](images/object-detection-via-phone.jpg)

### Tweak the application

There are two parameters you can change on this application:

-   On the `ia-frontend` Deployment, you can modify the `DISPLAY_BOX` environment
    variable from `true` to `false`. It will hide the bounding box and the inference
    score, so that you get only the coupon flying over the item.

-   On the `ia-inference` Deployment, the one used for pre-post processing, you
    can modify the `COUPON_VALUE` environment variable. The format is simply an
    Array with the value of the coupon for the 3 classes: bottle, hat, shirt. As
    you see, these values could be adjusted in real time, and this could even be
    based on another ML model!

---
