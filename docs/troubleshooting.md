---
layout: page
---

Troubleshooting
===============

Common Issues
-------------

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

* See also the current
  [TODO list](todo/)
  for known deficiencies, planned features and various ideas.
