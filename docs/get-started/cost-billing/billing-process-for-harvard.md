# Billing Process for Harvard University

Direct Billing for NERC is a convenience service for Harvard Faculty and Departments.
HUIT will pay the monthly invoices and then allocate the monthly usage costs on
the Harvard University General Ledger. This follows a similar pattern with how
other Public Cloud Providers (AWS, Azure, GCP) accounts are billed and leverage
the HUIT Central Billing [Portal](https://billing.huit.harvard.edu/). Your HUIT
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
with your HarvardKey.

    !!! abstract "What if you already have an existing Customer Code?"
        *Please note that if you already have an existing active NERC account, you
        need to provide your HUIT Customer Code to NERC. If you think your department
        may already have a HUIT account but you don’t know the corresponding Customer
        Code then you can [contact HUIT Billing](https://billing.huit.harvard.edu/portal/allusers/contactus)
        to get the required Customer Code.*

2. Provide NERC your six-digit HUIT “Customer Code” via
[help@nerc.mghpcc.org](mailto:help@nerc.mghpcc.org?subject=NERC%20HUIT%20Customer%20Code%Details)
and specify which OpenShift or OpenStack project allocation this is for.

    !!! info "How to get the Allocated Project Name and Allocated Project ID?"
        By clicking on the Allocation detail page through ColdFront, you can access
        information about the allocation of each resource, including OpenStack and
        OpenShift as described [here](../get-an-allocation.md#general-user-view).
        You will need to provide us **Allocated Project Name** and **Allocated Project
        ID** attributes, which are located under the “Allocation Attributes”
        section on the detail page as described [here](../get-an-allocation.md#pi-and-manager-allocation-view).

    Once NERC has receive the six-digit HUIT Customer Code for the PI, the NERC
    admin team will create a new ServiceNow ticket by contacting
    [HUIT Billing](https://billing.huit.harvard.edu/portal/allusers/contactus)
    or by emailing HUIT Billing directly at
    [huit-billing@harvard.edu](mailto:huit-billing@harvard.edu?subject=HUIT%20Customer%20Code%For%20NERC)
    for all approved and active allocation requests. In this email, NERC admin
    needs to specify the Customer Code and Unique Project Allocation Name. This
    will be mapped to a unique Asset ID in the HUIT billing portal.

    !!! danger "Harvard University Security Policy Information"
        *Please note that all assets deployed to your NERC project must be compliant
        with University Security policies. Please familiarize yourself with the
        [Harvard University Information Security Policy](https://policy.security.harvard.edu/)
        and your role in securing data. If you have any questions about how Security
        should be implemented in the Cloud, please contact your school security
        officer: ["Havard Security Officer"](https://security.harvard.edu/).*

---
