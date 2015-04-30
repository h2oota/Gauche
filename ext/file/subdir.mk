SCM_CATEGORY = file
LIBFILES = file--util.$(SOEXT)
SCMFILES = util.sci
XCLEANFILES = *.c util.sci


file--util.$(SOEXT) : $$(@B).obj

