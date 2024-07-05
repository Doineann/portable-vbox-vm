# Portable-VBox-VM

**Run a _VirtualBox_ VM from a removable drive in Windows.**

This bundle of `.cmd` scripts will let you run a _VirtualBox_ VM from any removable drive, or really any location with a driveletter mapped to it, such as usb-drives, external harddisks, network shares, etc...

## Requirements

Windows with a pre-installed version of VirtualBox (version 7.x.x) and a prepared VM.

## Prepare and configure your VM

First, a quick overview and description of the files and folders that come with this repository:

- `📁 Scripts` -> supporting script files
- `📁 Shared` -> shared folder
- `📁 VM` -> folder to contain the VM files
- `📟 Compact.cmd` -> command to compact the VM harddisk
- `📝 Config.ini` -> configuration file
- `📄 README.md` -> this readme
- `📟 Run.cmd` -> runs the VM in immutable mode
- `📟 RunMutable.cmd` -> runs the VM in mutable mode

To prepare your VM for transfer to the removable medium:

1. Copy **ALL** the files and folders of this repository to any location on a removable drive.
2. Make sure the VM has **no snapshots!** or that they have been merged. 
   > [!WARNING] Any remaining snapshots will end up being removed!!
3. Make sure the VM has only has **1 harddisk** attached to **SATA port 0**.
4. Modify the `📝 Config.ini` and enter the right information for your VM:

```bash
VM_NAME=VirtualMachine

VM_VBOX_UUID=0d5ecb7b-e2df-4110-8899-fa02fa5ce780
VM_VBOX_FILE=VirtualMachine.vbox

VM_HDD_UUID=94b2fd99-d68c-4428-bca7-c0f999c1a431
VM_HDD_FILE=VirtualMachine.vdi

VM_SHARE_NAME=vboxshare
VM_SHARE_RELATIVE_PATH=Shared
```
> [!NOTE]
>   - Find the `VM_HDD_UUID` for the harddisk in **VirtualBox**, by finding it via `File>Tools>Virtual Media Manager`, selecting the disk -> right-click -> `Properties` , then the Information tab. 
>   - Determine the name and `VM_VBOX_UUID` by opening the VM's `.vbox` file in an editor. <br>(**OPTIONAL:** you can change the name of the VM and it's files or even it UUID if so desired)
>   - Choose a name for `VM_SHARE_NAME` and modify, relocate or rename the `📁 Shared` folder as you wish, and configure its relative path with `VM_SHARE_RELATIVE_PATH`.

5. Detach the VM from VirtualBox, if it still is.
6. Detach any remaining media/harddisks related to the VM in `File>Tools>Virtual Media Manager`.
7. Put all your VM files (`.vbox\.vdi\.vmdk` etc...) in the `📁 VM` folder. 
8. Run the VM with `📟 Run.cmd` or `📟 RunMutable.cmd`!

## How it works

Effectively this tool just automates the following steps when temporary running a VM from a 'remote' location within an already installed version of VirtualBox on Windows:

1. Registers the VM within VirtualBox
2. Attach the configured shared folder to the VM
3. Attach the virtual harddisk, either as mutable or immutable
4. Runs the VM
5. Waits for the VM to be stopped
6. Detach the harddisk
7. Detach the shared folder
8. Removes the harddisk and it's snapshots from the VirtualBox (snapshots will be removed)
9. Unregisters the VM

The shared folder can typically be used for read/write storage, while the VM itself can be run in an immutable state. Configuration is done via `📝 Config.ini`.

## Some Tips

Use `📟 RunMutable.cmd` **only** when you actually want to make changes to (or update) the guest OS in the VM. Use the Shared folder for storage of data that needs to be accessible and mutable from within both the guest and host OS.
 	
Use `📟 Compact.cmd` utility to reduce the size of the virtual harddisks of the guest OS. Before doing this, make sure to clean up the guest OS, and, ideally, also 'zero clear' it's partitions (i.e. overwriting all unused space with zeros), so the disk can be compacted as much as possible.

Each of the script files under `📁 Scripts` can be run separately. See `Scripts\StartScript.cmd` for an example of the order in which they are normally ran. This can be useful for (step-by-step) debugging or when something may have gone wrong, like, for example when a previous run got interrupted and the VM didn't get properly unregistered with VirtualBox.

## Known Limitations/Issues

- > [!WARNING] Snapshots are not supported yet and will be removed!
- Only 1 virtual disk is supported.
- The virtual disk is assumed to be connected to SATA port 0.
- Only 1 shared folder (with a relative path) can be configured with this tool.
- The shared folder is not auto-mounted, so you'll need to mount it yourself in the Guest OS (see below!).
- The shared folder is always mounted as read/write.
- The guest OS mount point for the shared folder cannot be specified yet

## TODOs / Potential Future Improvements 

- Make `--automount` and `--readonly` for the shared folder configurable in the config file.
- Add the ability to specify the guest OS mount point in the config file.
- Automatically determine the UUIDs for VM and disks.
- Add ability to add a few virtual harddisks in either mutable or immutable mode.
- Support for disks different than SATA (e.g. IDE, SCSI, nVME)
- Find a way to support snapshots.

## Extra: How to mount the shared folder under a Linux Guest-OS

To mount a shared folder named `vboxshare` under Linux:

```bash 
mkdir /home/<user>/shared
sudo mount -t vboxsf -o uid=1000,gid=1000 vboxshare /home/<user>/shared  
```

Or mount the share at boot by putting it in `/etc/fstab`:

```
vboxshare    (/mnt/shared)    vboxsf    defaults,uid=(1000),gid=(1000),umask=0022    0    0
```

Note that for this to work edit `/etc/module` to add `vboxsf` so that it is present at boot-time.

**Also:** In case we enabled auto-mounting those shared folders will automatically be mounted in the guest OS with mount point `/media/sf_vboxshare`. To have access to these folders users in the guest need to be a member of the group `vboxsf`.

```bash
sudo usermod -aG vboxsf $USER
```
