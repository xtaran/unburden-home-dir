Installation and Dependencies
=============================

`unburden-home-dir` is a stand-alone Perl script which requires a few
Perl modules as dependencies.

For now, running `make install` as root will install the Perl script
and the configuration files to `/etc/` and `/usr/`. You can prefix by
setting DESTDIR as make flag, e.g. `make install
DESTDIR=~/local-installations`.

A more streamlined installation system (either Autotools or something
CPAN-compatible) is planned.


Getting Unburden-Home-Dir
-------------------------

Besides installing from [source code](source-code.md), several Linux
distributions ship unburden-home-dir as package:

* [Debian since 7.0 Wheezy](http://packages.debian.org/unburden-home-dir)
* [Ubuntu since 12.10 Quantal](http://packages.ubuntu.com/unburden-home-dir)
* [Korora 18 Flo](https://kororaproject.org/korora-18-flo-released/)
  ([GitHub repository](https://github.com/kororaproject/kp-unburden-home-dir))


Required Run-Time Dependencies
------------------------------

### From CPAN

* [`Config::File`](https://metacpan.org/pod/Config::File)
* [`File::BaseDir`](https://metacpan.org/pod/File::BaseDir)
* [`File::Rsync`](https://metacpan.org/pod/File::Rsync)
* [`File::Touch`](https://metacpan.org/pod/File::Touch)
* [`File::Which`](https://metacpan.org/pod/File::Which)
* [`String::Expand`](https://metacpan.org/pod/String::Expand)

#### Availability in Debian

With one exception, all mentioned Perl Modules are available in Debian
for quite some Stable releases now.

Only the package
[libstring-expand-perl](https://packages.debian.org/libstring-expand-perl)
is rather new and only available in Debian Testing at the time of
writing. It likely will be available in Debian Stable with the release
of Debian 9 Stretch. (Actually I packaged it for Debian to be able to
use it in unburden-home-dir.)

### From Elsewhere

* [`rsync`](https://rsync.samba.org/) (actually a dependency of `File::Rsync`)

Optional Run-Time Dependencies
------------------------------

* [`lsof`](http://people.freebsd.org/~abe/)[^1]


Build-Time and Test-Suite Dependencies
--------------------------------------

Besides all of the run-time dependencies mentioned above (including
the optional ones), running the test suite (and hence the full build
or packaging process) additionally needs:

### From CPAN

* [`File::Slurp`](https://metacpan.org/pod/File::Slurp)
* [`Moo`](https://metacpan.org/pod/Moo)
* [`String::Random`](https://metacpan.org/pod/String::Random)
* [`Test::Differences`](https://metacpan.org/pod/Test::Differences)
* [`Test::File`](https://metacpan.org/pod/Test::File)

### For Generating the Documentation

* [`mkdocs`](https://mkdocs.org/) (Yes, Python): for generating the
  HTML documentation including the one
  [at ReadTheDocs](http://unburden-home-dir.readthedocs.org/) from
  Markdown files.

* [`ronn`](https://rtomayko.github.io/ronn/) (Yes, Ruby): for
  generating the man pages from Markdown files.

* `sponge` from [moreutils](http://joeyh.name/code/moreutils/) (Yes,
  C): only needed if you want the HTML documentation cleaned from all
  remote inclusions (fonts, JavaScript libraries, CSS libraries) as
  required by e.g. Debian. (In Debian, embedding remote items in
  packaged HTML documentation is
  [considered a privacy breach](https://lintian.debian.org/tags/privacy-breach-generic.html).)

#### Availability in Debian

`ronn` and `sponge` are available in the packages
[ruby-ronn](https://packages.debian.org/ruby-ronn) and
[moreutils](https://packages.debian.org/moreutils) for quite some
Debian Stable releases now.

The package [mkdocs](https://packages.debian.org/mkdocs) is rather new
and only available in Debian Testing at the time of writing. It likely
will be available in Debian Stable with the release of Debian 9
Stretch.

#### Notes

Actually, I'd prefer to have pure Perl tools to generate the
documentation so that I can upload unburden-home-dir to CPAN at some
point without having to many external dependencies.

So if you know a suitable perl-written tool which can generate HTML
including a table of contents from a set of Markdown files and/or a
perl-written tool which can generate Unix manual pages from Markdown,
I'd be happy if you would [inform me](mailto:abe@deuxchevaux.org).


[^1]: No, <abe@freebsd.org> is not me. I'm just <abe@debian.org>. :-)
