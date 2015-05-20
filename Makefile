ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
  NUMJOBS = $(patsubst parallel=%,%,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
  PROVEFLAGS += -j$(NUMJOBS)
endif

build:

docs: site/index.html
site/index.html: mkdocs.yml Makefile docs/*.md
	mkdocs build --clean

index:
	perl -nE 'if (/^  - \[([^,]+)\.md, "?([^]"]+)"?\]$$/) { say "* [$$2]($$1/)"; }' < mkdocs.yml

pureperltest:
	perl -c bin/unburden-home-dir
	prove $(PROVEFLAGS) t/*.t

test: pureperltest
	checkbashisms Xsession.d/95unburden-home-dir

determine-coverage:
	cover -delete
	prove --exec 'env PERL5OPT=-MDevel::Cover=-ignore_re,^t/ perl' t/*.t

cover: determine-coverage
	cover -report html_basic

coveralls: determine-coverage
	cover -report coveralls

install:
	install -d $(DESTDIR)/etc/X11/Xsession.d/
	install -d $(DESTDIR)/usr/bin/
	install -d $(DESTDIR)/usr/share/man/man1/
	install -d $(DESTDIR)/usr/share/unburden-home-dir/
	install -m 755 bin/unburden-home-dir $(DESTDIR)/usr/bin/
	install -m 644 share/common.sh $(DESTDIR)/usr/share/unburden-home-dir/
	install -m 644 Xsession.d/95unburden-home-dir $(DESTDIR)/etc/X11/Xsession.d/
	install -m 644 Xsession.d/25unburden-home-dir-xdg $(DESTDIR)/etc/X11/Xsession.d/
	install -m 644 etc/unburden-home-dir etc/unburden-home-dir.list $(DESTDIR)/etc/
	sed -e 's/^\([^#]\)/#\1/' -i $(DESTDIR)/etc/unburden-home-dir.list
	gzip -9c man/unburden-home-dir.1 > $(DESTDIR)/usr/share/man/man1/unburden-home-dir.1.gz
