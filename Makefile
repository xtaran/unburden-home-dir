build:

test:
	checkbashisms 95unburden_home_dir

install:
	install -d $(DESTDIR)/etc/X11/Xsession.d/
	install -m 644 95unburden_home_dir $(DESTDIR)/etc/X11/Xsession.d/
