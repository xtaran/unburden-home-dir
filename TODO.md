TODO
====

Features
--------

* Idea from Pietro Abate: Excludes for wildcards, like "all from
  `.cache/*` except `.cache/duplicity`".

* `$XDG_` related stuff:

  * Honor
    [`$XDG_` variables](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables)
    in `unburden-home-dir.list` for alternative locations of `.cache`
    and friends.

  * Use `/run/user/$USERID` aka `$XDG_RUNTIME_DIR` as target if
    present. See also
    [Debian Bug-Report #780387](https://bugs.debian.org/780387).

  These features likely all will need expansion of environment
  variables in configuration files or values. This could be
  implemented using e.g.
  [`String::Expand`](https://metacpan.org/pod/String::Expand) or
  [`String::Interpolate::Shell`](https://metacpan.org/pod/String::Interpolate::Shell),
  but so far neither is packaged for Debian. `String::Expand` seems
  the simpler one. The additional features of
  `String::Interpolate::Shell` are currently not needed.

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

* Use /usr/share/unburden-home-dir/… for default settings and use
  /etc/unburden-home-dir* only for settings by the local admin.

  See https://stackoverflow.com/questions/26041056 for the reasoning
  behind this idea.

Deficiencies
------------

* Slow rsync, e.g. for cache directories.
