# Billing Frequently Asked Questions (FAQs)

Our primary focus is to deliver outstanding on-prem cloud services, prioritizing
reliability, security, and cutting-edge solutions to meet your research and teaching
requirements. To achieve this, we have implemented a cost-effective pricing model
that enables us to maintain, enhance, and sustain the quality of our services. By
adopting consistent cost structures across all institutions, we can make strategic
investments in infrastructure, expand our service portfolio, and enhance our
support capabilities for a seamless user experience.

Most of the institutions using our services have an **MOU (Memorandum Of Understanding)**
with us to be better aligned to a number of research regulations, policies and
requirements but if your institution does not have an MOU with us, please have
someone from your faculty or administration contact us to discuss it soon by emailing
us at [help@nerc.mghpcc.org](mailto:help@nerc.mghpcc.org?subject=NERC%20MOU%20Question)
or, by submitting a new ticket at [the NERC's Support Ticketing System](https://mghpcc.supportsystem.com/open.php).

## Questions & Answers

???+ question "1. As a new NERC PI for the first time, am I entitled to any credits?"

    - Yes, you will receive up to **$1000 of credit** for **the first month only**.

    - This credit is **not transferable** to **subsequent months**.

    - This **does not apply** to the usage of **GPU resources**.

??? question "2. How often will I be billed?"

    You or your institution will be billed monthly within the first week of each
    month.

??? question "3. If I have an issue with my bill, who do I contact?"

    Please send your requests by emailing us at
    [help@nerc.mghpcc.org](mailto:help@nerc.mghpcc.org?subject=NERC%20Billing%20Question)
    or, by submitting a new ticket at [the NERC's Support Ticketing System](https://mghpcc.supportsystem.com/open.php).

??? question "4. How do I control costs?"

    Upon creating a project, you will set these resource limits (quotas) for
    OpenStack (VMs), OpenShift (containers), and storage through
    [ColdFront](../allocation/requesting-an-allocation.md). This is the maximum
    amount of resources you can consume at one time.

??? question "5. Are we invoicing for CPUs/GPUs only when the VM or Pod is active?"

    Yes. You will only be billed based on your utilization (cores, memory, GPU)
    when VMs exist (**even if they are Stopped!**) or when pods are running.
    Utilization will be translated into billable [Service Units (SUs)](how-pricing-works.md#service-units-sus).

    **Persistent storage** related to an OpenStack VM or OpenShift Pod will continue
    to be billed even when the **VM is stopped** or the **Pod is not running**.

??? question "6. Am I going to incur costs for allocations after end date?"

    Currently, a project will continue be able to utilize allocations even after
    their "End Date", resulting in ongoing **costs** for you. Such allocations
    will be marked as "**Active (Needs Renewal)**". In the future, we plan to change
    this behavior so that allocations after end date will prevent associated
    VMs/pods from starting and may cause active VMs/pods to cease running.

??? question "7. Are VMs invoiced even when shut down?"

    Yes, VMs continue to incur charges as long as they are consuming resources.
    To avoid being billed, you can either **[shelve](../../get-started/cost-billing/how-pricing-works.md#nerc-openstack)**
    or **[delete](../../openstack/management/vm-management.md#delete-instance)** the instance/VM.

    If you choose to delete the VM, it's a good idea to [create a snapshot](../../openstack/management/vm-management.md#create-snapshot)
    beforehand to preserve your data and configuration.

??? question "8. What actions can I take to reduce usage and therefore cost?"

    For step-by-step instructions, please refer to [this detailed guide](../cost-billing/how-pricing-works.md#su-conservation-how-to-save-cost)
    and keep in mind that storage is billed by requested amount not used amount.

??? question "9. Is storage charged separately?"

    Yes, but on the same invoice. To learn more, see [our page on Storage](how-pricing-works.md#storage).

    **Very Important:** Be sure to adjust your approved storage quotas accordingly
    to avoid unnecessary charges for unused or unneeded storage.

??? question "10. Will OpenStack & OpenShift show on a single invoice?"

    Yes. In the near future customers of NERC will be able to view per project service
    utilization via the XDMoD tool.

??? question "11. What happens when a Flavor is expanded during the month?"

    a. Flavors cannot be expanded.

    b. You can create a snapshot of an existing VM/Instance and, with that snapshot,
    deploy a new flavor of VM/Instance.

??? question "12. Will I be charged for storage attached to shut-off instances?"

    Yes.

??? question "13. Are we Invoicing Storage using ColdFront Requests or resource usage?"

    a. Storage is invoiced based on [Coldfront Requests](../allocation/requesting-an-allocation.md).

    b. When you request additional storage through Coldfront, invoicing on that
    additional storage will occur when your request is fulfilled. When you request
    a decrease in storage through
    [Request change using ColdFront](../allocation/allocation-change-request.md),
    your invoicing will adjust accordingly when your request is made. In both cases
    'invoicing' means 'accumulate hours for whatever storage quantity was added
    or removed'.

    For example:

    1. I request an increase in storage, the request is approved and processed.
        - At this point we start Invoicing.

    2. I request a decrease in storage.
        - The invoicing for that storage stops immediately.

??? question "14. For OpenShift, what values are we using to track CPU & Memory?"

    a. For invoicing we utilize `requests.cpu` for tracking CPU utilization &
    `requests.memory` for tracking memory utilization.

    b. Utilization will be capped based on the limits you set in ColdFront for
    your resource allocations.

??? question "15. If a single Pod exceeds the resources for a GPU SU, how is it invoiced?"

    It will be invoiced as 2 or more GPU SU's depending on how many multiples of
    the resources it exceeds.

??? question "16. How often will we change the pricing?"

    a. Our current plan is no more than once a year for existing offerings.

    b. Additional offerings may be added throughout the year (i.e. new types of
    hardware or storage).

??? question "17. Is there any NERC Pricing Calculator?"

    Yes. Start your estimate with no commitment based on your resource needs by
    using [this online tool](https://docs.google.com/spreadsheets/d/187bQgz3eB3W9OL7x9rrgaJ2pi7u85xMJvUJbnKzzBQM/edit#gid=0). For more information about how to use this tool, see
    [How to use the NERC Pricing Calculator](nerc-pricing-calculator.md).

---
