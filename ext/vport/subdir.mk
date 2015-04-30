DEFS=	$(DEFS) -DEXTVPORT_EXPORTS

SCM_CATEGORY = gauche

LIBFILES = gauche--vport.$(SOEXT)
SCMFILES = vport.scm
XCLEANFILES = vportlib.c
OBJECTS = vport.$(OBJEXT) vportlib.$(OBJEXT)

$(LIBFILES): $(OBJECTS)

vportlib.$(OBJEXT): $$(@B).c
