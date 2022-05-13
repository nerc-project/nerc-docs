# Remove Volume Backups to Conserve Storage

If you find yourself low on Volume Storage please follow the steps below to
remove your old Volume Backups. If you are very low on space you can do this
every time you finish copying a new volume to the NERC. If on the other hand
you have plety of remaining space feel free to leave all of your Volume
Backups as they are.

1. SSH into the [MirrorMOC2NERC Instance][SSHMirror]. The user to use for
login is `centos`. If you have any trouble please review the SSH steps
[here][SSHMOC].

[SSHMirror]: https://nerc-project.github.io/nerc-docs/migration-moc-to-nerc/Step3/#create-a-new-moc-mirror-to-nerc-instance

## Check Remaining MOC Volume Storage

1. Log into the [MOC Dashboard][MOCDash] and go to Project > Compute >
Overview.

[MOCDash]: https://kaizen.massopen.cloud/dashboard/project/

    ![Volume Storage](images/S4_VolumeStorageMOC.png)

1. Look at the Volume Storage meter (highlighted in yellow in image above).

## Delete MOC Volume Backups

1. Gather a list of current MOC Volume Backups with the command below.

        $ openstack --os-cloud moc volume backup list
        +---------------------+------+-------------+-----------+------+
        | ID                  | Name | Description | Status    | Size |
        +---------------------+------+-------------+-----------+------+
        | <MOCVolumeBackupID> | None | None        | available |   10 |

1. Only remove Volume Backups you are sure have been moved to the NERC.
with the command below you can delete Volume Backups.

        openstack --os-cloud moc volume backup delete <MOCVolumeBackupID>

1. Repeat the [MOC Volume Backup](#delete-moc-volume-backups) section for
all MOC Volume Backups you wish to remove.

## Check Remaing NERC Volume Storage

1. Log into the [NERC Dashboard][NERCDash] and go to Project > Compute >
Overview.

[NERCDash]: https://stack.nerc.mghpcc.org/dashboard

    ![Volume Storage](images/S4_VolumeStorageNERC.png)

1. Look at the Volume Storage meter (highlighted in yellow in image above).

## Delete NERC Volume Backups

1. Gather a list of current NERC Volume Backups with the command below.

        $ openstack --os-cloud nerc volume backup list
        +---------------------+------+-------------+-----------+------+
        | ID                  | Name | Description | Status    | Size |
        +---------------------+------+-------------+-----------+------+
        | <MOCVolumeBackupID> | None | None        | available |   3  |

1. Only remove Volume Backups you are sure have been migrated to NERC Volumes.
Keep in mind that you might not have named the volume the same as on the MOC so
check your table from [Step 2][] to confirm.You can confirm what Volumes you
have in NERC with the following command.

[Step 2]: ../Step2/#moc-volume-information-table

        $ openstack --os-cloud nerc volume list
        +----------------+------------------+--------+------+----------------------------------+
        | ID             | Name             | Status | Size | Attached to                      |
        +----------------+------------------+--------+------+----------------------------------+
        | <NERCVolumeID> | <NERCVolumeName> | in-use |    3 | Attached to MOC2NERC on /dev/vda |

1. To remove volume backups please use the command below.

        openstack --os-cloud nerc volume backup delete <MOCVolumeBackupID>

1. Repeat the [NERC Volume Backup](#delete-nerc-volume-backups) section for
all NERC Volume Backups you wish to remove.

---
