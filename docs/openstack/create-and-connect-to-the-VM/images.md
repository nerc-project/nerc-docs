# Images

Image composed of a virtual collection of a kernel, operating system, and configuration.

## Glance

Glance is the API-driven OpenStack image service that provides services and associated
libraries to store, browse, register, distribute, and retrieve bootable disk images.
It acts as a registry for virtual machine images, allowing users to copy server
images for immediate storage. These images can be used as templates when setting
up new instances.

## NERC Images List

Once you're logged in to NERC's Horizon dashboard.

Navigate to *Project -> Compute -> Images*.

NERC provides a set of default images that can be used as source while launching
an instance:

    +--------------------------------------+---------------------+
    | ID                                   | Name                |
    +--------------------------------------+---------------------+
    | a9b48e65-0cf9-413a-8215-81439cd63966 | MS-Windows-2022     |
    | cfecb5d4-599c-4ffd-9baf-9cbe35424f97 | almalinux-8-x86_64  |
    | 263f045e-86c6-4344-b2de-aa475dbfa910 | almalinux-9-x86_64  |
    | 41fa5991-89d5-45ae-8268-b22224c772b2 | debian-10-x86_64    |
    | 99194159-fcd1-4281-b3e1-15956c275692 | fedora-36-x86_64    |
    | 74a33f77-fc42-4dd1-a5a2-55fb18fc50cc | rocky-8-x86_64      |
    | d7d41e5f-58f4-4ba6-9280-7fef9ac49060 | rocky-9-x86_64      |
    | 75a40234-702b-4ab7-9d83-f436b05827c9 | ubuntu-18.04-x86_64 |
    | 8c87cf6f-32f9-4a4b-91a5-0d734b7c9770 | ubuntu-20.04-x86_64 |
    | da314c41-19bf-486a-b8da-39ca51fd17de | ubuntu-22.04-x86_64 |
    +--------------------------------------+---------------------+



## How to create and upload own custom images?

Beside the above mentioned system provided images users can customize and upload
their own images to the NERC, as documented in [this documentation](../advanced-openstack-topics/setting-up-your-own-images/how-to-build-windows-image.md).

Please refer to [this guide](https://docs.openstack.org/image-guide/obtain-images.html)
to learn more about how to obtain other publicly available virtual machine images
for the NERC OpenStack platform within your project space.

---
