SCM_CATEGORY = gauche

LIBFILES = gauche--charconv.$(SOEXT)
SCMFILES = charconv.scm

OBJECTS = charconv.$(OBJEXT)      \
          convaux.$(OBJEXT)       \
          jconv.$(OBJEXT)         \
          guess.$(OBJEXT)

XCLEANFILES = convaux.c

gauche--charconv.$(SOEXT) : $(OBJECTS)

jconv.$(OBJEXT) : eucj2ucs.c ucs2eucj.c jconv.c
guess.$(OBJEXT) : guess_tab.c guess.c

eucj2ucs.c ucs2eucj.c : cvt.scm euc-jp-2000-std.txt
	$(GOSH:/=\) $(srcdir)/cvt.scm $(srcdir)/euc-jp-2000-std.txt

guess.obj: guess_tab.c

guess_tab.c : guess.scm
	$(GOSH:/=\) $(srcdir)/guess.scm guess_tab.c

$(OBJECTS:.obj=.c):

gauche--charconv.$(SOEXT): @$$(@B).rsp

@gauche--charconv.rsp:
	type>$(@:@=) <<
-nologo
iconv.lib
<<
