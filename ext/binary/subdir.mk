SCM_CATEGORY = binary
LIBFILES = binary--io.$(SOEXT)
SCMFILES = io.sci

OBJECTS = binary.$(OBJEXT)
XCLEANFILES = binary--io.c io.sci

binary--io.$(SOEXT) : $$(@B).obj $(OBJECTS)
