Partition 5 + 6 are `/bootbank` and `/altbootbank` respectively:

```bash
[root@AW-DL3-02:~] partedUtil getptbl /dev/disks/mpx.vmhba32:C0:T0:L0
gpt
968 255 63 15564800
1 64 8191 C12A7328F81F11D2BA4B00A0C93EC93B systemPartition 128
5 8224 520191 EBD0A0A2B9E5443387C068B6B72699C7 linuxNative 0
6 520224 1032191 EBD0A0A2B9E5443387C068B6B72699C7 linuxNative 0
7 1032224 1257471 9D27538040AD11DBBF97000C2911D1B8 vmkDiagnostic 0
8 1257504 1843199 EBD0A0A2B9E5443387C068B6B72699C7 linuxNative 0
9 1843200 15564766 9D27538040AD11DBBF97000C2911D1B8 vmkDiagnostic 0
```

Create a new VFAT filesystem on the 6th partition:

[root@AW-DL3-02:~] vmkfstools -C vfat /dev/disks/

Symlink to /altbootbank

[root@AW-DL3-02:~] ln –s /vmfs/volumes/<volumeGUID> /altbootbank

Copy contents of /bootbank to /altbootbank (optional)

[root@AW-DL3-02:~] cp -r /bootbank/* /altbootbank

And save:

[root@AW-DL3-02:~] /sbin/auto-backup.sh
