# dmenu - dynamic menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = src/drw.c src/dmenu.c src/stest.c src/util.c
OBJ = ${SRC:src/%.c=%.o}
DIST_DIR = "dist/yo-dmenu-$(VERSION)"

all: options dmenu stest

options:
	@echo dmenu build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

.c.o:
	$(CC) -c $(CFLAGS) $<

$(OBJ): src/arg.h src/config.h config.mk src/drw.h

dmenu: src/dmenu.o src/drw.o src/util.o
	$(CC) -o $@ dmenu.o drw.o util.o $(LDFLAGS)

stest: src/stest.o
	$(CC) -o $@ stest.o $(LDFLAGS)

clean:
	rm -f dmenu stest $(OBJ) dmenu-$(VERSION).tar.gz

dist: clean
	mkdir -p $(DIST_DIR)
	cp LICENSE Makefile README.md config.mk $(DIST_DIR)
	cp -r src scripts doc $(DIST_DIR)
	tar -cf dist/dmenu-$(VERSION).tar $(DIST_DIR)
	gzip dist/dmenu-$(VERSION).tar
	rm -rf $(DIST_DIR)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f dmenu stest scripts/dmenu_path scripts/dmenu_run $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu_path
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu_run
	chmod 755 $(DESTDIR)$(PREFIX)/bin/stest
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < doc/dmenu.1 > $(DESTDIR)$(MANPREFIX)/man1/dmenu.1
	sed "s/VERSION/$(VERSION)/g" < doc/stest.1 > $(DESTDIR)$(MANPREFIX)/man1/stest.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/dmenu.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/stest.1

build: dmenu stest clean

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dmenu\
		$(DESTDIR)$(PREFIX)/bin/dmenu_path\
		$(DESTDIR)$(PREFIX)/bin/dmenu_run\
		$(DESTDIR)$(PREFIX)/bin/stest\
		$(DESTDIR)$(MANPREFIX)/man1/dmenu.1\
		$(DESTDIR)$(MANPREFIX)/man1/stest.1

.PHONY: all options clean dist install uninstall
