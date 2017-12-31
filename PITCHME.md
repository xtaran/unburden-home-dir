Unburden Your Home Directory
============================

Axel Beckert <abe@deuxchevaux.org>


#HSLIDE

Volatile Crap in my $HOME
-------------------------

* `.cache`
* `.thumbnails`
* `.mozilla/firefox/*/Cache`
* `.mozilla/firefox/*/startupCache`
* `.mozilla/firefox/*/Cache.Trash`
* `.Trash`
* `.local/Trash`
* …


#HSLIDE

So what?
--------

* `$HOME` on NFS?
* Fear of wearing off your expensive SSD too fast?
* Backups slow and cluttered with crap?
* Too many write accesses suck away your laptop battery?
* Running into your quota because of cache and trash directories?


#HSLIDE

Unburden (Your) Home Dir(ectory)!
---------------------------------

* Automatically (re)creates symbolic links
* Can be configured where to put and how to name the files instead
* Can be called by your X session upon login
* Supports workstation setups with common home and separate local disks
* Supports `tmpfs`
* Works non-interactively


#VSLIDE

A fictive run
-------------

    $ unburden-home-dir
    Create directory /scratch/.unburden-abe/cache
    Create parent directories for /scratch/.unburden-abe/google-chrome-thumbnails-Default
    Touching /scratch/.unburden-abe/google-chrome-thumbnails-Default
    Create parent directories for /scratch/.unburden-abe/google-chrome-thumbnails-Default
    Touching /scratch/.unburden-abe/google-chrome-thumbnails-Default
    Create parent directories for /scratch/.unburden-abe/google-chrome-thumbnails-journal-Default
    Touching /scratch/.unburden-abe/google-chrome-thumbnails-journal-Default
    Create parent directories for /scratch/.unburden-abe/firefox-cache-stla7cb1.default
    Symlinking /scratch/.unburden-abe/firefox-cache-stla7cb1.default ->  /home/abe/.mozilla/firefox/stla7cb1.default/Cache
    Create directory /scratch/.unburden-abe/thunderbird-cache-1pcvjygg.default
    Create parent directories for /scratch/.unburden-abe/conkeror-cache-zzdhvpf1.default
    Symlinking /scratch/.unburden-abe/conkeror-cache-zzdhvpf1.default ->  /home/abe/.conkeror.mozdev.org/conkeror/zzdhvpf1.default/Cache
    Create directory /scratch/.unburden-abe/thumbnails
    Create directory /scratch/.unburden-abe/trash
    Create directory /scratch/.unburden-abe/local-trash
    $


#HSLIDE

### Installation

* Code on GitHub:  http://deb.li/ubhdgh
* Debian Packages: http://deb.li/ubhddeb
* Ubuntu Packages: http://deb.li/ubhdubu

### Documentation

* https://unburden-home-dir.readthedocs.io/
* https://xtaran.gitbooks.io/unburden-home-dir/

### Contact

Axel Beckert <abe@deuxchevaux.org>
