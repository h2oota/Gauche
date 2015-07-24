SCM_CATEGORY = os

LIBFILES = os--windows.$(SOEXT)
SCMFILES = windows.scm

OBJECTS = init.$(OBJEXT) windows.$(OBJEXT) console.$(OBJEXT)
XCLEANFILES = windows.c console.c os--windows.rsp

os--windows.$(SOEXT) : $(OBJECTS) @libs.rsp
@libs.rsp:
	echo user32.lib $(GCLIB) > $(@:@=)

windows.c console.c: $$(@B).stub
	$(GOSH:/=\) $(top_srcdir)/src/genstub $**
