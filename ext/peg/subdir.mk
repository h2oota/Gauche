SCM_CATEGORY = parser

LIBFILES = parser--peg.$(SOEXT)
SCMFILES = peg.sci
XCLEANFILES = peg.sci *.c

parser--peg.$(SOEXT) : $$(@B).$(OBJEXT)

parser--peg.c : peg.scm
	$(PRECOMP:/=\) -e -P -o parser--peg \
	    --keep-private-macro=return-failure/compound,return-failure/expect,return-result $**

peg.sci: parser--peg.c
