# Images

Image compose of a virtual collection of a kernel, operating system, and configuration.

Glance is the API-driven OpenStack image service that provides services and associated
libraries to store, browse, register, distribute, and retrieve bootable disk images.
It acts as a registry for virtual machine images, allowing users to copy server
images for immediate storage. These images can be used as templates when setting
up new instances.

NERC provides a set of default images that can be used as source while launching
an instance:

| Name                                  |
|---------------------------------------|
| centos-7-x86_64                       |
| centos-8.4-x86_64                     |
| debian-10-x86_64                      |
| fedora-34-x86_64                      |
| ubuntu-16.04-x86_64                   |
| ubuntu-18.04-x86_64                   |
| ubuntu-20.04-x86_64                   |
| ubuntu-21.04-x86_64                   |

Beside the above mentioned system provided images users can customize and upload
their own images to the NERC, as demonstrated in [this documentation](../advanced-openstack-topics/setting-up-your-own-images/how-to-build-windows-image.md).

---
