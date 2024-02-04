# Billing Process for Harvard University

Direct Billing for NERC is a convenience service for Harvard Faculty and Departments.
HUIT will pay the monthly invoices and then allocate the monthly usage costs on
the Harvard University General Ledger. This follows a similar pattern with how
other Public Cloud Providers (AWS, Azure, GCP) accounts are billed and leverage
the [HUIT Central Billing Portal](https://billing.huit.harvard.edu/). Your HUIT
Customer Code will be matched to your NERC Project Allocation Name as a Billing
Asset. In this process you will be asked for your GL billing code, which you can
change as needed per project. Please be cognizant that only a single billing code
is allowed per billing asset. Therefore, if you have multiple projects with different
funds, if you are able, please create a separate project for each fund. Otherwise,
you will need to take care of this with internal journals inside of your department
or lab. During each monthly billing cycle, the NERC team will upload the billing
Comma-separated values (CSV) files to the HUIT Central Billing system accessible
AWS Object Storage (S3) bucket. The HUIT Central Billing system ingests billing
data files provided by NERC, maps the usage costs to HUIT Billing customers
(and GL Codes) and then includes those amounts in HUIT Monthly Billing of all
customers. This is an automated process.

Please follow these two steps to ensure proper billing setup:

1. Each Harvard PI must have a HUIT billing account linked to their NetID (abc123).
NERC must have HUIT “Customer Code” for billing purposes. To create a HUIT billing
account, sign up [here](https://billing.huit.harvard.edu/portal/allusers/newcustomer)
with your HarvardKey. This is already now part of PI user account role submission
process that means PI can provide corresponding HUIT “**Customer Code**” while
submitting [NERC's PI Request Form](https://nerc.mghpcc.org/pi-account-request/)
or by submitting a new ticket at
[the NERC's Support Ticketing System](https://mghpcc.supportsystem.com/open.php)
under "**NERC PI Account Request**" option on **Help Topic** dropdown list.

    !!! abstract "What if you already have an existing Customer Code?"
        *Please note that if you already have an existing active NERC account, you
        need to provide your HUIT Customer Code to NERC. If you think your department
        may already have a HUIT account but you don’t know the corresponding Customer
        Code then you can [contact HUIT Billing](https://billing.huit.harvard.edu/portal/allusers/contactus)
        to get the required Customer Code.*

2. During Resource Allocation review and approval process, we will use the HUIT
"Customer Code" provided by the PI during step #1 to map to each approved allocations.
Before mapping this Customer Code to Resource Allocation, we will send out an email
to confirm with the PI or Manager(s). Additionally, there is an option for you to
provide a new **33-digit GL Code** if you wish to override your **default GL code**,
which may differ from the default GL code previously associated with the
**Customer Code**.

    !!! info "How to view the Allocated Project Name and Allocated Project ID?"
        By clicking on the Allocation detail page through ColdFront, you can access
        information about the allocation of each resource, including OpenStack and
        OpenShift as described [here](../get-an-allocation.md#general-user-view).
        You will need to provide us **Allocated Project Name** and **Allocated Project
        ID** attributes, which are located under the “Allocation Attributes”
        section on the detail page as described [here](../get-an-allocation.md#pi-and-manager-allocation-view).

    Once we confirm the six-digit HUIT Customer Code for the PI and correct resource
    allocation, the NERC admin team will create a new ServiceNow ticket by contacting
    [HUIT Billing](https://billing.huit.harvard.edu/portal/allusers/contactus)
    or by emailing HUIT Billing directly at
    [huit-billing@harvard.edu](mailto:huit-billing@harvard.edu?subject=HUIT%20Customer%20Code%For%20NERC)
    for all approved and active allocation requests. In this email, NERC admin
    needs to specify the Customer Code and Unique Project Allocation Name. This
    will be mapped to a unique Asset ID in the HUIT billing portal.

    !!! info "Important Information regarding HUIT Billing SLA"
        Please Note, we will need PI or Manger(s) to repeat step #2 for any new
        resource allocation(s) as well as renewed allocation(s). Also, HUIT Billing
        SLA for new Cloud Billing asset is **2 business days**- although most requests
        are typically completed within 8 hours.

    !!! danger "Harvard University Security Policy Information"
        *Please note that all assets deployed to your NERC project must be compliant
        with University Security policies as described
        [here](../best-practices/best-practices-for-harvard.md). Please familiarize
        yourself with the
        [Harvard University Information Security Policy](https://policy.security.harvard.edu/)
        and your role in securing data. If you have any questions about how Security
        should be implemented in the Cloud, please contact your school security
        officer: ["Havard Security Officer"](https://security.harvard.edu/).*

---
