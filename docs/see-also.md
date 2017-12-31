---
title: See Also
layout: page
---

See Also
========

Reducing Sync Calls
-------------------

### eatmydata

Another possible solution for saving non-crucial I/O is using
[eatmydata](https://www.flamingspork.com/projects/libeatmydata/) to
ignore a software's `fsync` calls.

Be careful. This may cause data loss in case of a power loss or an
operating system crash. It's called "eat my data" for a reason.

### Syncing browser profiles to tmpfs and back

[profile-sync-daemon](https://github.com/graysky2/profile-sync-daemon)
is a tiny pseudo-daemon designed to manage your browser's profile in
tmpfs and to periodically sync it back to your physical disc
(HDD/SSD). This is accomplished via a symlinking step and an
innovative use of rsync to maintain back-up and synchronization
between the two. One of the major design goals is a completely
transparent user experience.

Unfortunately it's said to
[only works with systemd](https://github.com/graysky2/profile-sync-daemon#note-for-version-6)
as init system. (On the other hand, it's not clear why you shouldn't
be able to call it from a hand-written `.xsession` file.)

### Firefox/Gecko/XULRunner: toolkit.storage.synchronous

One notorious case of an annoyingly amount of `fsync` calls is
[Firefox](https://www.mozilla.org/firefox) and other
Mozilla/Gecko/XULRunner based programs, because they use
[SQLite](https://sqlite.org/) databases as backend for many features
(history, bookmarks, cookies, etc.).

Instead of calling `eatmydata firefox` you can use
[about:config](about:config) to set
[toolkit.storage.synchronous](http://kb.mozillazine.org/About:config_entries#Toolkit.)
to `0`. This specifies the
[SQLite disk sync mode](https://www.sqlite.org/pragma.html#pragma_synchronous)
used by the Mozilla rendering engine.

Nevertheless `unburden-home-dir` usually doesn't help here, because
it's used for volatile data like caches while those SQLite databases
usually contain stuff you don't want to loose. But then again, setting
`toolkit.storage.synchronous` to `0` may cause database corruption if
the OS crashes or the computer loses power.

### APT/dpkg

Not related to the home directory and hence not solvable at all with
`unburden-home-dir` but nevertheless similar is the amount of sync
calls in dpkg and APT.

#### Package list Diffs

If there's too much I/O and CPU usage during `apt-get update` due to
downloading and merging a lots of diffs, you may want to set
`Acquire::PDiffs` to `false` to always download the whole package list
instead of just diffs. Of course this only makes sense if you have a
decent network connection.

#### I/O during upgrading packages

dpkg cares about a consistent state of files when unpacking packages,
so it instructs the kernel to sync stuff to disk quite often, too. It
though has an option named `--force-unsafe-io` to turn this safety off.

From dpkg's man-page about `--force-unsafe-io`:

> Do not perform safe I/O operations when unpacking. Currently this
> implies not performing file system syncs before file renames, which
> is known to cause substantial performance degradation on some file
> systems, unfortunately the ones that require the safe I/O on the
> first place due to their unreliable behaviour causing zero-length
> files on abrupt system crashes.
> 
> Note: For ext4, the main offender, consider using instead the mount
> option `nodelalloc`, which will fix both the performance degradation
> and the data safety issues, the latter by making the file system not
> produce zero-length files on abrupt system crashes with any software
> not doing syncs before atomic renames.
>
> Warning: Using this option might improve performance at the cost of
> losing data, use with care.

### Core dumps

If you want core dumps for debugging purposes, but don't want to
clutter your home directory with them,
[Corekeeper](https://packages.debian.org/corekeeper)
offers saving core dumps to `/var/crash` and also automatically cleans
them up after a week by just installing one Debian package.


Cleaning Up Your Home Directory Half-Automatically
--------------------------------------------------

### Autotrash

> [Autotrash](https://bneijt.nl/pr/autotrash/) is a simple Python
> script which will purge files from your trash based on their age or
> the amount of free space left on the device. Using autotrash -d 30
> will delete files which have been in the trash for more then 30
> days.

### BleachBit

[BleachBit](https://www.bleachbit.org/) is a GUI program which …

> […] quickly frees disk space and tirelessly guards your
> privacy. Free cache, delete cookies, clear Internet history, shred
> temporary files, delete logs, and discard junk you didn't know was
> there. Designed for Linux and Windows systems, it wipes clean 90
> applications including Firefox, Internet Explorer, Adobe Flash,
> Google Chrome, Opera, Safari,and more. Beyond simply deleting files,
> BleachBit includes advanced features such as shredding files to
> prevent recovery, wiping free disk space to hide traces of files
> deleted by other applications, and vacuuming Firefox to make it
> faster.

### Mundus

[Mundus](https://sebikul.github.io/mundus/) is GUI program which …

> […] can help you keep your /home folder clean. It keeps an internal
> database of known applications and folders, and automagically
> detects those apps that where uninstalled but left configuration
> files. Each supported application is also called a module, and each
> folder it describes is called a submodule.

### Computer Janitor

[Computer Janitor](https://launchpad.net/computer-janitor) was a
command-line and GUI program to …

> … clean up a system so it's more like a freshly installed one.
>
> Over time, a computer system tends to get cluttered. For example,
> software packages that are no longer needed can be uninstalled.
> When the system is upgraded from release to release, it may miss out
> on configuration tweaks that freshly installed systems get.
>
> Computer Janitor is an application to fix these kinds of problems.
> It attempts to find software packages that can be removed, and tweak
> the system configuration in useful ways.

Unfortunately its development has stalled, it doesn't work together
with current APT versions and it has been removed from Debian and
recent Ubuntu releases.

### rmlint

[rmlint](https://rmlint.readthedocs.io/) is a commandline program
(with optional GUI) which …

> finds space waste and other broken things on your filesystem and
> offers to remove it. It is able to find:
>
> * Duplicate files & directories.
> * Nonstripped Binaries
> * Broken symlinks.
> * Empty files.
> * Recursive empty directories.
> * Files with broken user or group id.
