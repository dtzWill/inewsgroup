# iNewsGroup #
**Will Dietz**

iNewsgroup is a
iPhone newsgroup client.

Add http://dtztech.com/iphone/iphone.xml to your installer to keep up-to-date with releases!

This app is provided absolutely free of charge.  If you like it, please consider donating:
[![](https://www.paypal.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=willdtz@gmail.com&item_name=iNewsGroup%20Development&item_number=iNG-donate&no_shipping=1&cn=Note&currency_code=USD&tax=0&lc=US&bn=PP-DonationsBF)


## 1.0.6 Release ##
3/04/08
> Fixed sending bug that made it unable to post in some circumstances.

## 1.0.5 Release ##
2/11/08
> Firmware 1.1.3 support fixed.  Thanks Tinman for feedback and testing.

## 1.0.4 Release ##
2/1/08

Changes
  * There was a bug where it didn't save preferences in 1.1.3.  This should be fixed now.
  * Proper DNS resolution-- see http://dtztech.com/blog/?p=20 for more details. No longer uses http request, should be able to access servers like usenet-access.com and others
  * Few memory leak fixes
  * Very minor text changes

## 1.0.3 Release ##
12/31/07
Changes:
  * "Real Name" option in preferences now in order to post with your name
  * Dates are now visible in thread and group views
  * Fixed numerous UI glitches
  * Actually think that 'message from top' bug is finally gone.
  * Fixed potential cause of crash on initial install

## 1.0.2 Release ##
12/27/07

Another quick fix:
bouncing support in the compose view, as well as fixed a bug where it didn't show the search filter correctly.

## 1.0.1 Release ##
12/27/07

Small update:
added bouncing support to the postview

## 1.0.0 Release ##
12/27/07

Changelog: wow there are so many things:

  * posting support!
  * handles large lists /much/ better now :)
  * search feature in subscription manager
  * fixed [issue #24](https://code.google.com/p/inewsgroup/issues/detail?id=#24) --now can connect to servers that don't req auth, but auth helps
  * transitions between views
  * multi-line support in various views, most notably while viewing threads
  * fixed bug relating to 'newsgroups' header being shown in body of articles
  * fixed many memory bugs
  * improved connection logic and performance
  * more responsive UI and better handling of errors
  * fixed transparency in the Default.png :)
  * more economical use of screen in various views
(and many issues not worth mentioning here. check the svn log and the issues page for more information)

## Screenshots ##
| Splash: | Connecting: |
|:--------|:------------|
| ![http://dtztech.com/iphone/inewsgroup/loading.jpg](http://dtztech.com/iphone/inewsgroup/loading.jpg) |![http://dtztech.com/iphone/inewsgroup/connect.png](http://dtztech.com/iphone/inewsgroup/connect.png) |
| Subscriptions: | Main View: |
|![http://dtztech.com/iphone/inewsgroup/subscriptions.jpg](http://dtztech.com/iphone/inewsgroup/subscriptions.jpg)|![http://dtztech.com/iphone/inewsgroup/groups.jpg](http://dtztech.com/iphone/inewsgroup/groups.jpg)|
| Preferences Page: | Refreshing Group: |
|![http://dtztech.com/iphone/inewsgroup/prefs.png](http://dtztech.com/iphone/inewsgroup/prefs.png)|![http://dtztech.com/iphone/inewsgroup/group.png](http://dtztech.com/iphone/inewsgroup/group.png)|
| Group View: | Thread View: |
|![http://dtztech.com/iphone/inewsgroup/group.jpg](http://dtztech.com/iphone/inewsgroup/group.jpg)|![http://dtztech.com/iphone/inewsgroup/thread.png](http://dtztech.com/iphone/inewsgroup/thread.png)|
| Post View: |  |
|![http://dtztech.com/iphone/inewsgroup/post_view.png](http://dtztech.com/iphone/inewsgroup/post_view.png)|



## NEWS ##
12/18/07

Just letting you know there is a lot of development being done on iNewsGroup, and I hope to make a big release in the near future.

Hang in there! :)


## 0.0.7 Release ##
12/10/07

  * Fixed [issue #21](https://code.google.com/p/inewsgroup/issues/detail?id=#21)
  * Now click on 'arrow' to read a group, removed annoying 'view' button.
  * Fixed some saving issues.
  * Fixed connection logic issue.
  * Cleaned up some of the code.


Note: subscriptionview /can/ be a bit unwieldly for those large usenet servers...
```
echo "group.i.want.to.subscribe.to:" >> ~/.newsrc
```
From the command line will add it manually, if you find that easier.


## 0.0.6c Release ##
12/10/07
Another quick fix for [issue #20](https://code.google.com/p/inewsgroup/issues/detail?id=#20).  Thanks to Three60Guy for reporting it.  Also improved look of the subscription view, faster/smoother scrolling, and leaving subscription view and coming back again doesn't force a reload.

(BTW how did I ever get on this letter sub-numbering policy? sigh)

## 0.0.6b Release ##
12/9/07

Quick fix/update patching error in subscribe code that resulted in wrong groups being added/removed.


## 0.0.6 Release ##
12/9/07

Lots of fixes!!


  * Fixed [issue #3](https://code.google.com/p/inewsgroup/issues/detail?id=#3),[issue #4](https://code.google.com/p/inewsgroup/issues/detail?id=#4),[issue #5](https://code.google.com/p/inewsgroup/issues/detail?id=#5),[issue #9](https://code.google.com/p/inewsgroup/issues/detail?id=#9), [issue #10](https://code.google.com/p/inewsgroup/issues/detail?id=#10),[issue #13](https://code.google.com/p/inewsgroup/issues/detail?id=#13),[issue #14](https://code.google.com/p/inewsgroup/issues/detail?id=#14),[issue #16](https://code.google.com/p/inewsgroup/issues/detail?id=#16),[issue #18](https://code.google.com/p/inewsgroup/issues/detail?id=#18).
  * Alpha-sort the subscription view
  * Added "mark read" option to mark an entire newsgroup read.
  * Greatly improved the connection code, no longer crashes when connecting with bad auth info, and is smarter about handling errors.
  * Reduced font size in a number of places to make room for more text.
  * Numerous UI improvements.


11/28/07

Currently busy with finals and whatnot, but should be making a big new release soon. :-)

## 0.0.5 Release ##
11/13/07

Fixed [issue #11](https://code.google.com/p/inewsgroup/issues/detail?id=#11). /wow/ I wish I'd caught that earlier.  For shame.
Available in the usual places.

## 0.0.4 Release ##
11/12/07

Fixed DNS resolution issues.  It's a dirty hack, but does the job for now until core helps me figure out how to link libresolv.a into my application.
Basically we just make an http request to the server-- basically we're programmatically doing the 'safari' trick from before.

Hopefully this makes the app more usable. :)

## 0.0.3 Release ##
11/5/07

Newsgroup reader, Authentication support, manage subscriptions, read/unread status, threaded support, and a bunch of other things I forgot.

Note, due to lame iphone DNS issues, you either need to add your newsgroup server to your /etc/hosts, or visit it in safari first (and potentially every time) you use iNewsGroup.

The hacks the im applications use involve copying/modfying 'hosts' and that's won't really work here since there's no way for me to ship a hosts file containing your server. :-/.


(Yes there were releases 0.0.2 and 0.0.1, but they were so beta that they weren't released publicly, and weren't worth writing up.)