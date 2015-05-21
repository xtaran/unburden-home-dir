unburden-home-dir(1) -- unburdens home directories from caches and trashes
==========================================================================

SYNOPSIS
--------

`unburden-home-dir` [ `-n` | `-u` | `-f` _filter_ ]  
`unburden-home-dir` ( `-h` | `--help` | `--version` )

DESCRIPTION
-----------

unburden-home-dir unburdens the home directory from files and
directory which cause high I/O or disk usage but are neither important
if they are lost, e.g. caches or trash directory.

When being run it moves the files and directories given in the
configuration file to a location outside the home directory,
e.g. `/tmp` or `/scratch`, and puts appropriate symbolic links in the
home directory instead.

OPTIONS
-------

* `-b`:
  use the given string as basename instead of "unburden-home-dir".

* `-c`:
  read an additional configuration file.

* `-C`:
  read only the given configuration file

* `-f`:
  just unburden those directory matched by the given filter (a perl
  regular expression) — it matches the already unburdened directories
  if used together with `-u`.

* `-F`:
  Do not check for files in use with lsof before (re)moving files.

* `-l`:
  read an additional list file

* `-L`:
  read only the given list file

* `-n`:
  dry run (show what would be done)

* `-u`:
  undo (reverse the functionality and put stuff back into the home
  directory)

* `-h`, `--help`:
  show this help

* `--version`:
  show the program's version

EXAMPLES
--------

Example configuration files can be found at
`/usr/share/doc/unburden-home-dir/examples/` on Debian-based systems
and in the `etc/` directory of the source tar ball.

FILES
-----

`/etc/unburden-home-dir`, `/etc/unburden-home-dir.list`,
`~/.unburden-home-dir`, `~/.unburden-home-dir.list`,
`~/.config/unburden-home-dir/config`,
`~/.config/unburden-home-dir/list`, `/etc/default/unburden-home-dir`,
`/etc/X11/Xsession.d/95unburden-home-dir`

Read the documentation at either
`/usr/share/doc/unburden-home-dir/html/` on debianoid installations,
at http://unburden-home-dir.readthedocs.org/ online, or in the `docs/`
directory in the source tar ball for an explanation of these files.

SEE ALSO
--------

[corekeeper](http://packages.debian.org/corekeeper), autotrash(1),
agedu(1), bleachbit(1). [mundus](http://www.mundusproject.org/).
computer-janitor(1).

Of, course, du(1) can help you to find potential files or directories
to handle by unburden-home-dir, but there are quite some du(1)-like
tools out there which are way more comfortable, e.g. ncdu(1)
(text-mode), baobab(1) (GNOME), filelight(1) (KDE), xdiskusage(1) (X
tool calling du(1) itself), or xdu(1) (X tool reading du(1) output
from STDIN).

AUTHOR
------

Unburden Home Dir is written and maintained by Axel Beckert
<beckert@phys.ethz.ch>.

LICENSE
-------

Unburden Home Dir is available under the terms of the GNU General
Public License (GPL) version 2 or any later version at your option.
