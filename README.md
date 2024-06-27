# Portable-VBox-VM

**Run a _VirtualBox_ VM from a removable drive in Windows.**

This bundle of `.cmd` scripts will let you run a _VirtualBox_ VM from any removable drive, or really any location with a driveletter mapped to it, such as usb-drives, external harddisks, network shares, etc...

## Requirements

Windows with a pre-installed version of VirtualBox (version 7.x.x) and a prepared VM.

## How to use

First, a quick overview and description of the files and folders that come with this repository:

- `📁 Scripts` -> supporting script files
- `📁 Shared` -> shared folder
- `📁 VM` -> folder to contain the VM files
- `📟 Compact.cmd` -> command to compact the VM harddisk
- `📝 Config.ini` -> configuration file
- `📄 README.md` -> this readme
- `📟 Run.cmd` -> runs the VM in immutable mode
- `📟 RunMutable.cmd` -> runs the VM in mutable mode

1. Copy the whole repository to any location on a removable drive.
   
2. Put your VM's files (`.vbox\.vdi\.vmdk` etc...) in the `📁 VM` folder. 
   
3. Modify the `📝 Config.ini` and enter the right information for your VM and setup:

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
> - The `VM_VBOX_UUID` can be found inside the `.vbox` file of the VM.
> - The `VM_HDD_UUID` can be found via `File>Tools>Virtual Media Manager` in VirtualBox, selecting the disk, then the `Information` tab.

3. Choose a name for `VM_SHARE_NAME` and modify, relocate or rename the `📁 Shared` folder as you wish, and configure its relative path with `VM_SHARE_RELATIVE_PATH`.
   
4. Make sure the VM is **NOT** registered (anymore) within your VirtualBox installation.
   
5. Run the VM with `📟 Run.cmd` or `📟 RunMutable.cmd`.

## How it works

Effectively this tool just automates the following steps when temporary running a VM from a 'remote' location within an already installed version of VirtualBox on Windows:

1. Registers the VM within VirtualBox
2. Attach the configured shared folder to the VM
3. Attach the virtual harddisk (mutable or immutable) to the VM and VirtualBox Media Manager
4. Runs the VM
5. Waits for the VM to be stopped
6. Detach the harddisk
7. Detach the shared folder
8. Removes the harddisk and it's snapshots from the VirtualBox Media Manager
9. Unregisters the VM

The shared folder can typically be used for read/write storage, while the VM itself can be run in an immutable state. Configuration is done via `📝 Config.ini`. 

## Some Tips

Use `📟 RunMutable.cmd` **only** when you actually want to make changes to (or update) the guest OS in the VM. Use the Shared folder for storage of data that needs to be accessible and mutable from within both the guest and host OS.
 	
Use `📟 Compact.cmd` utility to reduce the size of the virtual harddisks of the guest OS. Before doing this, make sure to clean up the guest OS, and, ideally, also 'zero clear' it's partitions (i.e. overwriting all unused space with zeros), so the disk can be compacted as much as possible.

Each of the script files under `📁 Scripts` can be run separately. See `Scripts\StartScript.cmd` for an example of the order in which they are normally ran. This can be useful for (step-by-step) debugging or when something may have gone wrong, like, for example when a previous run got interrupted and the VM didn't get properly unregistered with VirtualBox.

## Mounting the shared folder under a Linux guest OS

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

## Known Limitations/Issues

- Only 1 shared folder can be configured with this tool (and have a path on the removable drive). Permanent shares can still be added as well.
- The shared folder is not auto-mounted, so you'll need to mount it yourself in the Guest OS.
- The shared folder is always mounted as read/write.
- The guest OS mount point for the shared folder can not be specified yet

**TODOs:** 

- Make `--automount` and `--readonly` for the shared folder configurable in the config file.
- Add the ability to specify the guest OS mount point in the config file.
