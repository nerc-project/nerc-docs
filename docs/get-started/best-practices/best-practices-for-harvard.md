# Securing Your Public Facing Server

## Overview

This document is aimed to provide you with a few concrete actions you can take
to significantly enhance the security of your devices. This advice can be
enabled even if your servers are not public facing. However, we strongly
recommend implementing these steps if your servers are intended to be accessible
to the internet at large.

All recommendations and guidance are guided by our policy that has specific
requirements, the current policy/requirements for servers at NERC can be
found [here](https://policy.security.harvard.edu/all-servers).

!!! danger "Harvard University Security Policy Information"
    *Please note that all assets deployed to your NERC project must be compliant
    with University Security policies. Please familiarize yourself with the
    Harvard University Information Security Policy and your role in securing
    data: [https://policy.security.harvard.edu/](https://policy.security.harvard.edu/).
    If you have any questions about how Security should be implemented in the
    Cloud, please contact your school security officer: [https://security.harvard.edu/](https://security.harvard.edu/).*

## Know Your Data

Depending on the data that exists on your servers, you may have to take added or
specific steps to safeguard that data. At Harvard, we developed a scale of data
classification ranging from 1 to 5 in order of increasing data sensitivity.

We have prepared added guidance with examples for both
[Administrative Data](https://security.harvard.edu/data-classification-table)
and [Research Data](https://security.harvard.edu/data-security-levels-research-data-examples).

Additionally, if your work involved individuals situated in a European Economic
Area, you may be subject to the requirements of the General Data Protection
Regulations and more information about your responsibilities can be found
[here](https://security.harvard.edu/eu-general-data-protection-regulation-gdpr).

## Host Protection

The primary focus of this guide is to provide you with security essentials that
we both support and that you can implement with little effort.

### Endpoint Protection

Harvard University uses the endpoint protection service: **Crowdstrike**, which
actively checks a machine for indication of malicious activity and will act to
both block the activity and remediate the issue. This service is offered free to
our community members and requires the installation of an agent on the server
that runs transparently. This software enables the Harvard security team to
review security events and act as needed.

Crowdstrike can be downloaded from our repository at:
[agents.itsec.harvard.edu](https://agents.itsec.harvard.edu/) this software is required
for all devices owned by Harvard staff/faculty and available for all operating
systems.

!!! note "Please note"
    To acess this repository you need to be in **Harvard Campus Network**.

### Patch/Update Regularly

It is common that vendors/developers will announce that they have discovered a new
vulnerability in the software you may be using. A lot of these vulnerabilities
are addressed by new releases that the developer issues. Keeping your software
and server operating system up to date with current versions ensures that you are
using a version of the software that does not have any known/published vulnerabilities.

### Vulnerability Management

Various software versions have historically been found to be vulnerable to specific
attacks and exploits. The risk of running older versions of software is that you
may be exposing your machine to a possible known method of attack.

To assess which attacks you might be vulnerable to and be provided with specific
remediation guidance, we recommend enrolling your servers with our Tenable service
which periodically scans the software on your server and correlates the software
information with a database of published vulnerabilities. This service will enable
you to prioritize which component you need to upgrade or otherwise define which
vulnerabilities you may be exposed to.

The Tenable agents runs transparently and can be enabled to work according to
the parameters set for your school; the agent can be downloaded
[here](https://agents.itsec.harvard.edu/) and configuration support can be found
by filing a support request via HUIT support ticketing system:
[ServiceNow](https://harvard.service-now.com/ithelp?id=submit_ticket&sys_id=3f1dd0320a0a0b99000a53f7604a2ef9).

### Safer Applications/ Development

Every application has its own unique operational constraints/requirements, and
the advice below cannot be comprehensive however we can offer a few general recommendations

#### Secure Credential Management

Credentials should not be kept on the server, nor should they be included directly
in your programming logic.

Attackers often review running code on the server to see if they can obtain any
sensitive credentials that may have been included in each script. To better
manage your credentials, we recommend either using:

● [1password Credential Manager](https://1password.com/)

● [AWS Secrets](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html)

#### Not Running the Application as the Root/Superuser

Frequently an application needs special permissions and access and often it is
easiest to run an application in the root/superuser account. This is a dangerous
practice since the application, when compromised, gives attackers an account with
full administrative privileges. Instead, configuring the application to run with
an account with only the permissions it needs to run is a way to minimize the
impact of a given compromise.

## Safer Networking

The goal in safer networking is to minimize the areas that an attacker can target.

### Minimize Publicly Exposed Services

Every port/service open to the internet will be scanned to access your servers.
We recommend that any service/port that is not needed to be accessed by the
public be placed behind the campus firewall. This will significantly reduce the
number of attempts by attackers to compromise your servers.

In practice this usually means that you only expose posts 80/443 which enables
you to serve websites, while you keep all other services such as SSH,
WordPress-logins, etc behind the campus firewall.

### Strengthen SSH Logins

Where possible, and if needed, logins to a Harvard service should be placed behind
Harvardkey. For researchers however, the preferred login method is usually SSH
and we recommend the following ways to strengthen your SSH accounts

● Disable password only logins

- In file `/etc/ssh/sshd_config` change `PasswordAuthentication` to `no` to disable
tunneled clear text passwords i.e. `PasswordAuthentication no`.

- Uncomment the second line, and, if needed, change yes to no.

- Then run `service ssh restart`.

● Use SSH keys with passwords enabled on them

● If possible, enroll the SSH service with a Two-factor authentication provider
such as DUO or YubiKey.

## Attack Detection

Despite the best protection, a sophisticated attacker may still find a way to
compromise your servers and in those scenarios, we want to enhance your ability
to detect activity that may be suspicious.

### Install Crowdstrike

As stated above, Crowdstrike is both an endpoint protection service and also an
endpoint detection service. This software understands activities that might be
benign in isolation but coupled with other actions on the device may be
indicative of a compromise. It also enables the quickest security response.

Crowdstrike can be downloaded from our repository at: agents.itsec.harvard.edu
this software is needed for all devices owned by Harvard staff/faculty and
available for all operating systems.

### Safeguard your System Logs

System logs are logs that check and track activity on your servers, including
logins, installed applications, errors and more.

Sophisticated attackers will try to delete these logs to frustrate investigations
and prevent discovery of their attacks. To ensure that your logs are still
accessible and available for review, we recommend that you configure your logs
to be sent to a system separate from your servers. This can be either sending logs
to an external file storage repository. Or configuring a separate logging system
using **Splunk**.

For help setting up logging please file a support request via our support
ticketing system: [ServiceNow](https://harvard.service-now.com/ithelp?id=submit_ticket&sys_id=3f1dd0320a0a0b99000a53f7604a2ef9).

## Escalating an Issue

There are several ways you can report a security issue and they are all documented
on [HUIT Internet Security and Data Privacy group site](https://security.harvard.edu/report-incident).

In the event you suspect a security issue has occurred or wanted someone to supply
a security assessment, please feel free to reach out the HUIT Internet Security
and Data Privacy group, specifically the Operations & Engineering team.

● Email: [itsec-ops@harvard.edu](mailto:itsec-ops@harvard.edu).

● Service Queue:
[https://harvard.service-now.com/ithelp?id=submit_ticket&sys_id=3f1dd0320a0a0b99000a53f7604a2ef9](https://harvard.service-now.com/ithelp?id=submit_ticket&sys_id=3f1dd0320a0a0b99000a53f7604a2ef9)

● Slack: [harvard-huit.slack.com](https://harvard-huit.slack.com) Channel: **#isdp-public**

## Further References

[https://policy.security.harvard.edu/all-servers](https://policy.security.harvard.edu/all-servers)

[https://enterprisearchitecture.harvard.edu/security-minimal-viable-product-requirements-huit-hostedmanaged-server-instances](https://enterprisearchitecture.harvard.edu/security-minimal-viable-product-requirements-huit-hostedmanaged-server-instances)

[https://policy.security.harvard.edu/security-requirements](https://policy.security.harvard.edu/security-requirements)

---
