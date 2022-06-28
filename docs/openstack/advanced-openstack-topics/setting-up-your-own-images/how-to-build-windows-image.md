# Virtual Machine Image Guide

An OpenStack Compute cloud needs to have virtual machine images in order to
launch an instance. A virtual machine image is a single file which contains a
virtual disk that has a bootable operating system installed on it.

!!!warning "Very Important"
    The provided Windows Server 2022 R2 image is for evaluation only. This evaluation
    edition expires in **180 days**. This is intended to evaluate if the product
    is right for you. This is on *user discretion* to update, extend, and handle
    licensing issues for future usages.

## Existing Microsoft Windows Image

Cloudbase Solutions provides [Microsoft Windows Server 2022 R2 Standard
Evaluation for OpenStack](https://cloudbase.it/windows-cloud-images/). This
includes the required support for hypervisor-specific drivers (Hyper-V / KVM).
Also integrated are the guest initialization tools (Cloudbase-Init), security
updates, proper performance, and security configurations as well as the final Sysprep.

## How to Build and Upload your custom Microsoft Windows Image

!!!note "Overall Process"
    To create a new image, you will need the installation CD or DVD ISO file for
    the guest operating system. You will also need access to a virtualization tool.
    You can use KVM hypervisor for this. Or, if you have a GUI desktop virtualization
    tool (such as, [virt-manager](https://virt-manager.org/), VMware Fusion or
    VirtualBox), you can use that instead. Convert the file to **QCOW2** (KVM, Xen)
    once you are done.

You can customize and build the new image manually on your own system and then
upload the image to the NERC's OpenStack Compute cloud. Please follow the following
steps which describes how to obtain, create, and modify virtual machine images that
are compatible with the NERC's OpenStack.

### 1. Prerequisite

Follow these steps to prepare the installation

a. Download a Windows Server 2022 installation ISO file. Evaluation images are
available on the [Microsoft website](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022)
(**registration required**).

b. Download the signed **VirtIO drivers** ISO file from the [Fedora website](https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html).

c. Install [Virtual Machine Manager](https://virt-manager.org/download/) on your
local Windows 10 machine using WSL:

- **Enable WSL on your local Windows 10 subsystem for Linux:**

    The steps given here are straightforward, however, before following them
    make sure on your Windows 10, you have WSL enabled and have at least Ubuntu
    20.04 or above LTS version running over it. If you don’t know how to do
    that then see our tutorial on [how to enable WSL and install Ubuntu over
    it](https://www.how2shout.com/how-to/enable-windows-subsystem-linux-feature.html).

- **Download and install MobaXterm:**

    **MobaXterm** is a free application that can be downloaded using [this link](https://mobaxterm.mobatek.net/download-home-edition.html).
    After downloading, install it like any other normal Windows software.

- **Open MobaXterm and run WSL Linux:**

    As you open this advanced terminal for Windows 10, WSL installed Ubuntu
    app will show on the left side panel of it. Double click on that to start
    the WSL session.

    ![MobaXterm WSL Ubuntu-20.04 LTS](images/a.mobaxterm_ubuntu_WSL.png)

- **Install Virt-Manager:**

        sudo apt update
        sudo apt install virt-manager

- **Run Virtual Machine Manager:**

    Start the Virtual Machine Manager running this command on the opened
    terminal: `virt-manager` as shown below:

    ![MobaXterm start Virt-Manager](images/b.mobaxterm_init_virt-manager.png)

    This will open Virt-Manager as following:

    ![Virt-Manager interface](images/0.virtual-manager.png)

- **Connect QEMU/KVM user session on Virt-Manager:**

    ![Virt-Manager Add Connection](images/0.0.add_virtual_connection.png)

    ![Virt-Manager QEMU/KVM user session](images/0.1.select_qemu_kvm_user_session.png)

    ![Virt-Manager Connect](images/0.2.qemu_kvm_user_session.png)

### 2. Create a virtual machine

Create a virtual machine with the storage set to a **15 GB** *qcow2* disk image
using Virtual Machine Manager

![Virt-Manager New Virtual Machine](images/1.new_virtual_machine.png)

![Virt-Manager Local install media](images/2.select_local_ISO_image.png)

![Virt-Manager Browse Win ISO](images/3.0.Choose_ISO.png)

![Virt-Manager Browse Local](images/3.1.browse_local.png)

![Virt-Manager Select the ISO file](images/3.3.open_local_iso_file.png)

![Virt-Manager Selected ISO](images/3.4.select_iso.png)

![Virt-Manager default Memory and CPU](images/4.default_mem_cpu.png)

Please set **15 GB disk image** size as shown below:

![Virt-Manager disk image size](images/5.set_15_GB_disk_size.png)

Set the virtual machine name and also make sure **"Customize configuration before
install"** is selected as shown below:

![Virt-Manager Virtual Machine Name](images/6.set_name.png)

### 3. Customize the Virtual machine

![Virt-Manager Customize Image](images/7.0.customize_iso.png)

Enable the **VirtIO** driver. By default, the Windows installer does not
detect the disk.

![Virt-Manager Disk with VirtIO driver](images/7.1.customize_sata_disk_virtio.png)

Add a **New Hardware**  > select **CDROM device** and attach to downloaded
**virtio-win-* ISO** file:

![Virt-Manager Add Hardware](images/7.4.add_virtio_iso_hardware.png)

![Virt-Manager Add CDROM with virtio ISO](images/7.5.add_virtio_iso_cdrom.png)

![Virt-Manager Browse virtio ISO](images/7.6.browse_virtio_iso.png)

![Virt-Manager Select virtio ISO](images/7.7.select_virtion_iso.png)

Make sure the NIC is using the **virtio** Device model as show below:

![Virt-Manager Modify  NIC](images/7.2.customize_nic_virtio.png)

![Virt-Manager Apply Change on NIC](images/7.3.customize_nic_virtio_apply.png)

Make sure to set proper order of **Boot Options** as shown below so that
CDROM with Windows ISO is set on the first and Apply the order change.
After this please begin windows installation clicking on **"Begin Installation"**
button.

![Windows Boot Options](images/7.8.boot_option_win_cdrom_first.png)

### 4. Continue with the Windows installation

Click "Apply" button and continue with the Windows installation

When prompted you can choose "Windows Server 2022 Standard Evaluation (Desktop Experinece)"
option as shown below:

![Windows Desktop Installation](images/7.windows_installation_desktop.png)

![Windows Custom Installation](images/8.custom_setup.png)

Load VirtIO SCSI drivers and network drivers by choosing an installation
target when prompted. Click **Load driver** and browse the file system.

![Windows Custom Load Driver](images/9.load_driver.png)

![Browse Local Attached Drives](images/10.browse_driver.png)

![Select VirtIO CDROM](images/11.browse_CDRom_virtio_iso.png)

Select the `E:\virtio-win-*\viostor\2k22\amd64` folder. When converting an
image file with Windows, ensure the virtio driver is installed. Otherwise,
you will get a blue screen when launching the image due to lack of the virtio
driver.

![Select Appropriate Win Version viostor driver](images/12.select_viostor_driver.png)

The Windows installer displays a list of drivers to install. Select the
VirtIO SCSI drivers.

![Windows viostor driver Installation](images/13.install_viostor_driver.png)

Click **Load driver** again and browse the file system, and select the
`E:\NetKVM\2k22\amd64` folder.

![Select Appropriate Win Version NetKVM driver](images/14.select_netkvm_driver.png)

Select the network drivers, and continue the installation.

![Windows NetKVM driver Installation](images/15.install_netkvm_driver.png)

![Windows Ready for Installation](images/16.install_win.png)

![Windows Continue Installation](images/17.wait_installation_finish.png)

### 5. Restart the installed virtual machine (VM)

Once the installation is completed, the VM restarts

Define a password for the **Adminstrator** when prompted and click on
"Finish" button:

![Windows Administrator Login](images/finalize_win_installtion_with_user.png)

Send the **"Ctrl+Alt+Delete"** key using **Send Key** Menu, this will
unlock the windows and then prompt login for the Administrator - please login
using the password you set on previous step:

![Windows Send Key](images/send_ctrl_alt_delete_key.png)

![Administrator Login](images/login_administrator.png)

![Administrator Profile Finalize](images/setup_admininstrator_profile.png)

![Windows Installation Successful](images/windows-successful-login.png)

### 6. Go to device manager and install all unrecognized devices

![Device Manager View](images/device-manager-update-drivers.png)

![Device Manager Update Driver](images/update_driver.png)

![Device Manager Browse Driver](images/browse_driver.png)

![Browse To Attached vitio-win CDROM](images/browse_driver_CDROM.png)

![Select Attached vitio-win CDROM](images/select_attached_driver.png)

![Successfully Installed Driver](images/installed_driver.png)

Similarly as shown above repeat and install all missing drivers.

### 7. Enable Remote Desktop Protocol (RDP) login

Explicitly **enable** RDP login and **uncheck** "Require computers to use Network
Level Authentication to connect" option

![Enable RDP](images/rdp-enable.png)

![Disable Network Level Authentication](images/rdp-network-level-auth-not-required.png)

### 8. Delete the recovery parition

Delete the recovery parition which will allow expanding the Image as required
running the following commands on **Command Prompt (Run as Adminstrator)**

        diskpart
        select disk 0
        list partition
        select partition 3
        delete partition override
        list partition

![Disk Partition 3 Delete using CMD](images/disk_partition_manager_delete_partition_3.png)

and then extend `C:` drive to take up the remaining space using **"Disk Management"**.

![C Drive Extended using Disk Management](images/extend_C_drive_using_disk_manager.png)

![C Drive Extended to Take all Unallocated Space](images/c_drive_extended_to_take_all_unallocated_space.png)

![C Drive on DIsk Management](images/new_c_drive.png)

### 9. Install any new Windows updates. (Optional)

### 10. Setup cloudbase-init to generate QCOW2 image

Download and install stable version of **cloudbase-init** (A Windows project
providing guest initialization features, similar to cloud-init) by browsing the
[Download Page](https://cloudbase.it/cloudbase-init/#download) on the web browser
on virtual machine running Windows, you can escape registering and just click
on **"No. just show me the downloads"** to navigate to the download page as
shown below:

![Download Cloudbase-init](images/install_cloudbase-init.png)

During Installation, set *Serial port for logging* to **COM1** as shown below:

![Download Cloudbase-init setup for Admin](images/coludbase-init-serial-port-com1.png)

When the installation is done, in the *Complete the Cloudbase-Init Setup Wizard*
window, select the **Run Sysprep** and **Shutdown** check boxes and click "Finish"
as shown below:

![Cloudbase-init Final Setup Options](images/cloudinit-final-setup.png)

Wait for the machine to shutdown.

![Sysprep Setup in Progress](images/sysprep_in_progress.png)

### 11. Where is the newly generated QCOW2 image?

The Sysprep will generate **QCOW2** image i.e. `win2k22.qcow2` on `/home/<YourUserName>/.local/share/libvirt/images/`

![Windows QCOW2 Image](images/download_icow2_win2022_image.png)

### 12. Create OpenStack image and push to NERC's image list

You can copy/download this windows image to the folder where you configured your
OpenStack CLI as described [Here](../openstack-cli/openstack-CLI.md) and upload
to the NERC's OpenStack running the following OpenStack Image API command:

    openstack image create --disk-format qcow2 --file win2k22.qcow2 MS-Windows-2022

You can verify the uploaded image is available by running:

    openstack image list

    +--------------------------------------+---------------------+--------+
    | ID                                   | Name                | Status |
    +--------------------------------------+---------------------+--------+
    | 7da9f5d4-4836-4bv8-bc5e-xc07ac6d8171 | MS-Windows-2022     | active |
    | ...                                  | ...                 | ...    |
    +--------------------------------------+---------------------+--------+

### 13. Launch an instance using newly uploaded MS-Windows-2022 image

Login to the [NERC's OpenStack](https://stack.nerc.mghpcc.org/) and verify the
uploaded **MS-Windows-2022** is there also available on the NERC's OpenStack
Images List for your project as shown below:

![MS-Windows-2022 OpenStack Image](images/stack_images_windows.png)

Create a **Volume** using that *Windows Image*:

![MS-Winodws-2022 Image to Volume Create](images/stack_image_to_volume.png)

![Create Volume](images/create_volume.png)

Once successfully Volume is created, we can use the Volume to launch an instance
as shown below:

![Launch Instance from Volume](images/launch_instance_from_volume.png)

Add other information and setup a Security Group that allows RDP as shown below:

![Launch Instance Security Group for RDP](images/security_group_for_rdp.png)

![Running Windows Instance](images/win2k22_instance_running.png)

![Associate Floating IP](images/win_instance_add_floating_ip.png)

Click on detail view of the Instance and then click on Console tab menu
and click on **"Send CtrlAltDel"** button located on the top right side of
the console as shown below:

![View Console of Instance](images/console_win_instance.png)

![Administrator Sign in Prompt](images/administrator_singin_prompt.png)

![Administrator Prompted to Change Password](images/ok_to_change_password_administrator.png)

![Set Administrator Password](images/new_password_administrator.png)

![Proceed Changed Administrator Password](images/proceed_change_password_administrator.png)

![Administrator Password Changed Successful](images/password_changed_success.png)

### 14. How to have Remote Desktop login to your Windows instance

Remote Desktop login should work with the Floating IP associated with the instance:

![Search Remote Desktop Protocol locally](images/RDP_on_local_machine.png)

![Connect to Remote Instance using Floating IP](images/remote_connection_floating_ip.png)

![Prompted Administrator Login](images/prompted_administrator_login.png)

![Prompted RDP connection](images/prompted_rdp_connection.png)

![Successfully Remote Connected Instance](images/remote_connected_instance.png)

---
