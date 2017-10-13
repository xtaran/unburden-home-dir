---
title: Appendix: Retriving PGP Keys Used In The Project
layout: page
---

PGP Keys Used In The Project
----------------------------

The PGP/GnuPG key used for signing Git tags and reporting security
bugs in a encrypted way isthe key
`0x2517B724C5F6CA9953296E612FF9CD59612616B5` (or its most recent
subkey).

Retrieving the Key on a Debian Installation
-------------------------------------------

This key is included in Debian's official keyring, i.e. in available
in the file `/usr/share/keyrings/debian-keyring.gpg` of the
[Debian package `debian-keyring`](https://packages.debian.org/debian-keyring)
(Version 2015.01.26 or higher, i.e. the versions available on Debian 8
"Jessie" and newer). On any Debian installation (Release 9 "Jessie" or
newer), you can retrieve that key as follows:

* `apt install debian-keyring` (as root)
* `gpg --keyring /usr/share/keyrings/debian-keyring.gpg --export -a 0x2517B724C5F6CA9953296E612FF9CD59612616B5`

You also might want to verify the signatures:

* `gpg --keyring /usr/share/keyrings/debian-keyring.gpg --list-sigs 0x2517B724C5F6CA9953296E612FF9CD59612616B5`

But having fetched it via `apt`, it's indirectly signed by the very
same PGP keys which also verify all retrieved packages before
installation

Retrieving the Key from Debian Servers via HTTPS
------------------------------------------------

If you trust the SSL certificates used on Debian's web servers, you
can also
[download this key directly from `debian-keyring`'s official Git repository over HTTPS](https://anonscm.debian.org/cgit/keyring/keyring.git/plain/debian-keyring-gpg/0x2FF9CD59612616B5)
(hosted on an official Debian-maintained `.debian.org` server) or
[download this key from the latest `debian-keyring` package over HTTPS from sources.debian.net](https://sources.debian.net/data/main/d/debian-keyring/unstable/debian-keyring-gpg/0x2FF9CD59612616B5).
(Please note that while the `.debian.net` is operated by the Debian
Project, the individual hosts are usually not operated by the Debian
Project but by a Debian Member or Contributor.)
