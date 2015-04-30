SCM_CATEGORY = rfc

LIBFILES = rfc--mime.$(SOEXT)
SCMFILES = mime.sci
XCLEANFILES = *.c $(SCMFILES)

rfc--mime.$(SOEXT) : $$(@B).obj

