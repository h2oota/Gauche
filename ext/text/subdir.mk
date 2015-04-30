SCM_CATEGORY = text
LIBFILES = text--gettext.$(SOEXT) text--tr.$(SOEXT) text--unicode.$(SOEXT)
SCMFILES = gettext.sci tr.sci unicode.sci

LIBFILES = text--gettext.$(SOEXT) text--tr.$(SOEXT) text--unicode.$(SOEXT)
XCLEANFILES = *.c $(SCMFILES)
CFLAGS=	$(CFLAGS) -wd4819

$(LIBFILES) : $$(@B).obj
