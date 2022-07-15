# Images

Image composed of a virtual collection of a kernel, operating system, and configuration.

## Glance

Glance is the API-driven OpenStack image service that provides services and associated
libraries to store, browse, register, distribute, and retrieve bootable disk images.
It acts as a registry for virtual machine images, allowing users to copy server
images for immediate storage. These images can be used as templates when setting
up new instances.

## NERC Images List

NERC provides a set of default images that can be used as source while launching
an instance:

| Name                                  |
|---------------------------------------|
| centos-7-x86_64                       |
| debian-10-x86_64                      |
| fedora-36-x86_64                      |
| rocky-8-x86_64                        |
| ubuntu-18.04-x86_64                   |
| ubuntu-20.04-x86_64                   |
| ubuntu-22.04-x86_64                   |

## How to create and upload own custom images?

Beside the above mentioned system provided images users can customize and upload
their own images to the NERC, as demonstrated in [this documentation](../advanced-openstack-topics/setting-up-your-own-images/how-to-build-windows-image.md).

Please refer to [this guide](https://docs.openstack.org/image-guide/obtain-images.html)
to understand more on how can you get other virtual machine images to the NERC's
OpenStack platform.

---
