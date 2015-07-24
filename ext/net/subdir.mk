SCM_CATEGORY = gauche

LIBFILES = gauche--net.$(SOEXT)
SCMFILES = net.scm

OBJECTS = net.$(OBJEXT)				\
          addr.$(OBJEXT) 			\
          netdb.$(OBJEXT)			\
          netlib.$(OBJEXT)			\
          netaux.$(OBJEXT)
XCLEANFILES = netlib.c netaux.c

DEFS=	$(DEFS) -DEXTNET_EXPORTS

gauche--net.$(SOEXT) : $(OBJECTS) @libs.rsp

netlib.c : netlib.scm
netaux.c : netaux.scm

@libs.rsp:
	echo -nologo ws2_32.lib $(GCLIB) >$(@:@=)
