## To build Devstack environment
Complete documentation for devstack can be foudn at: https://docs.openstack.org/devstack/latest/

Bellow are some quick notes based on experience of installing Devstack environment on MOC 
### Create the VM in horizon:
Launch new instance:
- 4 core, 8GB ram, 40GB disk (m1.large flavor on MOC)
- ubuntu 20.04.2 LTS Focal ( also  works on ubuntu 18.04.2 LTS buster)
- ssh_only security group

After host is created:
- add a public IP address

### Log into the VM and perform the devstack installation:
```sh
ssh ubuntu@*VM_PUBLIC_IP_ADDRESS*
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
sudo su - stack
git clone https://opendev.org/openstack/devstack
```
edit ~stack/devstack/local.conf (**consider setting your own password instead of "secret"**)

```
[[local|localrc]]
ADMIN_PASSWORD=secret
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD
```

back to commadline:
```sh
cd ~/devstack
screen (or tmux as you prefer)
script -f devstack-install.log
date
./stack.sh
```
50 minutes
```sh
exit (to stop typescript)
exit (to exit screen or tmux)
```
## Things to do after the install:
### Check if the services are running:
```sh
sudo systemctl status "devstack@*"
```
### Give yourself direct access to stack account:
Instead of logging in as user "ubuntu" and then running sudo to user "stack", you can copy your ssh config and login to the server directly as user "stack" by doing the following
```sh
sudo mkdir ~stack/.ssh/
sudo cp ~ubuntu/.ssh/authorized_keys ~stack/.ssh/authorized_keys
sudo chown -R stack:stack ~stack/.ssh
```
### Access the web interface:

From your local computer create ssh tunnel, instead of XXXX use a number above 1024 
```sh
ssh stack@*VM_PUBLIC_IP_ADDRESS* -L XXXX:localhost:80
```
point your browser to http://localhost:XXXX  (use same number as the one in ssh command)

### Access devstack via CLI 

on your devstack VM
```sh
source ~stack/devstack/userrc_early
openstack network list
```

There are python CryptographyDeprecationWarning messages printed everytime openstack command is run.  These can be surprseed by:
```sh
export PYTHONWARNINGS=ignore
```
