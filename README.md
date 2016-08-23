Unburden Your Home Directory
============================

[![Travis CI Build Status](https://travis-ci.org/xtaran/unburden-home-dir.svg)](https://travis-ci.org/xtaran/unburden-home-dir)
[![Documentation Status](https://readthedocs.org/projects/unburden-home-dir/badge/?version=latest)](https://readthedocs.org/projects/unburden-home-dir/?badge=latest)
[![Coverage Status](https://img.shields.io/coveralls/xtaran/unburden-home-dir.svg)](https://coveralls.io/r/xtaran/unburden-home-dir)
[![Gitbook Build Status](https://www.gitbook.com/button/status/book/xtaran/unburden-home-dir)](https://www.gitbook.com/book/xtaran/unburden-home-dir/activity)

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

* Another type of use cases for unburden-home-dir is to reduce disk
  space usage, e.g. on devices with small disk space but a lot of RAM
  as seen often on boxes with flash disks or early netbooks, e.g. the
  first EeePC with 4GB disk space and 2GB RAM are not seldom. In this
  case you want to move off as many cache files, etc. as possible to
  some tmpfs filesystem, e.g. `/tmp/`.

* It may also help to reduce the amount of needed backup disk space by
  keeping those files in places where they don't get backed up. In
  that case it's an alternative to keeping the blacklist in your
  backup software up-to-date.

* Another pragmatic use case may be to stay — as an user — within a
  given disk quota. :-)

This project initially started as an `Xsession` hook. It now consists
of a perl script which optionally can also be called from a provided
`Xsession` hook.

The full documentation can be read online
[at ReadTheDocs](https://unburden-home-dir.readthedocs.io/),
[at Gitbook](https://xtaran.gitbooks.io/unburden-home-dir/) or
downloaded
[as e-book at Gitbook](https://www.gitbook.com/book/xtaran/unburden-home-dir/details).


Author
------

[Axel Beckert](https://axel.beckert.ch/) <abe@deuxchevaux.org>

unburden-home-dir initially has been developed for usage at
[Dept. of Physics](https://www.phys.ethz.ch/),
[ETH Zurich](https://www.ethz.ch/).


License
-------

`unburden-home-dir` is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program in the file COPYING.  If not, see
[GNU's license web page](https://www.gnu.org/licenses/).
