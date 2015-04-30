SOEXT=	dll
LIBFILES = srfi-1.$(SOEXT)  \
           srfi-13.$(SOEXT) \
           srfi-19.$(SOEXT) \
           srfi-43.$(SOEXT)
SCMFILES = srfi-1.sci  \
           srfi-13.sci \
           srfi-19.sci \
           srfi-43.sci
XCLEANFILES = *.c *.sci

$(LIBFILES) : $$(@B).obj
