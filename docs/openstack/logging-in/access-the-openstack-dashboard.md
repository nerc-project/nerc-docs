# Access the OpenStack Dashboard

The OpenStack Dashboard which is a web-based graphical interface, code named
Horizon, is located at [https://stack.nerc.mghpcc.org](https://stack.nerc.mghpcc.org).

The NERC Authentication supports CILogon using Keycloak for gateway authentication
and authorization that provides federated login via your institution accounts and
it is the recommended authentication method. Select "OpenID Connect" as shown here:

![OpenID Connect](images/openstack_login.png)

and then this will redirect you to MSS Keycloak login page where you will see user
login or sign in option using "CILogon". CILogon facilitates secure access to
CyberInfrastructure (CI). Click "cilogon".

![MSS Keycloak Auth](images/keycloak_interface.png)

Next, you will redirected to CILogon welcome page as shown below:

![CILogon Welcome Page](images/CILogon_interface.png)

MSS Keycloak will requests access to the following information:

- Your CILogon user identifier
- Your name
- Your email address
- Your username and affiliation from your identity provider

which are required in order to allow access your account to NERC's OpenStack
dashboard.

From Select an Identity Provider dropdown option, please select your institution's
name. If you would like to remember your selected institution name for future
logins please check the "Remember this selection" checkbox this will bypass the
CILogon welcome page on subsequent visits and proceed directly to the selected insitution's
identity provider(IdP). Click "Log On". This will redirect to your respective institutional
login page where you need to enter your institutional credentials.

!!! note "Important Note"
    The NERC does not see or have access to your institutional account credentials
    and neither store them rather it just point to your selected insitution's identity
    provider and redirects back once authenticated.

Once you successfully authenticated you should see an overview of the resources
like Compute (instances, VCPUs, RAM, etc.), Volume and Network. You can also
see usage summary for provided date range.

![OpenStack Horizon dashboard](images/horizon_dashboard.png)

---
