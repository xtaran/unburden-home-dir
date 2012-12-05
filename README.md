Unburden Your Home Directory
============================

unburden-home-dir allows users to move cache files from browsers,
etc. off their home directory, i.e. on a local harddisk or tmpfs and
replace them with a symbolic link to the new location (e.g. on `/tmp/`
or `/scratch/`) upon login. Optionally the contents of the directories
and files can be removed instead of moved.

This is helpful at least in the following cases:

* The idea-giving case are big workstation setups where `$HOME` is on
  NFS and all those caches put an unnecessary burden (hence the name)
  on the file server since caching over NFS doesn't have the best
  performance and may clog the NFS server, too.

* A similar case, but with different purpose is reducing I/O on mobile
  devices like laptops or netbooks to extend the battery life: Moving
  browser caches etc. off the real disk into a tmpfs filesystem
  reduces the amount of disk I/O which reduces the power consumption
  of the disk.

* The other type of use cases for unburden-home-dir is to reduce disk
  space usage, e.g. on devices with small disk space but a lot of RAM
  as seen often on boxes with flash disks or early netbooks,
  especially the EeePC, where configurations with 4GB disk space and
  2GB RAM are not seldom. In this case you want to move off as many
  cache files, etc. as possible to some tmpfs filesystem,
  e.g. `/tmp/`.

* It may also help to reduce the amount of needed backup disk space by
  keeping those files in places where they don't get backed up. In
  that case it's an alternative to keeping the blacklist in your
  backup software up-to-date.

* Another pragmatic use case may be to stay — as an user — within a
  given disk quota. :-)

This project initially started as an `Xsession` hook. It now consists
of a perl script which optionally can also be called from a provided
`Xsession` hook.

While the default configuration includes no logout hook as Debian's
Xsession script, you can run `unburden-home-dir -u` to reverse the
effect of `unburden-home-dir` and to move all (moved) directories back
to your home directory.

Nevertheless unburden-home-dir was written with non-valuable data
(cache files, pid files, thumbnails, temporary data, etc.) in mind and
not for preservation of the handled data. So it is likely less
suitable for cases where the handled data should be preserved on
logout or shutdown.

See [this wiki page about application cache files][wiki] for the
detailed reasoning behind this project.

[wiki]: http://wiki.phys.ethz.ch/readme/application_cache_files
 (General thoughts about application cache files in home directories)


How To
======

The best way to introduce unburden-home-dir in your setup is the
following:

* Look through `/etc/unburden-home-dir.list` and either uncomment what
  you need globally and/or copy it to either
  `~/.unburden-home-dir.list` or `~/.config/unburden-home-dir/list`
  and then edit it there for per-user settings.

* Check in `/etc/unburden-home-dir` if the target and file name
  template suite your needs. If not either edit the file for global
  settings and/or copy it to either `~/.unburden-home-dir`or
  `~/.config/unburden-home-dir/config` and then edit it there for
  per-user settings.

* Make a dry run with

  > unburden-home-dir -n
  
  to see what `unburden-home-dir` would do. If you have `lsof`
  installed it should warn you if any of the files are currently in
  use.

  Check the above steps until you're satisfied.

* Exit all affected applications (guess them if no `lsof` is
  available, `fuser` may help if available) as opened files which
  should be moved can cause `unburden-home-dir` to fail. (May not be
  necessary if the target is on the same file system, but that's
  usually not the case.)

  Also exit shells or file browser windows (Nautilus, Konqueror, Caja,
  etc.) which have any of the to-be-unburdened directories open.

  If you use a full featured desktop (GNOME, KDE, Unity,
  Enlightenment/E17) including desktop search or similar tools which
  have some files in `~/.cache` permanently opened (Zeitgeist, gvfs,
  etc.) it's likely the best to logout from your X session and do the
  remaining steps in a failsafe session, on the text console or
  remotely via SSH.

* Run

  > unburden-home-dir

* Start your applications again.

If everything works fine, enable `unburden-home-dir` permanently,
either per user or globally for all users. See below.

Enabling unburden-home-dir Globally
-----------------------------------

If you want to enable `unburden-home-dir` for all users of a
machine.on an Xsession based login, edit
`/etc/default/unburden-home-dir` and either uncomment or add a line
that looks like this:

> UNBURDEN_HOME=yes

But please be aware that if you do that on a machine with NFS
homes, you should do that on all (Unix) machines which have those NFS
homes mounted.

Enabling unburden-home-dir Per User
-----------------------------------

For installations where each user should be able to decide on his own
if `unburden-home-dir` should be run on X session start, add a line
saying

> UNBURDEN_HOME=yes

to either `~/.unburden-home-dir` or
`~/.config/unburden-home-dir/config` (create the file if it doesn't
exist yet) which are sourced by the Xsession startup script in the
same way as `/etc/default/unburden-home-dir` (while beingq
configuration files for unburden-home-dir itself at the same time,
too).


Common Issues / Troubleshooting
===============================

* If you get error messages like

  > cannot remove directory for ~/.something/Cache: Directory not empty at /usr/bin/unburden-home-dir line 203

  there is likely a process running which still has files open in that
  directory or a subdirectory thereof.

  Exit that program and try again. `unburden-home-dir` is idempotent,
  i.e. it can be called several times without doing different things.

* In case `unburden-home-dir` moved something it wasn't expected to, you
  can try to undo all of unburden-home-dir's doing by running

  > unburden-home-dir -u

  Nevertheless this functionality is less well tested as
  unburden-home-dir's normal operation mode, so it may not be able to
  undo everything.

  unburden-home-dir's undo mode (of course) can't undo modifications
  where it has been told to remove all files and create an empty
  directory instead. See the `r` action in the Configuration Files
  section below.


Configuration Files
===================

There are three types of configuration files for unburden-home-dir:

Global Xsession Hook Configuration File
---------------------------------------

* `/etc/default/unburden-home-dir`

It is sourced by unburden-home-dir's Xsession hook and configures the
global on-login behaviour.

### Recognized Settings

* `UNBURDEN_HOME`: If set to `yes`, unburden-home-dir will run for all
  users upon X login.
* `UNBURDEN_BASENAME`: Sets the basename of the configuration files to
  use. Defaults to `unburden-home-dir`. Equivalent to the `-b`
  commandline option.

General Configuration File
--------------------------

* `/etc/unburden-home-dir` (Global configuration file)
* `~/.unburden-home-dir` (Per user configuration file)
* `~/.config/unburden-home-dir/config` (XDG style per user
  configuration file)

All three file are parsed by
[Config::File](http://search.cpan.org/dist/Config-File/) in the above
given order.

### Recognized Settings

The files may contain one or more of the following settings:

* `TARGETDIR`: To where the files should be unburdened,
  e.g. `TARGETDIR=/tmp` or`TARGETDIR=/scratch`
* `FILELAYOUT`: File name template for the target locations. `%u` is
  replaced by the user name, `%s` by the target identifier defined in
  the list file. Examples: `FILELAYOUT='.unburden-%u/%s'`,
  `FILELAYOUT='unburden/%u/%s'`

For per user activation of unburden-home-dir upon X login,
`UNBURDEN_HOME=yes` (see above) may be used in the per-user
configuration files, too.

List Files
----------

`unburden-home-dir` looks at the following places for list of files to
take care of:

* `/etc/unburden-home-dir.list` (Global list of files to take care of)
* `~/.unburden-home-dir.list` (Per user list of files to take care of)
* `~/.config/unburden-home-dir/list` (XDG style per user list of files
  to take care of)

### File Format of unburden-home-dir.list

`unburden-home-dir.list` lists files and directories to take care of and
how to take care of them.

Each lines contains space separated values. The columns are
interpreted as follows:


1. column: **Action** (`d`/`r` or `m`: delete/remove or move; the
           first two are equivalent)
2. column: **Type** (`d`, `D`, `f` or `F`: directory or file, capital
           letter means "create it if it doesn't exist")
3. column: **Path** relative to `$HOME` to move off to some other
           location.
4. column: **Identifier** for file or directory in the other
           location.

The (partial) path names given in the third and fourth column
initially must be of the type declared in the second column, i.e. you
can't list a file's name in the third column but then only give the
path to the subdirectory to where it should be unburden in the fourth
column. The fourth column must contain the path to the symlink target
itself, too.

### What To Unburden?

The Debian package comes with a lot of commented examples in
`/etc/unburden-home-dir.list`. See `etc/unburden-home-dir.list` in the
Git repository or source tar ball.

A good start for checking what kind of caches you have in your own
home directory is running

> find ~ -type d -iname '*cache*' -not -path '*/.git/*' -not -path '*/.hg/*' -print0 | xargs -0 du -sh | sort -h

Older versions of the `sort` utility (e.g. GNU Coreutils versions
before 7.5, i.e. before Debian 6.0 Squeeze) don't have the `-h`
option. In that case drop the `-h` from the `du` call as well and use
`sort -n` instead:

> find ~ -type d -iname '*cache*' -not -path '*/.git/*' -not -path '*/.hg/*' -print0 | xargs -0 du -s | sort -n

Example Configuration Files
---------------------------

See `/usr/share/doc/unburden-home-dir/examples/` on debianoid
installations or `etc/` in the source tar ball for example files.

User Contributed Examples and Setups
------------------------------------

* [Reburden on Logout](http://www.mancoosi.org/~abate/unburden-my-home-dir#comment-299)


Source Code
===========

You should always find the newest code via git at either

* [GitHub](http://github.com/xtaran/unburden-home-dir),
* the [Git Repository at D-PHYS](http://git.phys.ethz.ch/?p=unburden-home-dir.git), or
* [Gitorious](http://gitorious.org/unburden-home-dir/).

GitHub is used as primary hub, git.phys.ethz.ch is usually up-to-date,
too, Gitorious gets pushed less often, but should get all major
updates in time, too.


Author
======

[Axel Beckert](http://noone.org/abe/) <abe@deuxchevaux.org>

unburden-home-dir initially has been developed for usage at
[Dept. of Physics](http://www.phys.ethz.ch/),
[ETH Zurich](http://www.ethz.ch/).


License
=======

All stuff in here is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program in the file COPYING.  If not, see
[GNU's license web page](http://www.gnu.org/licenses/).


Thanks
======

Quite some people contributed to unburden-home-dir in one way or the
other, e.g. by being my guinea pigs, finding bugs, sending patches,
contributing to the list of files to move off, etc. or just by
[writing motivating blog postings](http://www.mancoosi.org/~abate/unburden-my-home-dir).
:-)

* Pietro Abate
* Johan van den Dorpe
* Klaus Ethgen
* Elmar Heeb
* Christian Herzog
* Carsten Hey
* Touko Korpela
* Mika Pflüger
* Patrick Schmid
* Klaus Umbach


See Also
========

Reducing Sync Calls
-------------------

### eatmydata

Another possible solution for saving non-crucial I/O is using
[eatmydata](http://www.flamingspork.com/projects/libeatmydata/) to
ignore a software's `fsync` calls.

Be careful. This may cause data loss in case of a power loss or an
operating system crash. It's called "eat my data" for a reason.

### Firefox/Gecko/XULRunner: toolkit.storage.synchronous

One notorious case of an annoyingly amount of `fsync` calls is
[Firefox](https://www.mozilla.org/firefox) and other
Mozilla/Gecko/XULRunner based programs, because they use
[SQLite](http://sqlite.org/) databases as backend for many features
(history, bookmarks, cookies, etc.).

Instead of calling `eatmydata firefox` you can use
[about:config](about:config) to set
[toolkit.storage.synchronous](http://kb.mozillazine.org/About:config_entries#Toolkit.)
to `0`. This specifies the
[SQLite disk sync mode](http://www.sqlite.org/pragma.html#pragma_synchronous)
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
instead of just diffs. Of couse this only makes sense if you have a
decent network connection.

#### I/O during upgrading packages

dpkg cares about a consistent state of files when unpacking packages,
so it instructs the kernel to sync stuff to disk quite often, too. It
hough has an option named `--force-unsafe-io` to turn this safety off.

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

Cleaning Up Your Home Directory Half-Automatically
--------------------------------------------------

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


### BleachBit

[BleachBit](http://bleachbit.sourceforge.net/) is a GUI program which …

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

[Mundus](http://www.mundusproject.org/) is GUI program which …

> […] can help you keep your /home folder clean. It keeps an internal
> database of known applications and folders, and automagically
> detects those apps that where uninstalled but left configuration
> files. Each supported application is also called a module, and each
> folder it describes is called a submodule.
