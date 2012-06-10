PAGES = index blog contact faq
PAGES_NO_NAV = blog_all

DESTDIR = ~/public_html
DATEFMT = "%a %d %b %Y %H:%M %z"

BLOG_POSTCOUNT = 5
BLOG_PCMD = "markdown_py"

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

BLOG_DIR = blog
BLOG_SRCDIR = $(SRCDIR)/blog
BLOG_HEAD = $(BLOG_SRCDIR)/head.html
BLOG_TAIL = $(BLOG_SRCDIR)/tail.html
BLOG_ALL_HEAD = $(BLOG_SRCDIR)/head_all.html
BLOG_ALL_TAIL = $(BLOG_SRCDIR)/tail_all.html
BLOG_ITEM_HEAD = $(BLOG_SRCDIR)/item_head.html
BLOG_ITEM_TAIL = $(BLOG_SRCDIR)/item_tail.html

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
	@mkdir $(HTMLDIR)

$(PAGEDIR)/blog.html : $(BLOG_DIR)/* $(BLOG_HEAD) $(BLOG_TAIL)
	@echo $@
	@echo > $@
	@cat $(BLOG_HEAD) >> $@
	@BLOGDIR=$(BLOG_DIR) BLOGSRC=$(SRCDIR)/blog DATEFMT=$(DATEFMT) \
	ITEM_HEAD=$(BLOG_ITEM_HEAD) ITEM_TAIL=$(BLOG_ITEM_TAIL)	PCMD=$(BLOG_PCMD) \
	./mkblog $(BLOG_POSTCOUNT) >> $@
	@cat $(BLOG_TAIL) >> $@

$(PAGEDIR)/blog_all.html :  $(BLOG_DIR)/* $(BLOG_ALL_HEAD) $(BLOG_ALL_TAIL)
	@echo $@
	@echo > $@
	@cat $(BLOG_ALL_HEAD) >> $@
	@BLOGDIR=$(BLOG_DIR) BLOGSRC=$(SRCDIR)/blog DATEFMT=$(DATEFMT) \
	ITEM_HEAD=$(BLOG_ITEM_HEAD) ITEM_TAIL=$(BLOG_ITEM_TAIL)	PCMD=$(BLOG_PCMD) \
	./mkblog >> $@
	@cat $(BLOG_ALL_TAIL) >> $@

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
