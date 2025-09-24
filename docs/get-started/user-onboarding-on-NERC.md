# User Onboarding Process Overview

NERC's Research allocations are available to faculty members and researchers, including
postdoctoral researchers and students. In order to get access to resources provided
by NERC's computational infrastructure, you must first register and obtain a user
account.

<!-- markdownlint-disable -->
<iframe width="600" height="400" src="https://www.youtube.com/embed/d8_49bg27is?si=eZY-I9TSV8PnrHl2" title="User Onboarding Process Overview" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
<!-- markdownlint-enable -->

The overall user flow can be summarized using the following sequence diagram:

![NERC user flow](images/user-flow-NERC.png)

1. All users including PI need to register to NERC via: [https://regapp.mss.mghpcc.org/](https://regapp.mss.mghpcc.org/).

    For detailed instructions on creating a user account through **RegApp**, refer
    to [this guide](create-a-user-portal-account.md).

2. **PI** will send a request for a Principal Investigator (PI) user account role
    by submitting: [NERC's PI Request Form](https://nerc.mghpcc.org/pi-account-request/).

    **Alternatively,** users can request a Principal Investigator (PI) user account
    by submitting a new ticket at [the NERC's Support Ticketing System](https://mghpcc.supportsystem.com/open.php)
    under the "NERC PI Account Request" option in the **Help Topic** dropdown menu,
    as shown in the image below:

    ![the NERC's Support Ticketing System PI Ticket](images/osticket-pi-request.png)

    !!! question "Principal Investigator Eligibility Information"

        - MGHPCC consortium members, whereby they enter into an service agreement
        with MGHPCC for the NERC services.

        - Non-members of MGHPCC can also be PIs of NERC Services, but must also have an active non-member agreement with MGHPCC.

        - External research focused institutions will be considered on a case-by-case basis and are subject to an external customer cost structure.

3. Wait until the PI request gets approved by the **NERC's admin**.

4. Once a PI request is **approved**, **PI** can add a new project and also search
    and add user(s) to the project - Other **general user(s)** can also see the project(s)
    once they are added to a project via: [https://coldfront.mss.mghpcc.org](https://coldfront.mss.mghpcc.org/).

    For detailed instructions about **NERC's ColdFront** and how to use it, refer
    to [this guide](allocation/coldfront.md).

5. **PI or project Manager** can request resource allocation either **NERC (OpenStack)**,
    **NERC-OCP (OpenShift)** or **NERC-OCP-EDU (OpenShift)** for the newly added
    project and select which user(s) can use the requested allocation.

    !!! question "As a new NERC PI for the first time, am I entitled to any credits?"

        As a **new PI** using NERC for the first time, you might wonder if you get
        any credits. Yes, you'll receive up to **$1000** for **the first month only**.
        But remember, this credit **can not** be used in **the following months**.
        Also, it **does not apply** to **GPU resource usage**.

6. Wait until the requested resource allocation gets approved by the **NERC's admin**.

7. Once **approved**, **PI and the corresponding project users** can go to either
    NERC Openstack horizon web interface: [https://stack.nerc.mghpcc.org](https://stack.nerc.mghpcc.org),
    NERC OpenShift web console: [https://console.apps.shift.nerc.mghpcc.org](https://console.apps.shift.nerc.mghpcc.org)
    or NERC Academic (EDU) OpenShift web console: [https://console.apps.edu.nerc.mghpcc.org](https://console.apps.edu.nerc.mghpcc.org)
    based on your requested/approved **Resource Type** and they can start using
    the NERC's resources based on the approved project **quotas**.

    For detailed guidance on using **NERC (OpenStack)**, **NERC-OCP (OpenShift)**,
    and **NERC-OCP-EDU (OpenShift)** please refer to the respective user guides below:

    - [**NERC (OpenStack)**](../openstack/index.md)

    - [**NERC OCP (OpenShift)**](../openshift/index.md)

    - [**NERC Academic (EDU) OpenShift**](../openshift/index.md)

---
