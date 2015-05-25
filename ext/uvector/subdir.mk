LIBFILES = gauche--uvector.$(SOEXT)
SCMFILES = array.scm uvector.sci matrix.scm
HDRFILES = gauche/uvector.h

SCM_CATEGORY = gauche

OBJECTS = uvector.$(OBJEXT) 
XCLEANFILES =  uvlib.scm uvector.c gauche--uvector.c gauche/uvector.h uvector.sci

gauche--uvector.$(SOEXT): $$(@B).obj $(OBJECTS)
uvector.$(OBJEXT): 

uvector.$(OBJEXT) gauche--uvector.$(OBJEXT): gauche/uvector.h uvectorP.h

uvlib.scm : uvlib.scm.tmpl
	del /q uvlib.scm
	$(GOSH:/=\) $(srcdir)/uvgen.scm $(srcdir)/uvlib.scm.tmpl

uvector.c : uvector.c.tmpl uvgen.scm
	del /q uvector.c
	$(GOSH:/=\) $(srcdir)/uvgen.scm $(srcdir)/uvector.c.tmpl

gauche--uvector.c: uvector.scm uvlib.scm
	$(PRECOMP:/=\) -e -P -o gauche--uvector $(srcdir)/uvector.scm

gauche/uvector.h: gauche uvector.h.tmpl uvgen.scm
	$(GOSH:/=\) $(srcdir)/uvgen.scm $(srcdir)/uvector.h.tmpl && move /y uvector.h gauche/uvector.h

gauche:
	mkdir $@
