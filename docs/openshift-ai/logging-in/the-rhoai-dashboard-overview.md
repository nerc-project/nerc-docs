# The NERC's OpenShift AI dashboard Overview

In the NERC's RHOAI dashboard, you can see multiple links on your left hand side.

![RHOAI Dashboard](images/the-rhoai-dashboard.png)

1.  **Data Science Projects**: View your existing projects. This will show different
    projects corresponding to your NERC-OCP (OpenShift) resource allocations. Here,
    you can choose specific projects corresponding to the appropriate allocation
    where you want to work. Within these projects, you can create workbenches,
    deploy various development environments (such as Jupyter Notebooks, VS Code,
    RStudio, etc.), create connections, or serve models.

    !!! info "What are Workbenches?"

        Workbenches are development environments. They can be based on JupyterLab,
        but also on other types of IDEs, like VS Code or RStudio. You can create
        as many workbenches as you want, and they can run concurrently.

2.  **Models**: Manage and view the health and performance of your deployed
    models across different projects corresponding to your NERC-OCP (OpenShift)
    resource allocations.

    -   _Model registry_: RHOAI provides a central place to view and manage registered
        models, helping data scientists share, version, deploy and track predictive
        and gen AI models, metadata and model artifacts. Model registries provide
        a structured and organized way to store, share, version, deploy, and track
        models. Users can select a model registry to view and manage your registered
        models.

    -   _Model deployments_: Manage and view the health and performance of your
        deployed models. Also, you can "Deploy Model" to a specific project selected
        from the dropdown menu here. Models enable you to quickly serve trained
        models for real-time inference. Each data science project can have multiple
        model servers, and each server can host multiple models.

3.  **Data Science Pipelines**:

    -   _Pipelines_: Manage your pipelines for a specific project selected from the
        dropdown menu.

    -   _Runs_: Manage and view your runs for a specific project selected from the
        dropdown menu.

4.  **Experiments**: An Experiment in RHOAI is a logical grouping of multiple
    pipeline runs that share a common objective or context. For example, you might
    create an experiment to test different hyperparameter configurations, preprocessing
    strategies, or model architectures for the same dataset.

5. **Distributed workloads**: Distributed workloads help teams accelerate data
    processing and the full ML lifecycle-training, tuning, and serving - by prioritizing
    and distributing jobs for optimal node utilization. Advanced GPU support ensures
    the performance and scalability required for foundation-model workloads.

6.  **Applications**:

    -   _Enabled_: Launch your enabled applications, view documentation, or get
        started with quick start instructions and tasks.

    -   _Explore_: View optional applications for your RHOAI instance.

    !!! warning "Important Note"

        Most of Applications are **disabled by default** on NERC RHOAI right now.

7.  **Resources**: Access all learning resources that Resources showcases various
    tutorials or demos helping your onboarding to the RHOAI platform.

---
