Run install script as sudo

```
curl -fsSL https://raw.githubusercontent.com/iansedano/config/refs/heads/main/setup/fedora-setup/install-sudo.sh | sudo bash
```

```bash
gh auth login
mkdir dev
cd dev
mkdir iansedano
cd iansedano
gh clone config
gh clone wtf
gh clone git-journal
```

download dropbox rpm from site and install manual

Make links to configs

Zoom from website
Idea from website

gitahead
curl -o- https://github.com/gitahead/gitahead/releases/download/v2.6.3/GitAhead-2.6.3.sh | bash

For waiting for DB to download

```bash
while true; do dropbox status; sleep 10; done
# Ctrl + C to exit
```

create symbolic links (from obsolete linux configs repo)

```bash
ln -sf source target
```

link symbolic force(replace target) source(file in repo) target(home folder)

```bash
sudo systemctl enable mysqld
sudo systemctl start mysqld
sudo mysql_secure_installation
sudo mysql -u root -p
```

## Getting notifications to work on i3

if using i3, see https://gitlab.xfce.org/apps/xfce4-notifyd/-/issues/35 for notifications

to find executable:

`find / -name xfce4-notifyd 2>/dev/null`

Then just run it

`/` (root): This is the root directory of your system. All files and directories start from the root directory, apart from /boot (in some cases) and /dev. A size of around 25-30GB should be more than enough for most users. This partition should use a Linux filesystem such as ext4.

`swap`: The swap space is used when your system runs out of RAM. The kernel then starts moving inactive pages from the RAM into the swap space. It also plays a crucial role if you want to hibernate your system, as the contents of RAM are copied to swap space before the system shuts down. The size of the swap partition depends on your system's RAM. A rule of thumb is to make swap size equal to your RAM size, or a little more if you plan on using hibernation.

**Btrfs** is a file system with integrated features that resemble those of LVM, including snapshots, volume management, and checksums.
LVM is a method of managing physical storage that is not a file system in itself, but provides flexibility in disk management. It includes features such as volume resizing and snapshots.

**LVM** Thin Provisioning is a feature of LVM that allows for the over-provisioning of physical storage space, allocating space only when data is written.

Each of these technologies has its pros and cons, and the choice between them depends on your specific use case, familiarity, and comfort level with the technology.

overview of typical mount points in a Linux system:

`/` (Root): The root directory is the top level of the filesystem. All other directories are under this one in a Linux system. All the files and directories start from the root directory, except for /boot and /dev in some cases. In terms of size, 20-30GB is typically more than enough for most users, though it may vary based on what applications and services you plan on running.

`/home`: The /home directory contains a home folder for each user. User-specific data such as documents, downloads, pictures, and the user-specific configuration files (hidden files and folders starting with a dot) are stored here. The size you allocate to /home depends largely on personal needs, but it usually takes up the majority of your drive.

`/boot`: The /boot directory contains the files needed to boot the system, such as the Linux kernel, initrd image, and the bootloader (GRUB). This directory only needs to be a separate partition if you're using encryption or a filesystem that GRUB doesn't support. Size-wise, 500MB is generally more than enough.

`/var`: The /var directory stores variable data like system logs, databases, websites, and email, among other things. This can become quite large for servers, so some choose to make it a separate partition to prevent system failure due to lack of disk space if the logs take up more space than planned. The size depends on the nature of your system; for a desktop system, typically it will be included in the root (/) partition.

`/tmp`: The /tmp directory is used for temporary files stored by the system and some applications. It's often stored in RAM or as a part of the root (/) partition and is cleared out at each reboot. Some choose to make it a separate partition for security reasons or to control the maximum size.

`/usr`: The /usr directory is the largest directory on a Linux system. It contains all the user binaries, their documentation, libraries, header files, etc. In modern systems, /usr is typically included in the root (/) partition.

`/swap`: The swap space is not really a "directory" or mount point in the filesystem hierarchy, but it's an important part of any Linux installation. Swap space is used when your system runs out of RAM. The kernel starts moving inactive pages from the RAM into the swap space. Swap space can also be used for hibernation. The size of the swap partition is usually equal to or double the amount of RAM on your system, depending on if you plan to use hibernation (needs space equal to the size of your RAM) and the amount of RAM in your system.

You can check the partitions on your Linux system using the following commands:

`lsblk`: The lsblk command (list block devices) lists all block devices (hard drives, flash drives, etc.) in a tree-like format by default. Run it without any options like this:

It's absolutely possible to just have a `swap` and `/` (root) partition and not a separate `/home` partition when setting up Linux.

The advantage of having a separate `/home` partition is mostly when you need to reinstall your system or switch to another Linux distribution. If `/home` is a separate partition, your personal files are preserved even if you reformat the `/` partition. However, if `/home` is part of the `/` (root) partition, everything gets wiped if you reformat or reinstall.

laptop `lsblk` output

```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    1     0B  0 disk
zram0       252:0    0     8G  0 disk [SWAP]
nvme0n1     259:0    0   1.8T  0 disk
├─nvme0n1p1 259:1    0   200M  0 part /boot/efi
├─nvme0n1p2 259:2    0 488.3G  0 part
└─nvme0n1p3 259:3    0   1.3T  0 part /
```

break down what each line in your lsblk output is showing:

`sda`: This is typically a SATA hard drive, but it's showing as having 0B size. This could be an unformatted drive, a card reader with no card inserted, or an empty USB port.

`zram0`: This is a virtual block device, often used for swap space to increase performance. In your case, this device is used for swap and it's 8GB in size.

`nvme0n1`: This is an NVMe drive (a type of fast SSD connected over PCIe) that has a total size of 1.8TB. The drive is partitioned into three partitions (nvme0n1p1, nvme0n1p2, and nvme0n1p3):

`nvme0n1p1`: This is a 200MB partition mounted at /boot/efi, which indicates that this is the EFI System Partition (ESP). This partition is used for storing boot loaders and other files needed for booting the system in EFI mode.

`nvme0n1p2`: This is a 488.3GB partition which doesn't have a specified mount point. It's not currently mounted, or it could be a swap partition, or maybe a partition for another OS if you're dual booting.

`nvme0n1p3`: This is a 1.3TB partition, which is mounted as root /. This partition is where all your system, application, and (assuming you don't have a separate /home partition) user data are stored.

The MAJ:MIN numbers are the major and minor device numbers, which are used by the system to uniquely identify different types of devices.

RM indicates whether the device is removable (1 means it is, 0 means it isn't).

RO indicates whether the device is read-only (1 means it is, 0 means it isn't).

TYPE tells you what type the device is (disk indicates a physical disk, part means it's a partition).

Finally, MOUNTPOINTS shows where the device is mounted in the filesystem. If this is empty for a partition, it means it isn't currently mounted.

/boot/efi is typically where the EFI System Partition (ESP) is mounted.
/boot is typically where the Linux kernel and initial ramdisk reside.
The reason for recommending /boot earlier was under the assumption of a typical system setup, but as with many things in Linux, the configuration can vary based on a number of factors including the specifics of the hardware and the choices made during installation.

/boot/efi: Around 200MB to 500MB should be more than enough for the EFI System Partition (ESP). This partition should be formatted with the FAT32 file system.

/: You can allocate the majority of the remaining disk space to your root partition.

swap: A swap partition can be created with a size comparable to the amount of RAM in your system. For systems with a large amount of RAM (e.g., 16GB or more), you might opt for a smaller swap partition, unless you plan on using hibernation, which requires a swap partition at least as large as your RAM.

Remember that Fedora installer allows you to create these partitions and mount points during the installation process. It's also advisable to double-check if your desktop uses UEFI for booting, as the ESP partition is specific to UEFI systems.

Finally, remember to back up any important data before partitioning or formatting any drive, as these operations can result in data loss if not done carefully.

Yes, most modern computers do indeed use UEFI (Unified Extensible Firmware Interface) as it offers several advantages over the traditional BIOS (Basic Input/Output System) system.

However, while it's the default for most new computers, not every machine will use UEFI, especially older systems or certain custom configurations.

For example, on Linux, you can check for the existence of the directory /sys/firmware/efi. If it exists, you are on a UEFI system.

You can use the du (disk usage) command in combination with other options to get a human-readable summary of disk usage by directory. However, the du command can take a long time to run, because it recursively scans all subdirectories to calculate total disk usage.

sudo du -sh /\* 2> /dev/null

s: summarize and include only the total size for each directory.
h: print sizes in human-readable format (e.g., KB, MB, GB).
/\*: check all directories in the root directory.
2> /dev/null: redirect error messages (like permission denied) to /dev/null so they're not shown in the output.
This command will print the total size of each directory in the root (/) directory in a format that's easy to read.

You generally should not remove the existing EFI System Partition (ESP) that was installed by Windows. If you're planning to dual-boot Windows and Fedora, both operating systems can use the same EFI System Partition to store their bootloaders. Deleting this partition would make Windows unbootable until its bootloader is repaired.

When you install Fedora, the installer will detect the existing EFI System Partition and add the Fedora bootloader to it. This should not interfere with Windows' ability to boot.

The ESP is usually large enough (often around 100MB to 500MB) to hold the bootloaders of multiple operating systems, so there is no need to create a new one unless you're running out of space, which is unlikely.

During the Fedora installation, when you're assigning mount points, make sure to set the existing EFI System Partition to mount at /boot/efi without formatting it. The installer's partitioning tool should automatically detect the ESP as such, but double check to make sure it's not set to be formatted. If it's formatted, the Windows bootloader would be erased.

As for the root account, Fedora disables it by default and it's generally a good idea to leave it that way. If you enable the root account and set a password, it becomes a potential target for malicious users or software.
