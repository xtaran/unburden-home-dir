TODO
====

* Add warnings if either `$HOME` or `$TARGET` do not begin with a
  slash. This can cause broken symlinks but may also break the test
  suite. :-)

* Idea from Pietro Abate: Excludes for wildcards, like "all from
  `.cache/*` except `.cache/duplicity`".

* Honor `$XDG_` variables in `unburden-home-dir.list` for alternative
  locations of `.cache` and friends.

* Set `$XDG_CACHE_HOME` before other programs using this variable run,
  so that they use the wanted location even without moving files
  around or adding symlinks.

  Likely needs another `Xsession.d` file with a very low number.

* Write test so that `mv` doesn't fall into interactive mode. Basically
  test what the previous commit ("2ec069d Unconditionally move files")
  fixed. To reproduce: Have directories to move off as well as a
  directory which is already moved off.

* Warning if `UNBURDEN_HOME=no` or `UNBURDEN_HOME=off` is set in
  `~/.unburden-home-dir` (which would be for the `Xsession.d` hook).

* Sorting subroutines.

* Split off documentation so that it can be shipped as man pages as
  well as viewed in the web. The idea is to use something like `pandoc
  -t man -s -o README.1 README.md`

  * Maybe use POD instead of Markdown as base format.

* `find | buffer | xargs lsof -F c` (bin/unburden-home-dir:325) will
  find the `find` process if the list of files output by `find` is
  larger than 1 MB, so that `buffer` starts piping them to `xargs`
  before `find` finishes. `xargs` will then split up the list and call
  `lsof` more than once, which again will list the `find` process as
  having the directory open.

  Possible solutions:

  * Store `find` output in a temporary file and then `cat` that file
    to `xargs`. Should use `mktemp` and friends.

  * Use a bigger buffer size for `buffer`. Can't be infinite,
    i.e. just delays the issue to even bigger directories.

* Call `rsync` in dry-run mode if `unburden-home-dir` is called in
  dry-run mode instead of not calling `rsync` at all in that case.

* Find a nice way to handle the global `unburden-home-dir.list`, maybe
  by by using something like `/etc/unburden-home-dir.list.d/` or maybe
  even put symlinks to the (splitted) example file(s) in
  `/etc/unburden-home-dir.list.d/`.

  I've wrote a Perl interface to `run-parts` named
  [Run::Parts](https://metacpan.org/release/Run-Parts) as standalone
  Perl module which is planned to be used by `aptitude-robot`, too.

* Check if there are common tasks of xdg-user-dirs (its package
  description is not so helpful there) of if it can be useful for
  unburden-home-dir.

* Slow find/rsync, e.g. "sh -c find
  '/home/abe/.conkeror.mozdev.org/conkeror/$FOO/Cache' -print0 | xargs
  -0 lsof -F c"

* lsof should ignore the find processes which generates its
  parameters: "WARNING: Can't handle
  /home/abe/.conkeror.mozdev.org/conkeror/$FOO/Cache: in use, not
  (re)moving. Process list: 12855 (find)"
