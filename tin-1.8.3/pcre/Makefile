# Generated automatically from Makefile.in by configure.
# Make file for PCRE (Perl-Compatible Regular Expression) library.

# The repeated -I. option is intentional, to work around the use of quoted
# includes in the pcre source.  Bracketed includes would be more portable
# for nested include-files.

SHELL		= /bin/sh
prefix		= /usr/local
exec_prefix	= ${prefix}
srcdir		= .


CC		= arm-apple-darwin-gcc
CFLAGS		= -O2  

x		= 
o		= .o

BUILD_CC	= gcc
BUILD_CFLAGS	= 
BUILD_CPPFLAGS	= -I$(INCDIR)
BUILD_LDFLAGS	= 
BUILD_LIBS	= 
X		= $(BUILD_EXEEXT)

# The -D options correspond to pcre 4.1's default values.
CPPOPTS = \
	-DLINK_SIZE=2 \
	-DMATCH_LIMIT=10000000 \
	-DNEWLINE=10 \
	-DPOSIX_MALLOC_THRESHOLD=10 \
	-DHAVE_CONFIG_H -I. -I../include

RANLIB	= arm-apple-darwin-ranlib
RM	= rm

PRELIB	= lib
ARCHIVE	= arm-apple-darwin-ar rv

##########################################################################

OBJ = \
	pcre_chartables$o \
	pcre_compile$o \
	pcre_config$o \
	pcre_dfa_exec$o \
	pcre_exec$o \
	pcre_fullinfo$o \
	pcre_get$o \
	pcre_globals$o \
	pcre_info$o \
	pcre_maketables$o \
	pcre_ord2utf8$o \
	pcre_refcount$o \
	pcre_study$o \
	pcre_tables$o \
	pcre_try_flipped$o \
	pcre_ucp_findchar$o \
	pcre_valid_utf8$o \
	pcre_version$o \
	pcre_xclass$o

PCR_DEP	= \
	pcre_internal.h \
	pcre.h

all :	$(PRELIB)pcre.a $(PRELIB)pcreposix.a pcretest$x pcregrep$x

.SUFFIXES : .i

.c$o :
# compiling
	$(CC) $(CPPOPTS) $(CFLAGS) -c $(srcdir)/$*.c

.c.i :
# compiling
	$(CPP) -C $(CPPOPTS) $*.c >$@

pcregrep$x :	$(PRELIB)pcre.a pcregrep$o
		$(CC) $(CFLAGS) -o $@ pcregrep$o $(PRELIB)pcre.a

pcretest$x :	$(PRELIB)pcre.a $(PRELIB)pcreposix.a pcretest$o
		$(CC) $(CFLAGS) -o $@ pcretest$o $(PRELIB)pcre.a $(PRELIB)pcreposix.a

$(PRELIB)pcre.a : $(OBJ)
		$(RM) -f $(PRELIB)pcre.a
		$(ARCHIVE) $(PRELIB)pcre.a $(OBJ)
		$(RANLIB) $(PRELIB)pcre.a

$(PRELIB)pcreposix.a : pcreposix$o
		$(RM) -f $(PRELIB)pcreposix.a
		$(ARCHIVE) $(PRELIB)pcreposix.a pcreposix$o
		$(RANLIB) $(PRELIB)pcreposix.a

pcre$o :	chartables.c pcre.c $(PCR_DEP)

pcreposix$o :	pcreposix.c pcreposix.h $(PCR_DEP)

maketables$o :	pcre_maketables.c $(PCR_DEP)
# compiling
	$(CC) $(CPPOPTS) $(CFLAGS) -c $(srcdir)/pcre_maketables.c

pcretest$o :	pcretest.c pcre.h

pcregrep$o :	pcregrep.c pcre.h

# An auxiliary program makes the default character table source

pcre_chartables.c :	dftables$X
		./dftables$X $@

dftables$X :	dftables.c pcre_maketables.c $(PCR_DEP)
# compiling
		$(BUILD_CC) -o $@ $(BUILD_CFLAGS) $(CPPOPTS) $(srcdir)/dftables.c

# We deliberately omit dftables and chartables.c from 'make clean'; once made
# chartables.c shouldn't change, and if people have edited the tables by hand,
# you don't want to throw them away.

clean :;		$(RM) -f *$o *.a pcretest$x pcregrep$x

distclean :	clean ; $(RM) -f pcre.h dftables$X pcre_chartables.c RunTest

runtest :	all
		./RunTest

# End
