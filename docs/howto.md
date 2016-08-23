---
---

Getting Started
===============

The best way to introduce unburden-home-dir in your setup is the
following:

* Look through `/etc/unburden-home-dir.list` and either uncomment what
  you need globally and/or copy it to either
  `~/.unburden-home-dir.list` or `~/.config/unburden-home-dir/list`
  and then edit it there for per-user settings.

* Check in `/etc/unburden-home-dir` if the target and file name
  template suite your needs. If not either edit the file for global
  settings and/or copy it to either `~/.unburden-home-dir` or
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

This will also set `$XDG_CACHE_HOME` to a subdirectory of
unburden-home-dir's target directory.

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
