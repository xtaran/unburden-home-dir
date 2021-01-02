ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
  NUMJOBS = $(patsubst parallel=%,%,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
  PROVEFLAGS += -j$(NUMJOBS)
endif

build: cleanthedocs manpages

docs: html/index.html
html/index.html: mkdocs.yml Makefile docs/*.md
	env LC_ALL=C.UTF-8 mkdocs build --clean

# Avoid any inclusion of either external or embedded JS code. Avoids
# lintian warnings about privacy breaches.
cleanthedocs: docs
	find html -name '*.html' | while read file; do \
		egrep -v '<link [^>]*href=.https?://[^/"]*/[^>]*>|<(img|script)[^>]*src="(https?:)?//|<link rel="stylesheet" href="\.\.?/css/highlight\.css">' "$$file" | \
		pcregrep -Mv '<script[^>]*>[^<]*</script>' | \
		sponge "$$file"; \
		sed -e 's:href="./\([^"]*\)/">:href="./\1/index.html">:g' -i $$file; \
	done
	rm -rf html/js/ html/css/highlight.css

manpages: unburden-home-dir.1

%.1: docs/%.1.md
	ronn --manual="Unburden Your Home Directory" -r --pipe $< > $@

index:
	perl -nE 'if (/^  - "?(.+[^"])"?: (\S*?)\.md$$/) { say "* [$$1]($$2)"; }' < mkdocs.yml

pureperltest:
	perl -c bin/unburden-home-dir
	prove $(PROVEFLAGS) t/*.t

test: pureperltest checkbashisms

checkbashisms:
	checkbashisms Xsession.d/* share/*.sh

determine-coverage:
	cover -delete
	prove --exec 'env -u TMPDIR   -u XDG_RUNTIME_DIR      PERL5OPT=-MDevel::Cover=-ignore_re,^t/ perl' t/*.t
	prove --exec 'env    TMPDIR=/foo XDG_RUNTIME_DIR=/bar PERL5OPT=-MDevel::Cover=-ignore_re,^t/ perl' t/*.t

cover: determine-coverage
	cover -report html_basic

coveralls: determine-coverage
	cover -report coveralls
codecov: determine-coverage
	cover -report codecov

install: unburden-home-dir.1
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
	gzip -9cn unburden-home-dir.1 > $(DESTDIR)/usr/share/man/man1/unburden-home-dir.1.gz

clean:
	rm -rf html/
	rm -f *.[0-9]
