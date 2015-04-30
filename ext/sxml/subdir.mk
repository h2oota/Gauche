SCMTRANS   = $(GOSH) $(srcdir)/trans.scm

SCM_CATEGORY = sxml

LIBFILES = sxml--ssax.$(SOEXT) sxml--sxpath.$(SOEXT) sxml--tools.$(SOEXT) \
	   sxml--serializer.$(SOEXT)
SCMFILES = adaptor.scm ssax.sci sxpath.sci tools.sci \
           tree-trans.scm to-html.scm serializer.sci
GENERATED_FILES = sxml--ssax.c sxml-ssax.scm \
                  sxml--sxpath.c sxml-sxpath.scm \
                  sxml--tools.c sxml-tools.scm \
	          sxml--serializer.c sxml-serializer.scm
GENERATED_TEST = ssax-test.scm tree-trans-test.scm to-html-test.scm
GENERATED_TARGET = tree-trans.scm to-html.scm \
                   ssax.sci tools.sci sxpath.sci \
	           serializer.sci

XCLEANFILES = $(GENERATED_TARGET) $(GENERATED_TEST) $(GENERATED_FILES)

EXTENTION_AUXS = to-html.scm tree-trans.scm ssax-test.scm tree-trans-test.scm

SCMCOMPILE = $(GOSH:/=\) -l$(srcdir)/adaptor -E "import sxml.adaptor" \
                 -E "provide \"sxml/adaptor\"" $(top_srcdir)/src/precomp
SCMTRANS   = $(GOSH:/=\) $(srcdir)/trans.scm

### sxml-ssax

sxml--ssax.$(SOEXT) : sxml--ssax.$(OBJEXT)

sxml--ssax.c: sxml-ssax.scm
	$(SCMCOMPILE) -e -i ssax.sci -o sxml--ssax sxml-ssax.scm

sxml-ssax.scm : src/SSAX.scm

### sxml-sxpath

sxml--sxpath.$(SOEXT) : sxml--sxpath.$(OBJEXT)

sxml--sxpath.c : sxml-sxpath.scm sxml--tools.c
	$(SCMCOMPILE) -e -i sxpath.sci -o sxml--sxpath sxml-sxpath.scm

sxml-sxpath.scm : src/sxpath.scm src/sxpathlib.scm src/sxpath-ext.scm

### sxml-tools

sxml--tools.$(SOEXT) : sxml--tools.$(OBJEXT)

sxml--tools.c : sxml-tools.scm
	$(SCMCOMPILE) -e -i tools.sci -o sxml--tools sxml-tools.scm

sxml-tools.scm : src/sxml-tools.scm

### sxml-serializer

sxml--serializer.$(SOEXT) : sxml--serializer.$(OBJEXT)

sxml--serializer.c : sxml-serializer.scm
	$(SCMCOMPILE) -e -i serializer.sci -o sxml--serializer sxml-serializer.scm
sxml-serializer.scm : src/serializer.scm

### 
sxml-ssax.scm sxml-sxpath.scm sxml-tools.scm sxml-serializer.scm \
    to-html.scm tree-trans.scm ssax-test.scm tree-trans-test.scm: $$@.in
	$(SCMTRANS) $(srcdir)/$@.in
