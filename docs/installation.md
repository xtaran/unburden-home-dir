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

Besides installing from source code, several Linux distributions ship
unburden-home-dir as package:

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

* [`mkdocs`](https://mkdocs.org/)
* `sponge`[^2] from [moreutils](http://joeyh.name/code/moreutils/)

[^1]: No, <abe@freebsd.org> is not me. I'm just <abe@debian.org>. :-)
[^2]: `sponge` is only needed if you want a documentation cleaned
  from all remote inclusions as required by e.g. Debian.
