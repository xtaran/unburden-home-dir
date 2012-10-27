TODO
====

* Add warnings if either `$HOME` or `$TARGET` do not begin with a
  slash. This can cause broken symlinks but may also break the test
  suite. :-)

* Idea from Pietro Abate: Excludes for wildcards, like "all from
  `.cache/*` except `.cache/duplicity`".

* Honor `$XDG_` variables for unburden-home-dir's own configuration
  files (at least optional), but possibly also in
  `unburden-home-dir.list` for alternative locations of `.cache` and
  friends.

* Write test so that `mv` doesn't fall into interactive mode. Basically
  test what the previous commit ("2ec069d Unconditionally move files")
  fixed. To reproduce: Have directories to move off as well as a
  directory which is already moved off.

* Warning if `UNBURDEN_HOME=no` or `UNBURDEN_HOME=off` is set in
  `~/.unburden-home-dir` (which would be for the `Xsession.d` hook).

* Sorting and commenting subroutines.

* Split off documentation so that it can be shipped as man pages as
  well as viewed in the web. The idea is to use something like `pandoc
  -t man -s -o README.1 README.md`

* `find | xargs lsof -F c` (bin/unburden-home-dir:325) will find the
  `find` process if the list of files output by `find` is so long that
  `xargs` will split up the list and call `lsof` more than once.

  Possible solutions:

  * Store `find` output in a temporary file and then `cat` that file
    to `xargs`. Should use `mktemp` and friends.

  * Use the command `buffer`. Needs a maximum value, i.e. just delays
    the issue to even bigger directories.

* Call rsync in dry-run mode if unburden-home-dir is called in dry-run
  mode instead of not calling rsync at all in that case.
