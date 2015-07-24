SCM_CATEGORY = gauche

LIBFILES = gauche--threads.$(SOEXT)
SCMFILES = threads.sci
OBJECTS = threads.$(OBJEXT) mutex.$(OBJEXT)
XCLEANFILES = gauche--threads.c *.sci


CFLAGS=	$(CFLAGS) -DEXTTHREADS_EXPORTS

gauche--threads.$(SOEXT) : $$(@B).obj $(OBJECTS) @libs.rsp
@libs.rsp:
	echo $(GCLIB) > $(@:@=)
