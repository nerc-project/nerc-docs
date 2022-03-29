# Identify Volumes, Instances & Security Groups on the MOC that need to be Migrated to the NERC

Please read the instructions in their entirety before proceeding.
Allow yourself enough time to complete them.

Snapshots will not be migrated.
If you have a Snapshot you wish to backup please “Create Volume” from it first.

1. Go to the [MOC Dashboard](http://kaizen.massopen.cloud).
    1. If you have SSO through your Institution or google select
    *Institution Account* from the dropdown.
        ![Login1](images/S1_Login1.png)
        1. Click **Connect**.
        2. Click on University Logins (highlighted in yellow below)
        if you are using SSO with your Institution.
        ![Login2](images/S1_Login2.png)
            1. Follow your Institution's login steps after that,
            and skip to step
        3. Click Google (highlighted in purple above) if your SSO
        is through Google.
            1. Follow standard Google login steps to get in this
            way, and skip to step 2.
    2. If you have a standard login and password leave the dropdown
    as Keystone Credentials.
        ![Login3](images/S1_Login3.png)
        1. Enter your User Name.
        2. Enter your Password.
        3. Click Connect.
        4. If you do not know your login information please create a
        Password Reset [ticket](https://osticket.massopen.cloud/).
            ![OSticket1](images/S1_OSticket1.png)
            1. Click Open a New Ticket (highlighted in yellow above).
                ![OSticket2](images/S1_OSticket2.png)
            2. Click the dropdown and select Forgot Pass & SSO Account
            Link (highlighted in blue above).
            3. In the text field (highlighted in purple above) provide
            the Institution email, project you are working on and the email
            address you used to create the account.
            4. Click **Create Ticket** (highlighted in yellow above) and
            wait for the pinwheel.
            5. You will receive an email to let you know that the MOC support
            staff will get back to you.
2. You are then brought to the Project>Compute>Overview location of the
Dashboard.
    ![Project_Compute_Instance](images/S1_Project_Compute_Instance.png)
3. Gather the Instance UUIDs (of only the instances that you need to migrate
to the NERC).
    1. Click
    [Instances](https://kaizen.massopen.cloud/dashboard/project/instances/)
        ![Project_Instance_Name](images/S1_Project_Compute_Instance_Name.png)
    2. Click the Instance Name (highlighted in Yellow above) of the first
    instance you would like to gather data on.
        ![Project_Inst_Details](images/S1_Project_Compute_Instance_Details.png)
    3. Locate the ID row (highlighted in green above) and copy and save the ID
    (highlighted in purple above).
        1. This is the UUID of your first Instance.
    4. Locate the RAM, VCPUs & Disk rows (highlighted in yellow) and copy and
    save the associated values (highlighted in pink).
4. Repeat step 3 for each Instance you have.
5. Gather the Volume UUIDs (of only the volumes that you need to migrate
to the NERC).
    ![Project_Volumes_Volumes](images/S1_Project_Volumes_Volumes.png)
    1. Click Volumes dropdown.
    2. Select
    [Volumes](https://kaizen.massopen.cloud/dashboard/project/volumes/)
    (highlighted in purple above).
        ![Project_Volumes_Names](images/S1_Project_Volumes_Names.png)
    3. Click the Volume Name (highlighted in yellow above) of the first
    volume you would like to gather data on.
        1. The name might be the same as the ID (highlighted in blue above).
            ![Project_Volumes_Details](images/S1_Project_Volumes_Details.png)
    4. Locate the ID row (highlighted in green above) and copy and save the ID
    (highlighted in purple above).
        1. This is the UUID of your first Volume.
    5. Locate the Size row (highlighted in yellow above) and copy and save
    the Volume size (highlighted in pink above).
    6. Locate the Attached To row (highlighted in blue above) and copy and save
    the Instance this Volume is attached to (highlighted in orange above).
        1. If the volume is not attached to an image it will state
        “Not attached”.
6. Repeat step 5 for each Volume you have.
7. If you already have all of your Security Group information outside of the
OpenStack Dashboard skip to step 10.
8. Gather the Security Group information (of only the security groups that you
need to migrate to the NERC).
    ![Project_Network_SecGroup](images/S1_Project_Network_SecurityGroup.png)
    1. Click Network dropdown
    2. Click
    [Security](https://kaizen.massopen.cloud/dashboard/project/security_groups/)
    Groups (highlighted in yellow above).
        ![Ntwrk_ScGrp_Names](images/S1_Project_Network_SecurityGroup_Names.png)
    3. Click **Manage Rules** (highlighted in yellow above) of the first
    Security Group you would like to gather data on.
        ![Ntwrk_SGp_Detal](images/S1_Project_Network_SecurityGroup_Details.png)
    4. Ignore the first 2 lines (highlighted in yellow above).
    5. Write down the important information for all lines after (highlighted in
    blue above).
        1. Direction, Ether Type, IP Protocol, Port Range, Remote IP Prefix,
        Remote Security Group.
9. Repeat step 8 for each security group you have.
10. Create 3 tables of all of your Instances, your Volumes and Security Groups,
for example, if you have 2 instances, 3 volumes and 2 Security Groups like the
sample above your lists might look like this:

MOC Instance information:

| Instance Name | MOC VCPUs | MOC Disk | MOC RAM | MOC UUID |
| ------------- | --------- | -------- | ------- | -------- |
| Fedora_test | 1 | 10GB | 1GB | 16a1bfc2-8c90-4361-8c13-64ab40bb6207 |
| Ubuntu_Test | 1 | 10GB | 2GB | 6a40079a-59f7-407c-9e66-23bc5b749a95 |
| total | 2 | 20GB | 3GB | |

MOC Volume Information:

| Volume Name | MOC Disk | MOC Attached To | MOC UUID |
| ----------- | -------- | --------------- | -------- |
| Fedora | 10GiB | Fedora_test | ea45c20b-434a-4c41-8bc6-f48256fc76a8 |
| 9c73295d-fdfa-4544-b8b8-a876cc0a1e86 | 10GiB | Ubuntu_Test | 9c73295d-fdfa-4544-b8b8-a876cc0a1e86 |
| Snapshot of Fed_Test | 10GiB | Fedora_test | ea45c20b-434a-4c41-8bc6-f48256fc76a8 |
| total | 30GiB | Not attached | |

MOC Security Group Information:

| Security Group Name | Direction | Ether Type | IP Protocol | Port Range | Remote IP Prefix |
| ------------------- | --------- | ---------- | ----------- | ---------- | ---------------- |
| ssh_only_test | Ingress | IPv4 | TCP | 22 | 0.0.0.0/0 |
| ping_only_test | Ingress | IPv4 | ICMP | Any | 0.0.0.0/0 |
