---
title: Overview
layout: page
---

Unburden Your Home Directory
============================

`unburden-home-dir` allows users to move cache files from browsers,
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
  devices like laptops or netbooks to extend the battery life or
  reduce the wearing down of CF or SD cards, e.g. in single board
  computers like the [Raspberry Pi](https://www.raspberrypi.org/) or
  [ALIX](http://www.pcengines.ch/alix.htm) or
  [APU](http://www.pcengines.ch/apu.htm) boards: Moving browser caches
  etc. off the real disk into a tmpfs filesystem reduces the amount of
  disk I/O which reduces the power consumption of the disk.

* Another type of use case for unburden-home-dir is to reduce disk
  space usage, e.g. on devices with small disk space but a lot of RAM
  as seen often on boxes with flash disks or early netbooks, e.g. the
  first EeePC with 4GB disk space and 2GB RAM. In this case you want
  to move off as many cache files, etc. as possible to some tmpfs
  filesystem, e.g. `/tmp/`.

* It may also help to reduce the amount of needed backup disk space by
  keeping those files in places where they don't get backed up. In
  that case it's an alternative to keeping the blacklist in your
  backup software up-to-date.

* Another pragmatic use case may be to stay — as a user — within a
  given disk quota. :-)

This project initially started as an `Xsession` hook. It now consists
of a perl script which optionally can also be called from a provided
`Xsession` hook.

While the default configuration includes no logout hook as Debian's
Xsession script, you can run `unburden-home-dir -u` to reverse the
effect of `unburden-home-dir` and to move all (moved) directories back
to your home directory.

Nevertheless `unburden-home-dir` was written with non-valuable data
(cache files, pid files, thumbnails, temporary data, etc.) in mind and
not for preservation of the handled data. So it is likely less
suitable for cases where the handled data should be preserved on
logout or shutdown.

See [this wiki page about application cache files][wiki] for the
detailed reasoning behind this project.

[wiki]: https://readme.phys.ethz.ch/linux/application_cache_files/
 (General thoughts about application cache files in home directories)


Documentation
-------------

* [Installation and Dependencies](installation)
* [Getting Started](howto)
* [Configuration](configuration)
* [Troubleshooting](troubleshooting)
* [Source Code](source-code)
* [License, Copyright and Author](license)
* [Contact and Community](contact)
* [Plans, Known Issues, TODO](todo)
* [Bugs](bugs)
* [Quality Assurance](qa)
* [See Also](see-also)
* [Manual page unburden-home-dir(1)](unburden-home-dir.1)

Talks about Unburden Your Home Directory
----------------------------------------

* [Talks given about Unburden Your Home Directory in German](https://noone.org/talks/unburden/)
  (external)
* [GitPitch Slides about Unburden Your Home Directory](https://gitpitch.com/xtaran/unburden-home-dir)
