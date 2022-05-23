# SSH to Cloud VM

**Shell**, or **SSH**, is used to administering and managing Linux workloads.
Before trying to access instances from the outside world, you need to make sure
you have followed these steps:

- You followed the instruction in [Create a Key Pair](../../access-and-security/
create-a-key-pair/) to set up a public ssh key.
- Your public ssh-key was selected (in the Access and Security tab) while
[launching the instance](launch-a-VM.md).
- [Assign a Floating IP](assign-a-floating-IP.md) to the instance in order to
access it from outside world.
- Make sure you have added rules in the [Security Groups](../../
access-and-security/security-groups/) to allow ssh to the instance.

Make a note of the floating IP you have associated to your instance.

![Associated Instance Floating IP](images/floating_ip_is_associated.png)

In our example, the IP is `140.247.152.229`.

Default usernames for all the base images are:

- **all Ubuntu images**: ubuntu
- **all CentOS images**: centos
- **all RHEL images**: ubuntu
- **all Fedora images**: fedora
- **all Debian images**: debian

Our example VM was launched with the **ubuntu-21.04-x86_64** base image, the
user we need is 'ubuntu'.

Open a Terminal window and type:

```sh
  ssh ubuntu@140.247.152.229
```

Since you have never connected to this VM before, you will be asked if you are
sure you want to connect. Type `yes`.

![SSH To VM Successful](images/ssh_to_vm.png)

!!! tip "Note"
    If you haven't added your key to ssh-agent, you may need to specify the
    private key file, like this: `ssh -i ~/.ssh/cloud.key ubuntu@140.247.152.229`

---

## Setting a password

When the VMs are launched, a strong, randomly-generated password is created for
the default user, and then discarded.

Once you connect to your VM, you will want to set a password in case you ever
need to log in via the console in the web dashboard.

For example, if your network connections aren't working right.

Since you are not using it to log in over SSH or to sudo, it doesn't really
matter how hard it is to type, and we recommend using a randomly-generated
password.

Create a random password like this:

```sh
  ubuntu@test-vm:~$ cat /dev/urandom | base64 | dd count=14 bs=1
  T1W16HCyfZf8V514+0 records in
  14+0 records out
  14 bytes copied, 0.00110367 s, 12.7 kB/s
```

The 'count' parameter controls the number of characters.

The first [count] characters of the output are your randomly generated output,
followed immediately by "[count]+0",
so in the above example the password is: `T1W16HCyfZf8V5`.

Set the password for ubuntu using the command:

```sh
  ubuntu@test-vm:~$ sudo passwd ubuntu
  New password:
  Retype new password:
  ... password updated successfully
```

Store the password in a secure place. Don't send it over email, post it on your
wall on a sticky note, etc.

## Adding other people's SSH keys to the instance

You were able to log into using your own SSH key.

Right now Openstack only permits one key to be added at launch, so you need to
add your teammates keys manually.

Get your teammates' public keys.  If they used ssh-keygen to create their key,
this will be in a file called <key_name>.pub on their machine.

If they created a key via the dashboard, or imported the key created with
ssh-keygen, their public key is viewable from the Key Pairs tab.

Click on the key pair name.  The public key starts with 'ssh-rsa' and looks
something like this:

```sh
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL6O5qNZHfgFwf4vnnib2XBub7ZU6khy6z6JQl3XRJg6I6gZ
  +Ss6tNjz0Xgax5My0bizORcka/TJ33S36XZfzUKGsZqyEl/ax1Xnl3MfE/rgq415wKljg4
  +QvDznF0OFqXjDIgL938N8G4mq/
  cKKtRSMdksAvNsAreO0W7GZi24G1giap4yuG4XghAXcYxDnOSzpyP2HgqgjsPdQue919IYvgH8shr
  +sPa48uC5sGU5PkTb0Pk/ef1Y5pLBQZYchyMakQvxjj7hHZaT/
  Lw0wIvGpPQay84plkjR2IDNb51tiEy5x163YDtrrP7RM2LJwXm+1vI8MzYmFRrXiqUyznd
  test_user@demo
```

Create a file called something like 'teammates.txt' and paste in your team's
public keys, one per line.

Hang onto this file to save yourself from having to do all the copy/pasting
every time you launch a new VM.

Copy the file to the vm:

```sh
  [you@your-laptop ~]$ scp teammates.txt ubuntu@140.247.152.229:~
```

If the copy works, you will see the output:

```sh
  teammates.txt                  100%    0     0KB/s   00:00
```

Append the file's contents to authorized_keys:

```sh
  [cloud-user@test-vm ~] #cat teammates.txt >> ~/.ssh/authorized_keys
```

Now your teammates should also be able to log in.

Make sure to use `>>` instead of `>` to avoid overwriting your own key.

---

## Adding users to the instance

You may decide that each teammate should have their own user on the VM instead
of everyone logging in to the default user.

Once you log into the VM, you can create another user like this.

!!! tip "Note"
    The 'sudo_group' is different for different OS - in CentOS and Red Hat, the
    group is called 'wheel', while in Ubuntu, the group is called 'sudo'.

```sh
  $ sudo su
  # useradd -m <username>
  # passwd <username>
  # usermod -aG <sudo_group> <username>    <-- skip this step for users who
  # should not have root access
  # su username
  $ cd ~
  $ mkdir .ssh
  $ chmod 700 .ssh
  $ cd .ssh
  $ vi authorized_keys   <-- paste the public key for that user in this file
  $ chmod 600 authorized_keys
```

---
