SCM_CATEGORY = data
LIBFILES = data--queue.$(SOEXT)
SCMFILES = queue.sci
XCLEANFILES =  *.c queue.sci

data--queue.$(SOEXT) : $$(@B).obj

