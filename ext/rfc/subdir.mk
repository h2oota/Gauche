SCM_CATEGORY = rfc

LIBFILES = rfc--mime.$(SOEXT) \
	   rfc--822.$(SOEXT)
SCMFILES = mime.sci \
	   822.sci

XCLEANFILES = *.c $(SCMFILES)

$(LIBFILES) : $$(@B).obj
