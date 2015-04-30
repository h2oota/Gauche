LIBFILES = gauche--collection.$(SOEXT) \
           gauche--sequence.$(SOEXT)   \
           gauche--parameter.$(SOEXT)  \
           gauche--hook.$(SOEXT) \
	   gauche--record.$(SOEXT) \
	   gauche--generator.$(SOEXT)

SCMFILES = collection.sci \
           sequence.sci   \
           parameter.sci  \
           hook.sci \
	   record.sci \
	   generator.sci
XCLEANFILES = *.c $(SCMFILES)

SCM_CATEGORY = gauche

$(LIBFILES) : $$(@B).obj

gauche--parameter.c : $(top_srcdir)/libsrc/gauche/parameter.scm
	$(PRECOMP) -M=%parameterize -e -P -o gauche--parameter $(top_srcdir)/libsrc/gauche/parameter.scm

parameter.sci: gauche--parameter.c
