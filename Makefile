ROOT=/usr/local/arm-apple-darwin
ARMCC=arm-apple-darwin-gcc
ARMLD=$(ARMCC)
CC=gcc
LD=$(CC)
RESOLVLIB = ./libresolv.a 
LDFLAGS= -Wl,-syslibroot,/usr/local/share/iphone-filesystem  -lobjc -ObjC -framework CoreFoundation -framework Foundation -framework CoreGraphics -framework GraphicsServices -framework UIKit -framework LayerKit -framework CFNetwork -framework Message
TINDIR = tin-1.8.3/src
TININC = -I tin-1.8.3/include -I tin-1.8.3/pcre -I tin-1.8.3/src -I tin-1.8.3/intl
TINLIB = ./libtin.a
PCRELIB = tin-1.8.3/pcre/libpcre.a 
INTLLIB = tin-1.8.3/intl/libintl.a
INTLFLAGS = $(INTLLIB) -liconv
OBJS = \
	$(TINLIB) \
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
	$(ARMLD) $(LDFLAGS) -o $@ $(RESOLVLIB) $(PCRELIB) $(INTLFLAGS) -lcurses $(TINLIB) $^  
#	cp UIUCMapApp UIUCMap.app

%.o:    %.m
	$(ARMCC) -c $(RESOLVLIB) $(FLAGS) $(TININC) $< -o $@

$(PCRELIB): 
	cd $(TINDIR) && make
$(INTLLIB):
	cd $(TINDIR) && make

$(TINLIB):
	cd $(TINDIR) && make

clean: local_clean
	rm -f libtin.a
	cd $(TINDIR) && make clean
local_clean:
	rm -f *.o iNewsGroup iNewsGroup-x86
install: all
#	scp iNewsGroup root@192.168.255.2:
	scp iNewsGroup root@10.5.16.180: 
# I have 2 wireless networks.. don't ask.
#
#x86: iNewsGroup-x86
#
#iNewsGroup-x86: inewsgroup.o.x86 newsfunctions.o.x86
#	$(LD) $(LDFLAGS) -o $@ $^
#
#%.o.x86: %.m
#	$(CC) -c $(FLAGS) $< -o $@
#
#
#
