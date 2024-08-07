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

1.  Each Harvard PI must have a HUIT billing account linked to their NetID (abc123),
    and NERC requires a HUIT "**Customer Code**" for billing purposes. To create
    a HUIT billing account, [sign up here](https://billing.huit.harvard.edu/portal/allusers/newcustomer)
    with your HarvardKey. The PI's submission of the corresponding HUIT
    "**Customer Code**" is now seamlessly integrated into the PI user account role
    submission process. This means that PIs can provide the corresponding HUIT
    "**Customer Code**" either while submitting [NERC's PI Request Form](https://nerc.mghpcc.org/pi-account-request/)
    or by submitting a new ticket at [NERC's Support Ticketing System](https://mghpcc.supportsystem.com/open.php)
    under the "NERC PI Account Request" option in the **Help Topic** dropdown menu.

    !!! abstract "What if you already have an existing Customer Code?"

         Please note that if you already have an existing active NERC account, you
         need to provide your HUIT Customer Code to NERC. If you think your department
         may already have a HUIT account but you don’t know the corresponding Customer
         Code then you can [contact HUIT Billing](https://billing.huit.harvard.edu/portal/allusers/contactus)
         to get the required Customer Code.

2.  During the Resource Allocation review and approval process, we will utilize the
    HUIT "Customer Code" provided by the PI in step #1 to align it with the approved
    allocation. Before confirming the mapping of the Customer Code to the Resource
    Allocation, we will send an email to the PI to confirm its accuracy and then
    approve the requested allocation. Subsequently, after the allocation is approved,
    we will request the PI to initiate a [change request](../allocation/allocation-change-request.md)
    to input the correct "Customer Code" into the allocation's "Institution-Specific
    Code" attribute's value.

    !!! danger "Very Important Note"

        We recommend keeping your "**Institution-Specific Code**" updated at all
        times, ensuring it accurately reflects your current and valid **Customer
        Code**. The PI or project manager(s) have the authority to request changes
        for updating the "Institution-Specific Code" attribute for each resource
        allocation. They can do so by submitting a Change Request as [outlined here](../allocation/allocation-change-request.md).

        !!! info "How to view Project Name, Project ID & Institution-Specific Code?"

            By clicking on the Allocation detail page through ColdFront, you can access
            information about the allocation of each resource, including OpenStack and
            OpenShift as [described here](../allocation/allocation-details.md#general-user-view).
            You can review and verify **Allocated Project Name**, **Allocated Project
            ID** and **Institution-Specific Code** attributes, which are located under
            the "Allocation Attributes" section on the detail page as
            [described here](../allocation/allocation-details.md#pi-and-manager-view).

    Once we confirm the six-digit HUIT Customer Code for the PI and the correct
    resource allocation, the NERC admin team will initiate the creation of a new
    ServiceNow ticket. This will be done by reaching out to
    [HUIT Billing](https://billing.huit.harvard.edu/portal/allusers/contactus)
    or directly emailing HUIT Billing at [huit-billing@harvard.edu](mailto:huit-billing@harvard.edu?subject=HUIT%20Customer%20Code%For%20NERC)
    for the approved and active allocation request.

    In this email, the NERC admin needs to specify the **Allocated Project ID**,
    **Allocated Project Name**, **Customer Code**, and **PI's Email address**.
    Then, the HUIT billing team will generate a unique **Asset ID** to be utilized
    by the Customer's HUIT billing portal.

    !!! info "Important Information regarding HUIT Billing SLA"

        Please note that we will require the PI or Manager(s) to repeat step #2
        for any new resource allocation(s) as well as renewed allocation(s).
        Additionally, the HUIT Billing SLA for new Cloud Billing assets is **2
        business days**, although most requests are typically completed within
        8 hours.

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
