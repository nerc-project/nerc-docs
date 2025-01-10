# building updated  mpt3sas driver for rhel 8.2 openstack introspection and deploy images


## short version

unpack archive cotnaining all pre-requisites and run the build script in the container

```sh
tar xvfz mpt3sas_build.tar.gz 
cd mpt3sas_build
podman run -v `pwd`:/build:Z -it ubi8 /build/build.sh
```
grab  mpt3sas_build/output/mpt3sas.ko and move onto updating Openstack images.

## long version (components)

***mpt3sas_build/rpms*** directory contains rpms that are not available in ubi8 container repos. They require a fully licenses RHEL8 system to access (possibly there's a solution to this, but after a day of debugging had to move on).  The kernel-dev rpm has to match version of the kernel that is used in OpenStack introspection and deploy images (use `file vmlinuz` command against the kernel image to see what version that is)  In this case (07/06/2021) we are building for version 4.18.0-193.51.1.el8_2

***mpt3sas_build/src*** directory contains custom mpt3sas source rpm (kmod-mpt3sas-34.100.00.00-1nerc.el8.src.rpm) as well as original ELREPO files that were used to make it.  kmod-mpt3sas-34.100.00.00-1nerc.el8.src.rpm cotains modifications needed to compile for specific version of the kernel.  This will likely change and will have to be ported for updated kernel.  For 4.18.0-193.51.1.el8_2, I included aa-port-to-4.18.0-193.14.3.el8_2.patch as well as appropriate updates to the SPEC file.  Also included is the orginal distrubiton of the driver from https://elrepo.org/linux/dud/el8/x86_64/dd-mpt3sas-34.100.00.00-1.el8_3.elrepo.iso

***mpt3sas_build/build.sh*** scripts includes all the steps to perform the build process inside of an ubi8 container including installing the pre-requesites.

***mpt3sas_build/output*** directory will contain  mpt3sas.ko, which is the only file that we need to get out of this process.
