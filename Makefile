build:

test:
	checkbashisms 95unburden_home_dir

install:
	install 95unburden_home_dir $(DESTDIR)/etc/X11/Xsession.d/
