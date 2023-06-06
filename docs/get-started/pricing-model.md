# How does NERC pricing work?

NERC offers you a **pay-as-you-go** approach for pricing for our cloud infrastructure offerings (Tiers of Service), including Infrastructure-as-a-Service (IaaS) - OpenStack, Platform-as-a-Service (PaaS) - OpenShift and NERC Storage Tiers. NERC offers a flexible cost model where users are billed solely for the specific services you require, for the duration of their usage based on users approved resource quotas, without any obligations of long-term contracts or complicated licensing agreements.

## Calculations

### Service Units (SU)

| Name          | vGPU | vCPU | RAM (GB) | Storage (GB) | Price  |
| :-----------: | :--: | :--: | :------: | :----------: | :----: |
| CPU           | 0    | 1    | 4        | 20           | $0.013 |
| A100 GPU      | 1    | 24   | 96       | 20           | $1.790 |
| A2 GPU        | 1    | 8    | 64       | 20           | $0.463 |
| Extra Storage | 0    | 0    | 0        | 1000         | $0.009 |

### High Level Function

For those who visualize better when they can use a function to think about how something works, here is a function of how the calculation works for OpenShift and OpenStack.

1. OpenStack = (Resource (vCPU/RAM) assigned to flavor) * (time VM has been running), rounded up to whole hour + Extra storage

!!! info "NERC's OpenStack Flavor Cost Per Hour of Wall Time"
    You can find the most up-to-date information on the current cost per hour of
    wall time of NERC's OpenStack flavor by referring to [this page](../openstack/create-and-connect-to-the-VM/flavors.md).

2. OpenShift = (Resource (vCPU/RAM) requested by Pod) * (time Pod was running),
rounded up to whole hour

### Breakdown

## CPU/GPU SU
Service Units can only be purchased as a whole unit. We will charge for Pods and
VMs on a per hour basis, for any portion of an hour they are used, and any "flavor"
is charged as a multiplier of the base SU for the maximum resource they reserve.
For example, if a PI has a Pod or VM with 1 A100 GPU but 48 vCPUs, 192MB of RAM
they would be charged for 2 A100 GPU SUs.

## Extra Storage SU
Storage included with flavors is not billed any additional storage is. For example
if you have 4 CPU SU that includes root storage which means additional storage would
be charged by the 1,000 GB/hr. For every 1,000 GB of volume storage you would be
charged 1 Extra Storage SU.


## Format

### Combined data CSV

This is the format of the csv that we will gather from ColdFront, Keycloak, OpenShift,
and OpenStack so that we can calculate the [**Monthly Billing Data**](#monthly-billing-data).

|Month|Project|PI|Institution|VM/Pod Name|vGPU Type|vGPU|vCPU|RAM|Storage|Hours|
|-----|-------|--|-----------|-----------|---------|----|----|---|-------|-----|
|     |       |  |           |           |         |    |    |   |       |     |

### Monthly Billing Data

This is the format of the data we wish to send to the billing software so that it
provides all the information they need to bill an institution and allow that institution to properly bill their PIs, and for their PIs to properly track what projects are
costing them what.

|Project|PI|Institution|Service Unit Type|Service Unit Hours|Service Unit Price|Cost|
|-------|--|-----------|-----------------|------------------|------------------|----|
|       |  |           |                 |                  |                  |    |

---
