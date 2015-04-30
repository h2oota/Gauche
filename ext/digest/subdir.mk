LIBFILES = rfc--md5.$(SOEXT) rfc--sha.$(SOEXT)
SCMFILES = md5.sci sha1.scm sha.sci
SCM_CATEGORY = rfc
XCLEANFILES = rfc--md5.c rfc--sha.c *.sci

md5_OBJECTS = md5c.$(OBJEXT)
sha_OBJECTS = sha2.$(OBJEXT)

rfc--md5.$(SOEXT) : $$(@B).obj $(md5_OBJECTS)
rfc--sha.$(SOEXT) : $$(@B).obj $(sha_OBJECTS)
