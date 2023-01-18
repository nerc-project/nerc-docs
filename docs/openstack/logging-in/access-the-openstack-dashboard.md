# Access the OpenStack Dashboard

The OpenStack Dashboard which is a web-based graphical interface, code named
Horizon, is located at [https://stack.nerc.mghpcc.org](https://stack.nerc.mghpcc.org).

The NERC Authentication supports CILogon using Keycloak for gateway authentication
and authorization that provides federated login via your institution accounts and
it is the recommended authentication method.

Make sure you are selecting "OpenID Connect" (which is selected by default) as
shown here:

![OpenID Connect](images/openstack_login.png)

Next, you will be redirected to CILogon welcome page as shown below:

![CILogon Welcome Page](images/CILogon_interface.png)

MGHPCC Shared Services (MSS) Keycloak will request approval of access to the
following information from the user:

- Your CILogon user identifier
- Your name
- Your email address
- Your username and affiliation from your identity provider

which are required in order to allow access your account on NERC's OpenStack
dashboard.

From the **"Selected Identity Provider"** dropdown option, please select your institution's
name. If you would like to remember your selected institution name for future
logins please check the "Remember this selection" checkbox this will bypass the
CILogon welcome page on subsequent visits and proceed directly to the selected insitution's
identity provider(IdP). Click "Log On". This will redirect to your respective institutional
login page where you need to enter your institutional credentials.

!!! note "Important Note"
    The NERC does not see or have access to your institutional account credentials,
    it points to your selected insitution's identity provider and redirects back
    once authenticated.

Once you successfully authenticate you should see an overview of the resources
like Compute (instances, VCPUs, RAM, etc.), Volume and Network. You can also
see usage summary for provided date range.

![OpenStack Horizon dashboard](images/horizon_dashboard.png)

---
