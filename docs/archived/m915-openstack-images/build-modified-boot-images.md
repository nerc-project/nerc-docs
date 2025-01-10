# Scripts to rebuild RHOSP introspect and deploy images.

## Pre-prequisites:

RHEL 8.2 host with spax and libguestfs-tools installed, libgcrypt RPM updated to
version 1.8.5-4 or newer.  libvird service needs to be running.

An mpt3sas driver compiled for the matching version of the kernel.  (refer to 
documentation in gitlab on how to do so)

Initial RHOSP introspect and deploy images[1].  Can be obtained from 
rhosp-director-images and rhosp-director-images-ipa RPMs or copied from an
existing deployment

```sh
scp stack@nerc-undercloud01:/usr/share/rhosp-director-images/overcloud-full-latest-16.1.tar .
scp stack@nerc-undercloud01:/usr/share/rhosp-director-images/ironic-python-agent-latest-16.1.
tar .
```

## Prep for building images:

Create a directory to work in and set MYWDIR variable to that directotry.

Clone scripts from build_images_scripts directory to it.

Inside MYWDIR create a src_extracted directory and place:

- ironic-python-agent.kernel
- ironic-python-agent.initramfs
- overcloud-full.vmlinuz
- overcloud-full.initrd
- overcloud-full.qcow2
- mpt3sas.ko.xz

You can collect the files from tar arcvhies referenced in pre-requisites 
section.  Building of mpt3sas driver is outside of scope of this document, 
reference *content/m915-openstack-images/build-mpt3sas-kernel-driver.md* in 
nerc-docs.

## Build images:
```sh
cd $MYWDIR
./mk_intrspct_img.sh
./mk_deploy_img.sh
./mk_qcow.sh
```
Watch for errors.  There are tmp files left around for additional validation and
verification.  

If process succeeds $MYWDIR/built directory should contain the following:

- ironic-python-agent-custom.kernel
- ironic-python-agent-custom.initramfs
- overcloud-full-custom.vmlinuz
- overcloud-full-custom.initrd  
- overcloud-full-custom.qcow2

Files in the $MYWDIR/built directory are to be sent to nerc-undercloud01 for 
upload into glance.



## documents used for creating this process
[1] https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.1/html/director_installation_and_usage/installing-the-undercloud#sect-Obtaining_Images_for_Overcloud_Nodes
[2] https://unix.stackexchange.com/questions/163346/why-is-it-that-my-initrd-only-has-one-directory-namely-kernel
[3] https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.1/html/partner_integration/overcloud_images
