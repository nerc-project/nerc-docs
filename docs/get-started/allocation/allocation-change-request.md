# Request change to Resource Allocation to an existing project

If past resource allocation is not sufficient for an existing project, PIs or project
managers can request a change by clicking "Request Change" button on project
resource allocation detail page as show below:

![Request Change Resource Allocation](images/coldfront-request-change-allocation.png)

## Request Change Resource Allocation Attributes for OpenStack Project

This will bring up the detailed Quota attributes for that project as shown below:

![Request Change Resource Allocation Attributes for OpenStack Project](images/coldfront-openstack-allocation-attributes.png)

!!! warning "Important: Requested/Approved Allocated OpenStack Storage Quota & Cost"
    For **NERC (OpenStack)** resource types, the **Storage quotas** are controlled
    by the values of the "OpenStack Volume Quota (GiB)" and "OpenStack Swift Quota
    (GiB)" quota attributes. The **Storage cost** is determined by [your requested
    and approved allocation values](allocation-details.md#pi-and-manager-allocation-view-of-openstack-resource-allocation)
    for these quota attributes. If you have common questions or need more information,
    refer to our [Billing FAQs](../../get-started/cost-billing/billing-faqs.md)
    for comprehensive answers.

PI or project managers can provide a new value for the individual quota attributes,
and give justification for the requested changes so that the NERC admin can review
the change request and approve or deny based on justification and quota change request.
Then submitting the change request, this will notify the NERC admin about it. Please
wait untill the NERC admin approves/ deny the change request to see the change on
your resource allocation for the selected project.

!!! info "Information"
    PI or project managers can put the new values on the textboxes for **ONLY**
    quota attributes they want to change others they can be left **blank** so those
    quotas will not get changed!

### Allocation Change Requests for OpenStack Project

Once the request is processed by the NERC admin, any user can view that request
change trails for the project by looking at the "Allocation Change Requests"
section that looks like below:

![Allocation Change Requests for OpenStack Project](images/coldfront-openstack-allocation-change-requests.png)

Any user can click on Action button to view the details about the change request.
This will show more details about the change request as shown below:

![Allocation Change Request Details for OpenStack Project](images/coldfront-openstack-change-requested-details.png)

## Request Change Resource Allocation Attributes for OpenShift Project

![Request Change Resource Allocation Attributes for OpenShift Project](images/coldfront-openshift-allocation-attributes.png)

!!! warning "Important: Requested/Approved Allocated OpenShift Storage Quota & Cost"
    For **NERC-OCP (OpenShift)** resource types, the **Storage quotas** are controlled
    by the values of the "OpenShift Request on Storage Quota (GiB)" and "OpenShift
    Limit on Ephemeral Storage Quota (GiB)" quota attributes. The **Storage cost**
    is determined by [your requested and approved allocation values](allocation-details.md#pi-and-manager-allocation-view-of-openshift-resource-allocation)
    for these quota attributes.

PI or project managers can provide a new value for the individual quota attributes,
and give justification for the requested changes so that the NERC admin can review
the change request and approve or deny based on justification and quota change request.
Then submitting the change request, this will notify the NERC admin about it. Please
wait untill the NERC admin approves/ deny the change request to see the change on
your resource allocation for the selected project.

!!! info "Information"
    PI or project managers can put the new values on the textboxes for **ONLY**
    quota attributes they want to change others they can be left **blank** so those
    quotas will not get changed!

### Allocation Change Requests for OpenShift Project

Once the request is processed by the NERC admin, any user can view that request
change trails for the project by looking at the "Allocation Change Requests"
section that looks like below:

![Allocation Change Requests for OpenShift Project](images/coldfront-openshift-allocation-change-requests.png)

Any user can click on Action button to view the details about the change request.
This will show more details about the change request as shown below:

![Allocation Change Request Details for OpenShift Project](images/coldfront-openshift-change-requested-details.png)

---
