ROOT=/usr/local/arm-apple-darwin
ARMCC=arm-apple-darwin-gcc
ARMLD=$(ARMCC)
CC=gcc
LD=$(CC)
CFLAGS=-O2
LDFLAGS= \
	-Wl,-syslibroot,/usr/local/share/iphone-filesystem \
	-lobjc -ObjC -framework CoreFoundation \
	-framework Foundation \
	-framework CoreGraphics \
	-framework GraphicsServices \
	-framework UIKit \
	-framework LayerKit \
	-framework Message
TINDIR = tin-1.8.3/src
TININC = -I tin-1.8.3/include -I tin-1.8.3/pcre -I tin-1.8.3/src -I tin-1.8.3/intl
TINLIB = ./libtin.a
PCRELIB = tin-1.8.3/pcre/libpcre.a 
INTLLIB = tin-1.8.3/intl/libintl.a
INTLFLAGS = $(INTLLIB) -liconv
OBJS = \
	$(TINLIB) \
	ViewController.o \
	EditableRowCell.o \
	EditTextView.o \
	EditorKeyboard.o \
	ComposeView.o \
	SubscriptionView.o \
	PostView.o \
	ThreadView.o \
	GroupView.o \
	PrefsView.o \
	iNewsApp.o \
	inewsgroup.o \
	newsfunctions.o \
	$(PCRELIB) \
	$(INTLLIB) 


all:   iNewsGroup 

iNewsGroup:  $(OBJS)
	$(ARMLD) $(LDFLAGS) -o $@ $(PCRELIB) $(INTLFLAGS) -lcurses $(TINLIB) $^  

inewsgroup.o: inewsgroup.m
	$(ARMCC) -c $(CFLAGS) $(TININC) $< -o $@

%.o:    %.m %.h consts.h
	$(ARMCC) -c $(CFLAGS) $(TININC) $< -o $@

$(PCRELIB): 
	cd $(TINDIR) && make clean all
$(INTLLIB):
	cd $(TINDIR) && make clean all

$(TINLIB):
	cd $(TINDIR) && make clean all

clean: local_clean
	rm -f libtin.a
	cd $(TINDIR) && make clean
local_clean:
	rm -f *.o iNewsGroup
install: all
	scp iNewsGroup root@192.168.255.2:
#	scp iNewsGroup root@10.5.16.180: 
#	scp iNewsGroup root@172.16.1.34:
# I have 3 wireless networks.. don't ask.

#TEST
impossible:
	echo "Always run this"

test: *.h *.m *.a test.c impossible 
	cd $(TINDIR) && make -f Makefile.x86 clean all
	gcc -o test test.c $(TININC) -lcurses ./libtin.x86.a tin-1.8.3/pcre/libpcre.x86.a tin-1.8.3/intl/libintl.x86.a 
	NNTPSERVER=./nntpserver ./test
