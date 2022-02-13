---
title: Configuration Files
layout: page
---

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
[Config::File](https://metacpan.org/release/Config-File/) in the above
given order.

### Recognized Settings

The files may contain one or more of the following settings:

* `TARGETDIR`: To where the files should be unburdened,
  e.g. `TARGETDIR=/tmp` or`TARGETDIR=/scratch`
* `FILELAYOUT`: File name template for the target locations.
* `UNBURDEN_HOME`: For per user activation of unburden-home-dir upon X
  login, `UNBURDEN_HOME=yes` (see above) may be used in the per-user
  configuration files, too.

### Format Strings

The `FILELAYOUT` variable knows about these format strings replaced by
the according values from the user running `unburden-home-dir`:

* `%u` is replaced by the user name.
* `%i` is replaced by the user id.
* `%s` is replaced by the target identifier defined in
  the list file.

### Examples

* `FILELAYOUT='.unburden-%u/%s'`
* `FILELAYOUT='unburden/%u/%s'`
* `FILELAYOUT='%i/unburden/%s` (Example for `TARGETDIR=/run/user`)


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

Or check
[Mundus Project's modules](https://github.com/sebikul/mundus/tree/master/modules)
which cache files they would clean up.

Example Configuration Files
---------------------------

See `/usr/share/doc/unburden-home-dir/examples/` on debianoid
installations or `etc/` in the source tar ball for example files.

User Contributed Examples and Setups
------------------------------------

* [Reburden on Logout](https://web.archive.org/web/20160411153731/www.mancoosi.org/~abate/unburden-my-home-dir#comment-299)
