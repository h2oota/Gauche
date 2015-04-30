SCM_CATEGORY = gauche

LIBFILES = gauche--fcntl.$(SOEXT)
SCMFILES = fcntl.sci
OBJECTS = fcntl.$(OBJEXT)
XCLEANFILES = gauche--fcntl.c fcntl.sci

DEFS=	$(DEFS) -DEXTFCNTL_EXPORTS
gauche--fcntl.$(SOEXT) : $$(@B).$(OBJEXT) $(OBJECTS)

