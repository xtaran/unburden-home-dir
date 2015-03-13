TODO
====

Features
--------

* Idea from Pietro Abate: Excludes for wildcards, like "all from
  `.cache/*` except `.cache/duplicity`".

* Honor `$XDG_` variables in `unburden-home-dir.list` for alternative
  locations of `.cache` and friends.

* Set `$XDG_CACHE_HOME` before other programs using this variable run,
  so that they use the wanted location even without moving files
  around or adding symlinks.

  Likely needs another `Xsession.d` file with a very low number.

* Check if there are common tasks of xdg-user-dirs (its package
  description is not so helpful there) of if it can be useful for
  unburden-home-dir. (Doesn't look that helpful on a first glance,
  though.)

* Use /run/user/$USERID as target if present. See also
  [Debian Bug-Report #780387](https://bugs.debian.org/780387).

Improvements
------------

* Add warnings if either `$HOME` or `$TARGET` do not begin with a
  slash. This can cause broken symlinks but may also break the test
  suite. :-)

* Warning if `UNBURDEN_HOME=no` or `UNBURDEN_HOME=off` is set in
  `~/.unburden-home-dir` (which would be for the `Xsession.d` hook).

* Sorting subroutines.

* Call `rsync` in dry-run mode if `unburden-home-dir` is called in
  dry-run mode instead of not calling `rsync` at all in that case.

Test Suite Coverage
-------------------

* Write test so that `mv` doesn't fall into interactive mode. Basically
  test what the previous commit ("2ec069d Unconditionally move files")
  fixed. To reproduce: Have directories to move off as well as a
  directory which is already moved off.

Planned Invasive Changes
------------------------

* Split off documentation so that it can be shipped as man pages as
  well as viewed in the web. The idea is to use something like `pandoc
  -t man -s -o README.1 README.md`

  * Maybe use POD instead of Markdown as base format.

* Find a nice way to handle the global `unburden-home-dir.list`, maybe
  by by using something like `/etc/unburden-home-dir.list.d/`,
  `/etc/unburden-home-dir/list.d/` or maybe even put symlinks to the
  (splitted) example file(s) in there.

  I've wrote a Perl interface to `run-parts` named
  [Run::Parts](https://metacpan.org/release/Run-Parts) as standalone
  Perl module which is already used by `aptitude-robot`, too.

* Use /usr/share/unburden-homed-dir/… for default settings and use
  /etc/unburden-home-dir* only for settings by the local admin.

  See https://stackoverflow.com/questions/26041056 for the reasoning
  behind this idea.

Deficiencies
------------

* Slow rsync, e.g. for cache directories.
