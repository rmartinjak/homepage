PAGES = index contact faq

DESTDIR = ~/public_html
DATEFMT = "%a %d %b %Y %H:%M %z"

SRCDIR = src
NAVDIR = $(SRCDIR)/nav
PAGEDIR = pages
HTMLDIR = html
STATICDIR = static

HEAD = $(SRCDIR)/head.html
POSTNAV = $(SRCDIR)/postnav.html
TAIL = $(SRCDIR)/tail.html
NAV_HEAD = $(NAVDIR)/head.html
NAV_ITEM = $(NAVDIR)/item.html
NAV_TAIL = $(NAVDIR)/tail.html
NAV = $(SRCDIR)/nav.html

PAGES_ALL = $(PAGES) $(PAGES_NO_NAV)
PAGES_SRC = $(addprefix $(PAGEDIR)/,$(addsuffix .html, $(PAGES_ALL)))
PAGES_HTML = $(addprefix $(HTMLDIR)/,$(addsuffix .html, $(PAGES_ALL)))

default : all

$(NAV) : $(NAV_HEAD) $(NAV_ITEM) $(NAV_TAIL)
	@echo $@
	@echo -n > $@
	@cat $(NAV_HEAD) >> $@
	@for p in $(PAGES); do sed "s/PAGE/$$p/g" $(NAV_ITEM); done >> $@
	@cat $(NAV_TAIL) >> $@

$(HTMLDIR) :
	@mkdir -p $(HTMLDIR)

$(HTMLDIR)/%.html : $(HEAD) $(NAV) $(POSTNAV) $(PAGEDIR)/%.html $(TAIL)
	@echo $@
	@cat $^ | sed -e "s/TITLE/$*/g" -e "s/UPDATED/`date +$(DATEFMT)`/g" > $@

all : $(HTMLDIR) $(PAGES_HTML)
	@cp -ruv $(STATICDIR)/* $(HTMLDIR)

install : all
	@cp -ruv $(HTMLDIR)/* $(DESTDIR)

clean :
	@echo cleaning
	@rm -f $(PAGEDIR)/blog.html
	@rm -f $(PAGEDIR)/blog_all.html
	@rm -f $(NAV)
	@rm -rf $(HTMLDIR)

.PHONY: all install clean
