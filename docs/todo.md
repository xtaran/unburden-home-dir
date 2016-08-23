---
---

TODO
====

Features
--------

* Idea from Pietro Abate: Excludes for wildcards, like "all from
  `.cache/*` except `.cache/duplicity`".

* `$XDG_` related stuff:

  * Honor
    [`$XDG_` variables](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables)
    in `unburden-home-dir.list` for alternative locations of `.cache`
    and friends.

  These features likely all will need expansion of environment
  variables in configuration files or values.

  The expansion of environment variables in configuration files is
  implemented since the version 0.4 using
  [`String::Expand`](https://metacpan.org/pod/String::Expand) which is
  packaged for Debian since recently, but may still be missing in
  Ubuntu. Still needs to be documented properly, though.

* Make the dependency on rsync and File::Rsync optional by allowing a
  mode where only deletion and no moving happens.

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

Planned Default Setting Changes
-------------------------------

* Currently calling unburden-home-dir via Xsession.d is disabled by
  default and all default list entries are commented, too.

  This double disabling is redundant. At most unburden-home-dir's
  functionality should be disabled at one of those locations.

Planned Invasive Changes
------------------------

* Find a nice way to handle the global `unburden-home-dir.list`, maybe
  by using something like `/etc/unburden-home-dir.list.d/`,
  `/etc/unburden-home-dir/list.d/` or maybe even put symlinks to the
  (split) example file(s) in there.

  I've wrote a Perl interface to `run-parts` named
  [Run::Parts](https://metacpan.org/release/Run-Parts) as standalone
  Perl module which is already used by `aptitude-robot`, too.

* Use `/usr/share/unburden-home-dir/…` for default settings and use
  `/etc/unburden-home-dir*` only for settings by the local admin.

  See my question about
  [How to make a Dist::Zilla based Perl module (or app) install files into /etc/](https://stackoverflow.com/questions/26041056)
  on StackOverflow for the reasoning behind this idea.

Deficiencies
------------

* Slow rsync, e.g. for cache directories.

Documentation Improvements
--------------------------

* Restructure the documentation in a way that parts of it can be
  shipped as man pages as well as viewed in the web without contents
  being duplicated in the source.

Documentation Infrastructure
----------------------------

### Status Quo

Currently uses [mkdocs](http://www.mkdocs.org/) (Python) for
Markdown-to-HTML-site conversion (also
[used on ReadTheDocs](https://unburden-home-dir.readthedocs.io/)) and
[ronn](https://rtomayko.github.io/ronn/) (Ruby) for
Markdown-to-Unix-Manual-Page conversion.

### Idea

I'd like to switch to POD as primary documentation format to make the
software more suitable to distribution via CPAN.

### Requirements

* One single, easy to read and write, Github rendered source format
  (i.e. Markdown or POD, but no DocBook) for different output formats
  (primarily HTML and [ng]roff aka Unix man-pages).

* HTML documents should have a index/ToC of all the documentation, not
  only a ToC for the current file. (Example: MkDocs, ReadTheDocs)

* A documentation build should be triggerable via Github
  Webhook. (Example: ReadTheDocs)

### Plan

* Convert all Markdown files to POD with e.g. Markdown::POD.

* Replace MkDocs with e.g. [Pod::Simple::HTMLBatch](https://metacpan.org/pod/Pod::Simple::HTMLBatch),
  [Pod::HtmlEasy](https://metacpan.org/pod/Pod::HtmlEasy) or
  [Pod::HtmlTree](https://metacpan.org/pod/Pod::HtmlTree) to generate
  a bunch of HTML files belonging together. Needs evaluation.

* Replace ronn with a simple [pod2man](https://metacpan.org/pod/pod2man).

* Use
  [CGI::Github::Webhook](https://metacpan.org/pod/CGI::Github::Webhook)
  to update a local clone/checkout/working-copy and run the
  documentation generator.

* Maybe [Pandoc](http://pandoc.org/) is also an idea. It' not
  fulfilling all requirements above, but it would reduce the amount of
  dependencies because it can convert to HTML as well as [ng]roff.

### Possible Existing Implementations

* [DocSet](https://metacpan.org/pod/DocSet)
* [PodSite](https://metacpan.org/pod/Pod::Site)
