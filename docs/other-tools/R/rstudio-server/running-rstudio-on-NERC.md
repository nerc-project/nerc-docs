# Running RStudio Server on NERC

## Running RStudio Server on NERC OpenShift

In [this guide](../../../openshift/applications/creating-your-own-developer-catalog-service.md),
we walk through the process of creating a simple RStudio Web Server using an
OpenShift Template, which bundles all the necessary resources required to run it,
such as ConfigMap, Pod, Route, Service, etc., and then initiate and deploy the
RStudio server from that template.

To get started, clone the repository by running:

```bash
git clone https://github.com/nerc-project/rstudio-testapp.git
```

After that, follow the steps outlined in [that guide](../../../openshift/applications/creating-your-own-developer-catalog-service.md).
At the end, you will be able to view the RStudio Web Server interface!

![RStudio Server](images/rstudio-server.png)

---
