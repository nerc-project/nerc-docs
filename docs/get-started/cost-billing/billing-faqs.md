# Billing Frequently Asked Questions (FAQs)

Our primary focus is to deliver outstanding on-prem cloud services, prioritizing
reliability, security, and cutting-edge solutions to meet your research and teaching
requirements. To achieve this, we have implemented a cost-effective pricing model
that enables us to maintain, enhance, and sustain the quality of our services. By
adopting consistent cost structures across all institutions, we can make strategic
investments in infrastructure, expand our service portfolio, and enhance our
support capabilities for a seamless user experience.

Most of the institutions using our services have an **MoU (Memorandum of Understanding)**
with us to be better aligned to a number of research regulations, policies and
requirements but if your institution does not have an MoU with us, please have
someone from your faculty or administration contact us to discuss it soon by emailing
us at [help@nerc.mghpcc.org](mailto:help@nerc.mghpcc.org?subject=NERC%20MOU%20Question)
or, by submitting a new ticket at [the NERC’s Support Ticketing System (osTicket)](https://mghpcc.supportsystem.com/open.php).

## Questions & Answers

???+ question "1. How often will I be billed?"

    You or your institution will be billed monthly within the first week of each
    month.

??? question "2. If I have an issue with my bill, who do I contact?"

    Please send your requests by emailing us at
    [help@nerc.mghpcc.org](mailto:help@nerc.mghpcc.org?subject=NERC%20MOU%20Question)
    or, by submitting a new ticket at [the NERC’s Support Ticketing System (osTicket)](https://mghpcc.supportsystem.com/open.php).

??? question "3. How do I control costs?"

    Upon creating a project, you will set these resource limits (quotas) for
    OpenStack (VMs),OpenShift (containers), and storage.  This is the maximum
    amount of resources you can consume at one time.

??? question "4. Are we only invoicing when the OpenStack VM/ OpenShift Pod is on?"

    Yes. You will only be billed for utilization (cores x memory) which equates
    to a [service unit](how-pricing-works.md#service-units-su).

??? question "5.  Will OpenStack & OpenShift show on a single invoice?"

    Yes. In the near future customers of NERC will be able to view per project service
    utilization via the XDMoD tool.

??? question "6. What happens when a Flavor is expanded during the month?"

    a. Flavors cannot be expanded

    b. You can create snapshot and a new VM/Instance with that snapshot but that
    will be a new instance with a new flavor

??? question "7. Is storage charged separately?"

    Yes, but on the same invoice. To know [more about Storage](how-pricing-works.md#storage).

??? question "8. Do we charge for storage attached to shut off instances?"

    Yes

??? question "9. Are we Invoicing Storage using ColdFront Requests or resource usage?"

    a. Coldfront Requests

    b. We would invoice for increases when requests are fulfilled and for decreases
    when requests are placed, where “invoice” means “accumulate hours for whatever
    storage quantity was added or removed..”

    For example:

        1. I request an increase in storage, the request is approved and processed.
        At this point we start Invoicing.

        2. I request a decrease in storage. The Invoicing for that storage stops,
        then at some point the request is processed.

??? question "10. For OpenShift what value are we using to track CPU & Memory?"

    a. `requests.cpu` & `requests.memory`

        i. ColdFront sets `limits.cpu`` and memory which is the most you can use

??? question "11. If a single Pod exceeds the resources for a GPU SU how is it invoiced?"

    a. It will be invoiced as 2 or more GPU SU depending on how many multiples of
    the resources it exceeds.

??? question "12. How often will we change the pricing?"

    a. Current plan is no more than once a year

    b. Additional types of offering may be more frequent - eg. new types of hardware
    or storage types.

---
