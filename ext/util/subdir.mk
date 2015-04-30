SCM_CATEGORY = util

LIBFILES = util--match.$(SOEXT)
SCMFILES = match.sci
XCLEANFILES =  *.c match.sci

util--match.$(SOEXT) : $$(@B).obj

