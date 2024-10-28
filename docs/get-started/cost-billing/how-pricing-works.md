# How does NERC pricing work?

!!! question "As a new PI using NERC for the first time, am I entitled to any credits?"

    As a **new PI** using NERC for the first time, you might wonder if you get any
    credits. Yes, you'll receive up to **$1000** for **the first month only**. But
    remember, this credit **can not** be used in **the following months**. Also,
    it **does not apply** to **GPU resource usage**.

NERC offers you a **pay-as-you-go** approach for pricing for our cloud infrastructure
offerings (Tiers of Service), including Infrastructure-as-a-Service (IaaS) – Red
Hat OpenStack and Platform-as-a-Service (PaaS) – Red Hat OpenShift. The exception
is the **Storage quotas** in NERC Storage Tiers, where the cost is determined by
[your requested and approved allocation values](../allocation/allocation-details.md#pi-and-manager-view)
to reserve storage from the total NESE storage pool. For **NERC (OpenStack)**
Resource Allocations, storage quotas are specified by the "OpenStack Volume Quota
(GiB)" and "OpenStack Swift Quota (GiB)" allocation attributes. Whereas for
**NERC-OCP (OpenShift)** Resource Allocations, storage quotas are specified by the
"OpenShift Request on Storage Quota (GiB)" and "OpenShift Limit on Ephemeral Storage
Quota (GiB)" allocation attributes. If you have common questions or need more
information, refer to our [Billing FAQs](billing-faqs.md) for comprehensive answers.
NERC offers a flexible cost model where an institution (with a per-project breakdown)
is billed solely for the duration of the specific services required. Access is based
on project-approved resource quotas, eliminating runaway usage and charges. There
are no obligations of long-term contracts or complicated licensing agreements.
Each institution will enter a lightweight MOU with MGHPCC that defines the services
and billing model.

## Calculations

### Service Units (SUs)

| Name         | vGPU | vCPU | RAM (GiB) | Current Price |
| ------------ | ---- | ---- | --------- | ------------- |
| CPU          | 0    | 1    | 4         | $0.013        |
| A100 GPU     | 1    | 24   | 74        | $1.803        |
| A100sxm4 GPU | 1    | 32   | 240       | $2.078        |
| V100 GPU     | 1    | 48   | 192       | $1.214        |
| K80 GPU      | 1    | 6    | 28.5      | $0.463        |
| H100         | 1    | 64   | 384       | $6.04         |

## Breakdown

### CPU/GPU SUs

Service Units (SUs) can only be purchased as a whole unit. We will charge for
Pods (summed up by Project) and VMs on a per-hour basis for any portion of an
hour they are used, and any VM "flavor"/Pod reservation is charged as a multiplier
of the base SU for the maximum resource they reserve.

**GPU SU Example:**

-   A Project or VM with:

    `1 A100 GPU, 24 vCPUs, 95MiB RAM, 199.2hrs`

-   Will be charged:

    `1 A100 GPU SUs x 200hrs (199.2 rounded up) x $1.803`

    `$360.60`

**OpenStack CPU SU Example:**

-   A Project or VM with:

    `3 vCPU, 20 GiB RAM, 720hrs (24hr x 30days)`

-   Will be charged:

    `5 CPU SUs due to the extra RAM (20GiB vs. 12GiB(3 x 4GiB)) x 720hrs x $0.013`

    `$46.80`

!!! warning "Are VMs invoiced even when shut down?"

    Yes, VMs are invoiced as long as they are utilizing resources. In order not
    to be billed for a VM, you **[must delete](../../openstack/management/vm-management.md#delete-instance)**
    your Instance/VM. It is advisable to [create a snapshot](../../openstack/management/vm-management.md#create-snapshot)
    of your VM prior to deleting it, ensuring you have a backup of your data and
    configurations. By proactively managing your VMs and resources, you can
    optimize your usage and minimize unnecessary costs.

    If you have common questions or need more information, refer to our
    [Billing FAQs](../../get-started/cost-billing/billing-faqs.md) for comprehensive
    answers.

**OpenShift CPU SU Example:**

-   Project with 3 Pods with:

    i. `1 vCPU, 3 GiB RAM, 720hrs (24hr*30days)`

    ii. `0.1 vCPU, 8 GiB RAM, 720hrs (24hr*30days)`

    iii. `2 vCPU, 4 GiB RAM, 720hrs (24hr*30days)`

-   Project Will be charged:

    `RoundUP(Sum(`

    `1 CPU SUs due to first pod * 720hrs * $0.013`

    `2 CPU SUs due to extra RAM (8GiB vs 0.4GiB(0.1*4GiB)) * 720hrs * $0.013`

    `2 CPU SUs due to more CPU (2vCPU vs 1vCPU(4GiB/4)) * 720hrs * $0.013`

    `))`

    `=RoundUP(Sum(720(1+2+2)))*0.013`

    `$46.80`

!!! note "How to calculate cost for all running OpenShift pods?"

    If you prefer a function for the OpenShift pods here it is:

    `Project SU HR count = RoundUP(SUM(Pod1 SU hour count + Pod2 SU hr count +
    ...))`

OpenShift Pods are summed up to the project level so that fractions of CPU/RAM
that some pods use will not get overcharged. There will be a split between CPU and
GPU pods, as GPU pods cannot currently share resources with CPU pods.

### Storage

Storage is charged separately at a rate of **$0.009 TiB/hr** or **$9.00E-6 GiB/hr**.
OpenStack volumes remain provisioned until they are deleted. VM's reserve
volumes, and you can also create extra volumes yourself. In OpenShift pods, storage
is only provisioned while it is active, and in persistent volumes, storage remains
provisioned until it is deleted.

!!! danger "Very Important: Requested/Approved Allocated Storage Quota and Cost"

    The **Storage cost** is determined by
    [your requested and approved allocation values](../allocation/allocation-details.md#pi-and-manager-view).
    Once approved, these **Storage quotas** will need to be reserved from the
    total NESE storage pool for both **NERC (OpenStack)** and **NERC-OCP (OpenShift)**
    resources. For **NERC (OpenStack)** Resource Allocations, storage quotas are
    specified by the "OpenStack Volume Quota (GiB)" and "OOpenStack Swift Quota
    (GiB)" allocation attributes. Whereas for **NERC-OCP (OpenShift)** Resource
    Allocations, storage quotas are specified by the "OpenShift Request on Storage
    Quota (GiB)" and "OpenShift Limit on Ephemeral Storage Quota (GiB)" allocation
    attributes.

    Even if you have deleted all volumes, snapshots, and object storage buckets and
    objects in your OpenStack and OpenShift projects. It is very essential to
    adjust the approved values for your NERC (OpenStack) and NERC-OCP (OpenShift)
    resource allocations to zero (0) otherwise you will still be incurring a charge
    for the approved storage as explained in [Billing FAQs](billing-faqs.md).

    Keep in mind that you can easily scale and expand your current resource
    allocations within your project. Follow [this guide](../allocation/allocation-change-request.md#request-change-resource-allocation-attributes-for-openstack-project)
    on how to use NERC's ColdFront to reduce your **Storage quotas** for NERC (OpenStack)
    allocations and [this guide](../allocation/allocation-change-request.md#request-change-resource-allocation-attributes-for-openshift-project)
    for NERC-OCP (OpenShift) allocations.

**Storage Example 1:**

-   Volume or VM with:

    `500GiB for 699.2hrs`

-   Will be charged:

    `.5 Storage TiB SU (.5 TiB x 700hrs) x $0.009 TiB/hr`

    `$3.15`

**Storage Example 2:**

-   Volume or VM with:

    `10TiB for 720hrs (24hr x 30days)`

-   Will be charged:

    `10 Storage TiB SU (10TiB x 720 hrs) x $0.009 TiB/hr`

    `$64.80`

Storage includes all types of storage Object, Block, Ephemeral & Image.

### High-Level Function

To provide a more practical way to calculate your usage, here is a function of
how the calculation works for OpenShift and OpenStack.

1.  **OpenStack** = (Resource (vCPU/RAM/vGPU) assigned to VM flavor converted to
    number of equivalent SUs) \* (time VM has been running), rounded up to a whole
    hour + Extra storage.

    !!! info "NERC's OpenStack Flavor List"

        You can find the most up-to-date information on the current NERC's OpenStack
        flavors with corresponding SUs by referring to [this page](../../openstack/create-and-connect-to-the-VM/flavors.md).

2.  **OpenShift** = (Resource (vCPU/RAM) requested by Pod converted to the number
    of SU) \* (time Pod was running), summed up to project level rounded up to the
    whole hour.

## How to Pay?

To ensure a comprehensive understanding of the billing process and payment options
for NERC offerings, we advise PIs/Managers to [visit individual pages designated
for each institution](billing-process-for-my-institution.md). These pages provide
detailed information specific to each organization's policies and procedures
regarding their billing. By exploring these dedicated pages, you can gain insights
into the preferred payment methods, invoicing cycles, breakdowns of cost components,
and any available discounts or offers. Understanding the institution's unique
approach to billing ensures accurate planning, effective financial management,
and a transparent relationship with us.

If you have any some common questions or need further information, see our
[Billing FAQs](billing-faqs.md) for comprehensive answers.

---
