# Red Hat OpenShift AI (RHOAI) Overview

RHOAI offers a versatile and scalable MLOps solution equipped with tools for
rapid constructing, deploying, and overseeing AI-driven applications. Integrating
the proven features of both Red Hat OpenShift AI and Red Hat OpenShift creates a
comprehensive enterprise-grade artificial intelligence and machine learning (AI/ML)
application platform, facilitating collaboration among data scientists, engineers,
and app developers. This consolidated platform promotes consistency, security,
and scalability, fostering seamless teamwork across disciplines and empowering
teams to quickly explore, build, train, deploy, test machine learning models, and
scale AI-enabled intelligent applications.

Formerly known as Red Hat OpenShift Data Science, OpenShift AI facilitates the
complete journey of AI/ML experiments and models. OpenShift AI enables data
acquisition and preparation, model training and fine-tuning, model serving and
model monitoring, hardware acceleration, and distributed workloads using
graphics processing unit (GPU) resources.

## AI for All

Recent enhancements to Red Hat OpenShift AI include:

-   Implementation **Deployment pipelines** for monitoring AI/ML experiments and
    automating ML workflows accelerate the iteration process for data scientists
    and developers of intelligent applications. This integration facilitates swift
    iteration on machine learning projects and embeds automation into application
    deployment and updates.

-   **Model serving** now incorporates GPU assistance for inference tasks and custom
    model serving runtimes, enhancing inference performance and streamlining the
    deployment of foundational models.

-   With **Model monitoring**, organizations can oversee performance and operational
    metrics through a centralized dashboard, enhancing management capabilities.

## Red Hat OpenShift AI ecosystem

| Name                                   | Description                                                                                                                                                                                      |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| AI/ML modeling and visualization tools | JupyterLab UI with prebuilt notebook images and common Python libraries and packages; TensorFlow; PyTorch, CUDA; and also support for custom notebook images                                     |
| Data engineering                       | Support for different Data Engineering third party tools (optional)                                                                                                                              |
| Data ingestion and storage             | Supports [Amazon Simple Storage Service (S3)](https://aws.amazon.com/s3/) and [NERC OpenStack Object Storage](../../openstack/persistent-storage/object-storage.md)                              |
| GPU support                            | Available NVIDIA GPU Devices (with GPU operator): [NVIDIA A100-SXM4-40GB and V100-PCIE-32GB](../../openshift/applications/scaling-and-performance-guide.md#how-to-select-a-different-gpu-device) |
| Model serving and monitoring           | Model serving (KServe with user interface), model monitoring, OpenShift Source-to-Image (S2I), Red Hat OpenShift API Management (optional add-on), Intel Distribution of the OpenVINO toolkit    |
| Data science pipelines                 | Data science pipelines (Kubeflow Pipelines) chain together processes like data preparation, build models, and serve models                                                                       |

---
