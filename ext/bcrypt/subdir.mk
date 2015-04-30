LIBFILES = crypt--bcrypt.$(SOEXT)
SCMFILES = bcrypt.sci

OBJECTS = crypt_blowfish.$(OBJEXT) \
          crypt_gensalt.$(OBJEXT) \
          wrapper.$(OBJEXT)

SCM_CATEGORY = crypt
XCLEANFILES = crypt--bcrypt.c *.sci

$(LIBFILES): $$(@B).obj $(OBJECTS)
