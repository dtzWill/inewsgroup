ROOT=/usr/local/arm-apple-darwin
ARMCC=arm-apple-darwin-gcc
ARMLD=$(ARMCC)
CC=gcc
LD=$(CC)
LDFLAGS=-Wl,-syslibroot,/usr/local/share/iphone-filesystem -lobjc -ObjC -framework CoreFoundation -framework Foundation -framework CoreGraphics -framework GraphicsServices -framework UIKit -framework LayerKit

all:    clean iNewsGroup 

iNewsGroup:  inewsgroup.o newsfunctions.o
	$(ARMLD) $(LDFLAGS) -o $@ $^
#	cp UIUCMapApp UIUCMap.app

%.o:    %.m
	$(ARMCC) -c $(FLAGS)  $< -o $@

clean:
	rm -f *.o iNewsGroup iNewsGroup-x86
install: all
	scp iNewsGroup root@192.168.255.2:
#
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
