DEFS=	$(DEFS) -DEXTVPORT_EXPORTS

SCM_CATEGORY = gauche

LIBFILES = gauche--vport.$(SOEXT)
SCMFILES = vport.scm
XCLEANFILES = vportlib.c
OBJECTS = vport.$(OBJEXT) vportlib.$(OBJEXT)

$(LIBFILES): $(OBJECTS) @libs.rsp

vportlib.$(OBJEXT): $$(@B).c

@libs.rsp:
	echo $(GCLIB) > $(@:@=)
