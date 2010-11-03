build:

test:
	checkbashisms 95unburden_home_dir
	checkbashisms bin/unburden-home-dir

install:
	install -d $(DESTDIR)/etc/X11/Xsession.d/
	install -m 644 95unburden_home_dir $(DESTDIR)/etc/X11/Xsession.d/
	install -m 644 etc/unburden_home_dir etc/unburden_home_dir_list $(DESTDIR)/etc/
	sed -e 's/^\([^#]\)/#\1/' -i $(DESTDIR)/etc/unburden_home_dir_list
