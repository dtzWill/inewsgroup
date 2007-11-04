/* include/autoconf.h.  Generated automatically by configure.  */
/*
 *  Project   : tin - a Usenet reader
 *  Module    : autoconf.hin
 *  Author    : Thomas Dickey
 *  Created   : 1995-08-24
 *  Updated   : 2005-07-16
 *  Notes     : #include files, #defines & struct's
 *
 * Copyright (c) 1995-2006 Thomas Dickey <dickey@invisible-island.net>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote
 *    products derived from this software without specific prior written
 *    permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#ifndef TIN_AUTOCONF_H
#	define TIN_AUTOCONF_H

/* Package and version */
#	define PACKAGE "tin"
#	define VERSION "1.8.3"

#	define SYSTEM_NAME "darwin"

/* compiler, compilerflags, ... */
#	define TIN_CC "arm-apple-darwin-gcc"
#	define TIN_CFLAGS "-O2"
#	define TIN_CPP "arm-apple-darwin-gcc -E"
#	define TIN_CPPFLAGS "-I../intl  -U_XOPEN_SOURCE -D_XOPEN_SOURCE=500"
#	define TIN_LD "arm-apple-darwin-gcc"
#	define TIN_LDFLAGS ""
#	define TIN_LIBS "-lcurses   -liconv"

/*
 * If we're able to run the 'configure' script, it's close enough to UNIX for
 * our purposes. (It's predefined on SCO).
 */
#	ifndef M_UNIX
#		define M_UNIX
#	endif /* !M_UNIX */

/*
 * SCO requires special handling
 */
/* #	undef NEED_TIMEVAL_FIX */
/* #	undef NEED_PTEM_H */

/*
 * Mac OS X need some extras
 */
/* #	undef MAC_OS_X */

/*
 * SEIUX has strange struct utsname values
 */
/* #	undef SEIUX */

/*
 * These are set as configure options, some must be guarded by ifdefs because
 * they're also used in makefile rules (e.g., lint, proto).
 */
/* #	undef HAVE_MH_MAIL_HANDLING */
#	define NNTP_ABLE 1
/* #	undef NNTP_ONLY */

#	ifndef HAVE_COLOR
#		define HAVE_COLOR 1
#	endif /* !HAVE_COLOR */

#	define DEFAULT_ISO2ASC "-1"
#	define DEFAULT_SHELL "/bin/ksh"
/* #	undef DOMAIN_NAME */
/* #	undef HAVE_FASCIST_NEWSADMIN */
/* #	undef INEWSDIR */
#	define PATH_INEWS "--internal"
#	define INN_NNTPLIB ""
/* #	undef MIME_BREAK_LONG_LINES */
#	define MIME_STRICT_CHARSET 1
#	define MM_CHARSET "US-ASCII"
#	define NEWSLIBDIR "/usr/lib/news"
#	define NNTP_DEFAULT_SERVER "news."
#	define NOVROOTDIR "/var/spool/news"
/* #	undef NO_ETIQUETTE */
/* #	undef NO_LOCALE */
/* #	undef NO_POSTING */
/* #	undef NO_SHELL_ESCAPE */
#	define OVERVIEW_FILE ".overview"
/* #	undef SOCKS */
#	define SPOOLDIR "/var/spool/news"
/* #	undef USE_INN_NNTPLIB */
/* #	undef USE_INVERSE_HACK */
/* #	undef USE_SOCKS4_PREFIX */
/* #	undef USE_SOCKS5 */

/*
 * These are defined if the corresponding program is found during configuration
 */
#	define HAVE_ISPELL 1
#	define HAVE_METAMAIL 1
/* pgp-2 */
/* #	undef HAVE_PGP */
/* pgp-5 */
/* #	undef HAVE_PGPK */
/* gpg */
#	define HAVE_GPG 1
#	define HAVE_SUM 1

/*
 * Compiler characteristics
 */
/* #	undef inline */
/* #	undef const */
#	define HAVE_NESTED_PARAMS 1

/*
 * Data types
 */
/* #	undef gid_t */
/* #	undef in_addr_t */
/* #	undef mode_t */
/* #	undef off_t */
/* #	undef pid_t */
/* #	undef quad_t */
/* #	undef size_t */
/* #	undef ssize_t */
/* #	undef time_t */
/* #	undef uid_t */
#	define RETSIGTYPE void
#	define HAVE_LONG_LONG 1
#	define HAVE_NL_ITEM 1

/*
 * The following xxx_H definitions are set by the 'configure' script to
 * defined or commented-out, according to whether the corresponding header
 * file was detected during configuration.
 */
#	define HAVE_ALLOCA_H 1
#	define HAVE_ARPA_INET_H 1
#	define HAVE_CURSES_H 1
#	define HAVE_DIRENT_H 1
#	define HAVE_ERRNO_H 1
#	define HAVE_FCNTL_H 1
#	define HAVE_GETOPT_H 1
#	define HAVE_ICONV_H 1
/* #	undef HAVE_IOCTL_H */
#	define HAVE_LANGINFO_H 1
#	define HAVE_LIBC_H 1
#	define HAVE_LOCALE_H 1
/* #	undef HAVE_MALLOC_H */
/* #	undef HAVE_NCURSESW_NCURSES_H */
/* #	undef HAVE_NCURSESW_TERM_H */
/* #	undef HAVE_NCURSES_H */		/* obsolete versions of ncurses */
/* #	undef HAVE_NCURSES_NCURSES_H */
/* #	undef HAVE_NCURSES_TERM_H */
#	define HAVE_NETDB_H 1
#	define HAVE_NETINET_IN_H 1
/* #	undef HAVE_NETLIB_H */
/* #	undef HAVE_NET_SOCKET_H */		/* __BEOS__ */
/* #	undef HAVE_NOMACROS_H */		/* ncurses 4.1 */
#	define HAVE_PATHS_H 1
#	define HAVE_POLL_H 1
/* #	undef HAVE_PROTOTYPES_H */
#	define HAVE_PWD_H 1
#	define HAVE_SGTTY_H 1
/* #	undef HAVE_SOCKET_H */
#	define HAVE_STDARG_H 1
#	define HAVE_STDBOOL_H 1
#	define HAVE_STDDEF_H 1
#	define HAVE_STDLIB_H 1
#	define HAVE_STRINGS_H 1
#	define HAVE_STRING_H 1
/* #	undef HAVE_STROPTS_H */
/* #	undef HAVE_SYS_BSDTYPES_H */
/* #	undef HAVE_SYS_DIR_H */
#	define HAVE_SYS_ERRNO_H 1
#	define HAVE_SYS_FILE_H 1
#	define HAVE_SYS_IOCTL_H 1
/* #	undef HAVE_SYS_NDIR_H */
#	define HAVE_SYS_PARAM_H 1
#	define HAVE_SYS_POLL_H 1
/* #	undef HAVE_SYS_PTEM_H */
/* #	undef HAVE_SYS_PTY_H */
#	define HAVE_SYS_SELECT_H 1
#	define HAVE_SYS_SOCKET_H 1
#	define HAVE_SYS_STAT_H 1
/* #	undef HAVE_SYS_STREAM_H */
#	define HAVE_SYS_TIMEB_H 1
#	define HAVE_SYS_TIMES_H 1
#	define HAVE_SYS_TIME_H 1
#	define HAVE_SYS_TYPES_H 1
#	define HAVE_SYS_UTSNAME_H 1
#	define HAVE_SYS_WAIT_H 1
/* #	undef HAVE_TERMCAP_H */
#	define HAVE_TERMIOS_H 1
/* #	undef HAVE_TERMIO_H */
#	define HAVE_TERM_H 1
#	define HAVE_TIME_H 1
#	define HAVE_UNISTD_H 1
/* #	undef HAVE_VARARGS_H */
#	define HAVE_WCHAR_H 1
#	define HAVE_WCTYPE_H 1
#	define STDC_HEADERS 1
#	define TIME_WITH_SYS_TIME 1

/*
 * The following are defined by the configure script if the corresponding
 * function is found in a library.
 */
#	define HAVE_ATOI 1
#	define HAVE_ATOL 1
#	define HAVE_BCOPY 1
#	define HAVE_CHMOD 1
/* #	undef HAVE_CLOSESOCKET */		/* __BEOS__ */
#	define HAVE_EXECLP 1
#	define HAVE_FCNTL 1
#	define HAVE_FDOPEN 1
#	define HAVE_FLOCK 1
#	define HAVE_FORK 1
#	define HAVE_FTIME 1
#	define HAVE_FTRUNCATE 1
#	define HAVE_GAI_STRERROR 1
#	define HAVE_GETADDRINFO 1
#	define HAVE_GETCWD 1
#	define HAVE_GETHOSTBYNAME 1
#	define HAVE_GETHOSTNAME 1
#	define HAVE_GETSERVBYNAME 1
#	define HAVE_GETTIMEOFDAY 1
#	define HAVE_GETWD 1
#	define HAVE_ICONV 1
#	define HAVE_INET_ADDR 1
#	define HAVE_INET_ATON 1
#	define HAVE_INET_NTOA 1
#	define HAVE_ISASCII 1
/* #	undef HAVE_IS_XTERM */
#	define HAVE_LINK 1
#	define HAVE_LOCKF 1
#	define HAVE_MEMCMP 1
#	define HAVE_MEMCPY 1
#	define HAVE_MEMMOVE 1
#	define HAVE_MEMSET 1
#	define HAVE_MKDIR 1
#	define HAVE_MKFIFO 1
#	define HAVE_MKSTEMP 1
#	define HAVE_MKTEMP 1
#	define HAVE_MUNMAP 1
#	define HAVE_NL_LANGINFO 1
#	define HAVE_POLL 1
#	define HAVE_PUTENV 1
#	define HAVE_RESIZETERM 1
#	define HAVE_REWINDDIR 1
#	define HAVE_SELECT 1
#	define HAVE_SETENV 1
#	define HAVE_SETLOCALE 1
/* #	undef HAVE_SETTZ */
#	define HAVE_SNPRINTF 1
#	define HAVE_STPCPY 1
#	define HAVE_STRCASECMP 1
#	define HAVE_STRCASESTR 1
#	define HAVE_STRCHR 1
#	define HAVE_STRDUP 1
#	define HAVE_STRERROR 1
#	define HAVE_STRFTIME 1
#	define HAVE_STRNCASECMP 1
#	define HAVE_STRPBRK 1
/* #	undef HAVE_STRRSTR */
#	define HAVE_STRSEP 1
#	define HAVE_STRSTR 1
#	define HAVE_STRTOL 1
#	define HAVE_TCGETATTR 1
#	define HAVE_TCSETATTR 1
/* #	undef HAVE_TIGETINT */
#	define HAVE_TIGETNUM 1
#	define HAVE_TMPFILE 1
#	define HAVE_TZSET 1
#	define HAVE_UNAME 1
#	define HAVE_UNLINK 1
#	define HAVE_USE_DEFAULT_COLORS 1
#	define HAVE_USLEEP 1
#	define HAVE_VASPRINTF 1
#	define HAVE_VSNPRINTF 1
#	define HAVE_WAITPID 1
/* #	undef HAVE__TRACEF */

/*
 * The following are functions/data that we'll have to declare if they're not
 * declared in the system include files, since they return values other than
 * int.
 */
/* #	undef DECL_ERRNO */
/* #	undef DECL_GETENV */
/* #	undef DECL_GETHOSTBYNAME */
/* #	undef DECL_GETLOGIN */
/* #	undef DECL_GETPWNAM */
/* #	undef DECL_GETSERVBYNAME */
/* #	undef DECL_POPEN */
/* #	undef DECL_STRCASESTR */
/* #	undef DECL_STRSEP */
/* #	undef DECL_SYS_ERRLIST */
/* #	undef DECL_TGETSTR */
/* #	undef DECL_TGOTO */
/* #	undef DECL_TIGETSTR */

/*
 * The following are functions that we'll optionally prototype (to stifle
 * warnings, etc., for development/testing).
 */
/* #	undef DECL_ATOI */
/* #	undef DECL_ATOL */
/* #	undef DECL_BCOPY */
/* #	undef DECL_BZERO */
/* #	undef DECL_CALLOC */
/* #	undef DECL_CONNECT */
/* #	undef DECL_FCHMOD */
/* #	undef DECL_FCLOSE */
/* #	undef DECL_FDOPEN */
/* #	undef DECL_FFLUSH */
/* #	undef DECL_FGETC */
/* #	undef DECL_FILENO */
/* #	undef DECL_FPRINTF */
/* #	undef DECL_FPUTC */
/* #	undef DECL_FPUTS */
/* #	undef DECL_FREAD */
/* #	undef DECL_FREE */
/* #	undef DECL_FSEEK */
/* #	undef DECL_FWRITE */
/* #	undef DECL_GETCWD */
/* #	undef DECL_GETHOSTNAME */
/* #	undef DECL_GETOPT */
/* #	undef DECL_GETPASS */
/* #	undef DECL_GETWD */
/* #	undef DECL_INET_ADDR */
/* #	undef DECL_INET_ATON */
/* #	undef DECL_INET_NTOA */
/* #	undef DECL_IOCTL */
/* #	undef DECL_ISASCII */
/* #	undef DECL_KILL */
/* #	undef DECL_MALLOC */
/* #	undef DECL_MEMSET */
/* #	undef DECL_MKSTEMP */
/* #	undef DECL_MKTEMP */
/* #	undef DECL_PCLOSE */
/* #	undef DECL_PERROR */
/* #	undef DECL_PRINTF */
/* #	undef DECL_PUTENV */
/* #	undef DECL_QSORT */
/* #	undef DECL_REALLOC */
/* #	undef DECL_RENAME */
/* #	undef DECL_REWIND */
/* #	undef DECL_SELECT */
/* #	undef DECL_SETENV */
/* #	undef DECL_SNPRINTF */
/* #	undef DECL_SOCKET */
/* #	undef DECL_SSCANF */
/* #	undef DECL_STRCASECMP */
/* #	undef DECL_STRCHR */
/* #	undef DECL_STRFTIME */
/* #	undef DECL_STRNCASECMP */
/* #	undef DECL_STRTOL */
/* #	undef DECL_SYSTEM */
/* #	undef DECL_TGETENT */
/* #	undef DECL_TGETFLAG */
/* #	undef DECL_TGETNUM */
/* #	undef DECL_TIGETFLAG */
/* #	undef DECL_TIGETNUM */
/* #	undef DECL_TIME */
/* #	undef DECL_TOLOWER */
/* #	undef DECL_TOUPPER */
/* #	undef DECL_TPUTS */
/* #	undef DECL_UNGETC */
/* #	undef DECL_USLEEP */
/* #	undef DECL_VSNPRINTF */
/* #	undef DECL_VSPRINTF */
/* #	undef DECL__FLSBUF */


#	define HAVE_POSIX_JC 1
/* #	undef HAVE_SELECT_INTP */
/* #	undef HAVE_TYPE_SIGACTION */
/* #	undef HAVE_TYPE_UNIONWAIT */

/*
 * Enable IPv6 support
 */
/* #	undef ENABLE_IPV6 */

/*
 * Define a symbol to control whether we use curses, or the termcap/terminfo
 * interface
 */
/* #	undef HAVE_XCURSES */
/* #	undef NEED_CURSES_H */
/* #	undef NEED_TERMCAP_H */
#	define NEED_TERM_H 1
/* #	undef USE_CURSES */
/* #	undef USE_TRACE */
/* #	undef XCURSES */

/*
 * Symbols used for wide-character curses
 */
/* #	undef NEED_WCHAR_H */
/* #	undef WIDEC_CURSES */
/*
 * Define symbols to prototype the function 'outchar()'
 */
#	define USE_TERMINFO 1
#	define OUTC_RETURN 1
/* #	undef OUTC_ARGS */

/*
 * Miscelleneous terminfo/termcap definitions
 */
/* #	undef HAVE_EXTERN_TCAP_PC */

/*
 * Define a symbol for the prototype arguments of a signal handler
 */
#	define SIG_ARGS int sig

/*
 * define if setpgrp() takes no arguments
 */
/* #	undef SETPGRP_VOID */

/*
 * Define this if it's safe to redefine the signal constants with prototypes.
 */
/* #	undef DECL_SIG_CONST */


/* FIXME: remove absolut-paths! */
/*
 * Program-paths (i.e., the invocation-path)
 */
#	define DEFAULT_EDITOR "/usr/bin/vi"
#	define DEFAULT_MAILBOX "/var/spool/mail"
#	define DEFAULT_MAILER "/usr/bin/sendmail"
#	define PATH_ISPELL "/usr/bin/ispell"
#	define PATH_METAMAIL "/usr/bin/metamail"
#	define PATH_SUM "/usr/bin/sum"
/* #	undef PATH_PGP */
/* FIXME: this is _not_ the path to the pgp-5 binarie we usually need */
/* #	undef PATH_PGPK */
#	define PATH_GPG "/usr/bin/gpg"

/*
 * Configure also checks whether sum takes -r
 * And defines PATH_SUM_R appropriately
 */
#	define SUM_TAKES_DASH_R 1
#	define PATH_SUM_R "/usr/bin/sum -r"

/*
 * Define this if the host system has long (>14 character) filenames
 */
#	define HAVE_LONG_FILE_NAMES 1

/*
 * Use this if you want pid attached to the end of .article filename
 */
#	define APPEND_PID 1

/*
 * requested locking scheme
 */
#	define USE_FCNTL 1
/* #	undef USE_FLOCK */
/* #	undef USE_LOCKF */

/*
 * Define this if the compiler performs ANSI-style token substitution (used in
 * our 'assert' macro).
 */
#	define CPP_DOES_EXPAND 1
/*
 * Define this if the compiler performs ANSI-style token concatenation (used in
 * our 'tincfg.h' macros).
 */
#	define CPP_DOES_CONCAT 1

/*
 * One of the following two is defined, according to whether qsort's compare
 * function is ANSI (declared with 'void *' parameters) or not.
 */
#	define HAVE_COMPTYPE_VOID 1
/* #	undef HAVE_COMPTYPE_CHAR */

/*
 * Define this to enable interpretation of 8-bit keycodes (e.g., beginning
 * with 0x9b).
 */
#	define HAVE_KEY_PREFIX 1

/*
 * Define this if an application can dump core. Some systems (e.g., apollo)
 * don't at all. Others may not, depending on how they're configured.
 */
/* #	undef HAVE_COREFILE */

/*
 * Define if the system doesn't define SIGWINCH, or the associated structs
 * to determine the window's size.
 */
#	define DONT_HAVE_SIGWINCH 1

/*
 * Definitions for debugging-malloc libraries
 */
#	ifndef __BUILD__
/* #		undef USE_DBMALLOC */	/* use Conor Cahill's dbmalloc library */
/* #		undef USE_DMALLOC */	/* use Gray Watson's dmalloc library */
#	endif /* !__BUILD__ */

/*
 * Define if the system doesn't support pipes, or if it is not a desired
 * feature.
 */
/* #	undef DONT_HAVE_PIPING */

/*
 * Define if the system doesn't support printing, or if it is not a
 * desired feature.
 */
/* #	undef DISABLE_PRINTING */

/*
 * Used in get_full_name()
 */
/* #	undef DONT_HAVE_PW_GECOS */

/*
 * Used in parsedate.y
 */
/* #	undef DONT_HAVE_TM_GMTOFF */

#	if defined(__hpux)
#		define HAVE_KEYPAD
#	endif /* __hpux */

/*
 * Not all platforms have either strerror or sys_errlist[].
 */
/* #	undef HAVE_SYS_ERRLIST */

/* #	undef USE_SYSTEM_STATUS */

/*
 * allow fallback to XHDR XREF if XOVER isn't supported?
 */
#	define XHDR_XREF 1

/*
 * The directory, where tin looks first for its tin.defaults file
 * can be left empty, tin searches for some standard places
 * XXXXX please define surrounded with double quotes! XXXXX
 */
#	define TIN_DEFAULTS_DIR "/etc/tin"

/*
 * define if second and thrid argument of setvbuf() are swapped
 * (System V before Release 3)
 */
/* #	undef SETVBUF_REVERSED */

/*
 * define if closedir() does not return a status
 */
#	define CLOSEDIR_VOID 1

/*
 * define if gettimeofday() takes the timezone as 2nd argument
 */
#	define	GETTIMEOFDAY_2ARGS 1

/*
 * define if your NNTP server needs an extra GROUP command before
 * accepting a LISTGROUP command.
 * (old versions of leafnode and NNTPcache need this)
 */
/* #	undef BROKEN_LISTGROUP */

/*
 * on some old systems the WIFEXITED()/WEXITSTATUS() macros do not work,
 * e.g. SEIUX3.2, DG/UX5.4R3, NEXTSTEP3
 */
/* #	undef IGNORE_SYSTEM_STATUS */

/* #	undef HAVE_COFFEE */

/*
 * libuu - used in save.c
 */
/* #	undef HAVE_UUDEVIEW_H */
/* #	undef HAVE_LIBUU */

/*
 * libidn - used for unicode normalization and
 *          Internationalized Domain Names
 */
/* #	undef HAVE_IDNA_H */
/* #	undef HAVE_STRINGPREP_H */
/* #	undef HAVE_IDNA_TO_UNICODE_LZLZ */
/* #	undef HAVE_IDNA_USE_STD3_ASCII_RULES */
/* #	undef HAVE_LIBIDN */

/*
 * ICU - International Components for Unicode
 *       used for unicode normalization
 */
/* #	undef HAVE_UNICODE_UNORM_H */
/* #	undef HAVE_UNICODE_USTRING_H */
/* #	undef HAVE_UNICODE_UBIDI_H */
/* #	undef HAVE_LIBICUUC */

/*
 * Define as const if the declaration of iconv() needs const.
 */
#	define ICONV_CONST const

/*
 * Define if iconv_open() has //TRNALSIT extension.
 */
/* #	undef HAVE_ICONV_OPEN_TRANSLIT */

/*
 * Define if you have swprintf() and co.
 */
#	define MULTIBYTE_ABLE 1
/* #	undef HAVE_LIBUTF8_H */

/*
 * Definition used in PCRE:
 */
#	if defined(MULTIBYTE_ABLE) || defined(HAVE_LIBUTF8_H)
#		define SUPPORT_UTF8 1
#		define SUPPORT_UCP 1
#	endif /* MULTIBYTE_ABLE || HAVE_LIBUTF8_H */

/*
 * Define if you have <langinfo.h> and nl_langinfo(CODESET).
 */
#	define HAVE_LANGINFO_CODESET 1

/*
 * Some older socks libraries, especially AIX need special definitions
 */
#	if defined(_AIX) && !defined(USE_SOCKS5)
/* #		undef accept */
/* #		undef bind */
/* #		undef connect */
/* #		undef getpeername */
/* #		undef getsockname */
/* #		undef listen */
/* #		undef recvfrom */
/* #		undef select */
#	endif /* _AIX && !USE_SOCKS5 */

/* FIXME: move things below to right place above */

/* GNU gettext */
/* Define to 1 if NLS is requested. */
#	define ENABLE_NLS 1

/* Define if your locale.h file contains LC_MESSAGES. */
#	define HAVE_LC_MESSAGES 1

/* Define if you have the i library (-li). */
/* #	undef HAVE_LIBI */

/* #	undef HAVE___ARGZ_COUNT */
/* #	undef HAVE___ARGZ_NEXT */
/* #	undef HAVE___ARGZ_STRINGIFY */
/* #	undef HAVE_CATGETS */
/* #	undef HAVE_DCGETTEXT */
#	define HAVE_GETTEXT 1

/*
-----------------------------------
Added missing headers after gettext update, using autoheader
-----------------------------------
*/
/* Define if using alloca.c. */
/* #	undef C_ALLOCA */

/*
 * Define to one of _getb67, GETB67, getb67 for Cray-2 and Cray-YMP systems.
 * This function is required for alloca.c support on those systems.
 */
/* #	undef CRAY_STACKSEG_END */

/* Define if you have the <argz.h> header file. */
/* #	undef HAVE_ARGZ_H */

/* Define if you don't have vprintf but do have _doprnt. */
/* #	undef HAVE_DOPRNT */

/* Define if you have the feof_unlocked function. */
#	define HAVE_FEOF_UNLOCKED 1

/* Define if you have the fgets_unlocked function. */
/* #	undef HAVE_FGETS_UNLOCKED */

/* Define if your system has a working fnmatch function. */
/* #	undef HAVE_FNMATCH */

/* Define if you have the getegid function. */
#	define HAVE_GETEGID 1

/* Define if you have the geteuid function. */
#	define HAVE_GETEUID 1

/* Define if you have the getgid function. */
#	define HAVE_GETGID 1

/* Define if your system has its own `getloadavg' function. */
/* #	undef HAVE_GETLOADAVG */

/* Define if you have the getmntent function. */
/* #	undef HAVE_GETMNTENT */

/* Define if you have the getnameinfo function. */
#	define HAVE_GETNAMEINFO 1

/* Define if you have the getpagesize function. */
#	define HAVE_GETPAGESIZE 1

/* Define if you have the getuid function. */
#	define HAVE_GETUID 1

/* Define if you have the nsl library (-lnsl). */
/* #	undef HAVE_LIBNSL */

/* Define if you have the socket library (-lsocket). */
/* #	undef HAVE_LIBSOCKET */

/* Define if you have the <limits.h> header file. */
#	define HAVE_LIMITS_H 1

/* Define if the `long double' type works. */
/* #	undef HAVE_LONG_DOUBLE */

/* Define if you have the mempcpy function. */
/* #	undef HAVE_MEMPCPY */

/* Define if you have a working `mmap' system call. */
/* #	undef HAVE_MMAP */

/* Define if you have the <ndir.h> header file. */
/* #	undef HAVE_NDIR_H */

/* Define if you have the <nl_types.h> header file. */
#	define HAVE_NL_TYPES_H 1

/*
 * Define if system calls automatically restart after interruption
 * by a signal.
 */
/* #	undef HAVE_RESTARTABLE_SYSCALLS */

/* Define if you have the sigaction function. */
#	define HAVE_SIGACTION 1

/* Define if your struct stat has st_blksize. */
/* #	undef HAVE_ST_BLKSIZE */

/* Define if your struct stat has st_blocks. */
/* #	undef HAVE_ST_BLOCKS */

/* Define if you have the strcoll function and it is properly defined. */
/* #	undef HAVE_STRCOLL */

/* Define if your struct stat has st_rdev. */
/* #	undef HAVE_ST_RDEV */

/* Define if you have the ANSI # stringizing operator in cpp. */
/* #	undef HAVE_STRINGIZE */

/* Define if you have the strtoul function. */
#	define HAVE_STRTOUL 1

/* Define if you have the <sys/termio.h> header file. */
/* #	undef HAVE_SYS_TERMIO_H */

/* Define if your struct tm has tm_zone. */
/* #	undef HAVE_TM_ZONE */

/* Define if you have the tsearch function. */
#	define HAVE_TSEARCH 1

/*
 * Define if you don't have tm_zone but do have the external array
 * tzname.
 */
/* #	undef HAVE_TZNAME */

/* Define if utime(file, NULL) sets file's timestamp to the present. */
/* #	undef HAVE_UTIME_NULL */

/* Define if you have <vfork.h>. */
/* #	undef HAVE_VFORK_H */

/* Define if you have the vprintf function. */
/* #	undef HAVE_VPRINTF */

/* Define if you have the wait3 system call. */
/* #	undef HAVE_WAIT3 */

/* Define if you have the <wait.h> header file. */
/* #	undef HAVE_WAIT_H */

/* Define if your C compiler doesn't accept -c and -o together. */
/* #	undef NO_MINUS_C_MINUS_O */

/* Define if your Fortran 77 compiler doesn't accept -c and -o together. */
/* #	undef F77_NO_MINUS_C_MINUS_O */

/* Define to the type of arg1 for select(). */
/* #	undef SELECT_TYPE_ARG1 */

/* Define to the type of args 2, 3 and 4 for select(). */
/* #	undef SELECT_TYPE_ARG234 */

/* Define to the type of arg5 for select(). */
/* #	undef SELECT_TYPE_ARG5 */

/*
 * If using the C implementation of alloca, define if you know the
 * direction of stack growth for your system; otherwise it will be
 * automatically deduced at run-time.
 * STACK_DIRECTION > 0 => grows toward higher addresses
 * STACK_DIRECTION < 0 => grows toward lower addresses
 * STACK_DIRECTION = 0 => direction of growth unknown
 */
/* #	undef STACK_DIRECTION */

/* Define if the X Window System is missing or not being used. */
/* #	undef X_DISPLAY_MISSING */

/*
 * TODO: define if:
 *       !X_DISPLAY_MISSING && !DONT_HAVE_PIPING &&
 *       HAVE_MKFIFO && HAVE_FORK && HAVE_EXECLP && HAVE_WAITPID
 *       [&& HAVE_SLRNFACE if we add a check or a configure option for that ]
 */
/* #	undef XFACE_ABLE */

#endif /* !TIN_AUTOCONF_H */
