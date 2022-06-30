# What is NERC's ColdFront?

NERC uses [NERC’s ColdFront interface](https://coldfront.mss.mghpcc.org/), an
open source resource allocation management system called
[ColdFront](https://github.com/ubccr/coldfront) to provide a single point-of-entry
for administration, reporting, and measuring scientific impact of NERC resources
for PI.

## How to get access to NERC's ColdFront

General Users who are not PIs or Managers on a project see a read-only view of the
NERC's ColdFront.

Whereas, once a PI Account request is granted, the PI will receive an email confirming
the request approval and how to connect NERC’s ColdFront.

PI or project managers can use NERC's ColdFront as a self-service web-portal to do
the following tasks:

- Add or manage or archive projects

- Request allocations that fall under projects to NERC’s resources such as clusters,
cloud resources, servers, storage, and software licenses

- Add/remove user access to/from allocated resources who is a member of the project
without requiring system administrator interaction

- Elevate selected users to 'manager' status, allowing them to handle some of the
PI asks such as request new resource allocations, add/remove users to/from resource
allocations, add project data such as grants and publications

- Monitor resource utilization such as storage and cloud usage

- Receive email notifications for expiring/renewing access to resources as well as
notifications when allocations change status - i.e. activated, expired, denied

- Provide information such as grants, publications, and other reportable data for
periodic review by center director to demonstrate need for the resources

## What PIs need to fill in order to request a Project?

Once logged in to NERC’s ColdFront, PIs can choose Projects sub-menu located under
the Project menu.

![Project](images/coldfront-project.png)

On clicking the "Add a project" button will show interface like below:

![Add A Project](images/coldfront-add-a-project.png)

PIs need to specify appropriate title, description of their research work that you
will accomplish at NERC in one to two paragraphs and Field of science or research
domain and then click the "Save" button. Once saved successfully, PIs effectively
become the "manager" of the project, and are free to add or remove users and also
request resource allocation(s) to any Projects for which they are the PI. PIs are
permitted to add users to their group, request new allocations, renew expiring
allocations, and provide information such as publications and grant data. PIs can
maintain all their research information under one project or if they require they
can separate the work into multiple projects.

![Request A New Allocation](images/coldfront-request-new-allocation.png)

!!! warning "Very Important"
    Make sure to select **NERC (OpenStack)** on Resource option and specify
    your expected Units of computing. Be mindful, you can extend your current resource
    allocations on your current project later on.

## Resource Allocation Quotas

The amount of quota to start out a resource allocation after approval, can be
specified using an integer field in the resource allocation request form as shown
above. The provided unit value is computed as PI or project managers request
resource quota. The basic unit of computational resources is defined in terms of
integer value that corresponds to multiple openstack resource quotas. For example,
1 Unit corresponds to:

| Resource Name         | Quota Amount x Unit                   |
| :-------------------: | :-----------------------------------: |
| `Instances`           | 1                                     |
| `vCPUs`               | 2                                     |
| `GPU`                 | 0                                     |
| `RAM`                 | 4096                                  |
| `Volumes`             | 2                                     |
| `Volume Storage(GB)`  | 100                                   |
| `Object Storage(GB)`  | 1                                     |

!!! info "Information"
    By default, **2 OpenStack Floating IPs**, **10 Volume Snapshots** and **10 Security
    Groups** are provided to each approved projects regardless of units of requested
    quota units.

## Adding and removing User from the Project

A user can only view projects they are on. PIs or managers can add or remove users
from their respective projects by navigating to the Users section of the project.

![Add/Remove Users from Project](images/coldfront-add-remove-users.png)

Once we click on the "Add Users" button, it will shows the following search interface:

![User Search Interface](images/coldfront-user-search.png)

They can search for any users in the system that are not already part of the project
by providing exact matched username or partial text of other multiple fields. The
search results show details about the user account such as email address, username,
first name, last name etc. as shown below:

![Add User(s) To Project](images/coldfront-add-user-to-project.png)

Thus, found user(s) can be selected and assigned directly to the available resource
allocation(s) on the given project using this interface. While adding the users,
their Role also can be selected from the dropdown options as either User or Manager.
Once confirmed with selection of user(s) their roles and allocations, click on the
"Add Selected Users to Project" button.

Removing Users from the Project is straightforward by just clicking on the
"Remove Users" button. Then it shows the following interface:

![Remove User(s) From A Project](images/coldfront-remove-users-from-a-project.png)

PI or project managers can select the user(s) and then click on the "Remove Selected
Users From Project" button.

## User Roles

Access to ColdFront is role based so users see a read-only view of the allocation
details for any allocations they are on. PIs see the same allocation details as general
users and can also add project users to the allocation if they're not already on
it. Even on the first time, PIs add any user to the project as the User role. Later
PI or project managers can upgrade users on their project to the 'manager' role.
This allows multiple managers on the same project. This provides the user with the
same access and abilities as the PI. The only things a PI can do that a manager can't,
is create a new project or archive a project. All other project related tasks that
a PI can do, a manager on that project can accomplish as well.

General User Accounts are not able to create/update projects and request Resource
Allocations. Instead, these accounts must be associated with a Project that has
Resources. General User accounts that are associated with a Project have access
to view their project details and use all the resources associated with the Project
on NERC.

General Users (not PIs or Managers) can turn off email notifications at the project
level. PIs also have the 'manager' status on a project. Managers can't turn off their
notifications. This ensures they continue to get allocation expiration notification
emails.

## Adding User to Manager Role

To change a user's role to 'manager' click on the edit icon next to the user's name
on the Project Detail page:

![Change User Role](images/coldfront-change-user-role.png)

Then toggle the "Role" from User to Manager:

![User Details](images/coldfront-user-details.png)

!!! warning "Very Important"
    Make sure to click the "Update" button to save the change.

## PI and Manager Allocation View

PIs and managers can view important details of the allocation including start and
end dates, creation and last modified dates, users on the allocation and public
allocation attributes. PIs and managers can add or remove users from allocations.

![PI and Manager Allocation View](images/coldfront-pi-manager-view.png)

## Adding and removing project Users to project Resource Allocation

Any available users on a given project can be added to resource allocation by
clicking on the "Add Users" button as shown below:

![Adding and removing project User(s) to project Allocation](images/coldfront-pi-add-users-on-allocation.png)

Once Clicked it will show the following interface where PIs can select the available
user(s) on the checkboxes and click on the "Add Selected Users to Allocation" button.

![Add Selected User(s) to Allocation](images/coldfront-add-users-to-allocation.png)

!!! warning "Very Important"
    The desired user must already be on the project to be added to the allocation.

Removing Users from the Resource Allocation is straightforward by just clicking on
the "Remove Users" button. Then it shows the following interface:

![Removing User(s) from the Resource Allocation](images/coldfront-remove-users-from-allocation.png)

PI or project managers can select the user(s) on the checkboxes and then click on
the "Remove Selected Users From Project" button.

## Request change to Resource Allocation to an existing project

If past resource allocation is not sufficient for an existing project, PIs or project
managers can request for change by clicking "Request Change" button on project
resource allocation detail page as show below:

![Request Change Resource Allocation](images/coldfront-request-change-allocation.png)

This will bring up the detailed Quota attributes for that project as shown below:

![Request Change Resource Allocation Attributes](images/coldfront-allocation-attributes.png)

PI or project managers can provide a new value for the individual quota attributes,
and give justification for the requested changes so that the NERC admin can review
the change request and approve or deny based on justification and quota change request.
Then submitting the change request, this will notify the NERC admin about it. Please
wait untill the NERC admin approves/ deny the change request to see the change on
your resource allocation for the selected project.

!!! info "Information"
    PI or project managers can put the new values on the textboxes for **ONLY** quota
    attributes they want to change others they can **left blank** so that will not
    get changed!

Once the request is processed by the NERC admin, any user can view that request change
trails for the project by looking at the "Allocation Change Requests" section that
looks like below:

![Allocation Change Requests](images/coldfront-allocation-change-requests.png)

Any user can click on Action button to view the details about the change request.
This will shows more details about the change request like below:

![Allocation Change Requeste Details](images/coldfront-change-requested-details.png)

## Adding a new Resource Allocation to the project

If one resource allocation is not sufficient for a project, PI or project managers
can request for another allocation(s) by clicking on the "Request Resource Allocation"
button on the Allocations section of the project details. This will show the page
where all existing users for the project will be listed on the bottom of the request
form. PIs can select all or only desired user(s) to request the resource allocations
to be available on NERC’s OpenStack.

![Adding a new Resource Allocation to the project](images/coldfront-request-a-new-allocation.png)

## General User View

General Users who are not PIs or Managers on a project see a read-only view of the
allocation details. If a user is on a project but not a particular allocation, they
will not be able to see the allocation in the Project view nor will they be able
to access the Allocation detail page.

![General User View](images/coldfront-general-user-view.png)
