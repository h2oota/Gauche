SCM_CATEGORY = data

LIBFILES = data--sparse.$(SOEXT)
SCMFILES = sparse.sci
XCLEANFILES = data--sparse.c sparse.sci

DEFS=	$(DEFS) -DEXTSPARSE_EXPORTS

OBJECTS = ctrie.$(OBJEXT) spvec.$(OBJEXT) sptab.$(OBJEXT)

data--sparse.$(SOEXT) : $$(@B).obj $(OBJECTS) @libs.rsp
@libs.rsp:
	echo $(GCLIB) > $(@:@=)

$(OBJECTS): ctrie.h spvec.h sptab.h
