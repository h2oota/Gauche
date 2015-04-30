SCM_CATEGORY = math

SCM_CATEGORY = math

LIBFILES = math--mt-random.$(SOEXT)
SCMFILES = mt-random.sci
XCLEANFILES = math--mt-random.c

DEFS=	$(DEFS) -DEXTMTRANDOM_EXPORTS

math--mt-random.$(SOEXT) : $$(@B).obj mt-random.$(OBJEXT) 

math--mt-random.c : mt-random.scm
	$(PRECOMP:/=\) -e -P -o $(@B) $(srcdir)/mt-random.scm
