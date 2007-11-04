/* This file is generated by MAKECFG */

#ifndef TINCFG_H
#define TINCFG_H 1

/* Macros for defining symbolic offsets that can be ifdef'd */
#undef OINX
#undef OVAL
#undef OEND
#undef OTYP

#ifdef lint
#	define OINX(T, M) 0 /* 'lint -c' cannot be appeased */
#	define OVAL(T, M) char M;
#	define OEND(T, M) char M;
#	define OTYP struct
#else
#	ifdef CPP_DOES_CONCAT
#		define OINX(T, M) T ## M
#		define OVAL(T, M) T ## M,
#		define OEND(T, M) T ## M
#		define OTYP enum
#	else
#		define OINX(T, M) \
			(((int)&(((T*)0)->M))/ \
			 ((int)&(((T*)0)->Q1) - (int)&(((T*)0)->s_MAX)))
#		define OVAL(T, M) char M;
#		define OEND(T, M) char M;
#		define OTYP struct
#	endif
#endif

t_bool * OPT_ON_OFF_list[] = {
	&tinrc.beginner_level,            /*  0: beginner_level__ */
	&tinrc.show_description,          /*  1: show_description__ */
	&tinrc.draw_arrow,                /*  2: draw_arrow__ */
	&tinrc.inverse_okay,              /*  3: inverse_okay__ */
	&tinrc.strip_blanks,              /*  4: strip_blanks__ */
	&tinrc.pos_first_unread,          /*  5: pos_first_unread__ */
	&tinrc.show_only_unread_arts,     /*  6: show_only_unread_arts__ */
	&tinrc.show_only_unread_groups,   /*  7: show_only_unread_groups__ */
	&tinrc.tab_goto_next_unread,      /*  8: tab_goto_next_unread__ */
	&tinrc.space_goto_next_unread,    /*  9: space_goto_next_unread__ */
	&tinrc.pgdn_goto_next,            /* 10: pgdn_goto_next__ */
	&tinrc.auto_list_thread,          /* 11: auto_list_thread__ */
	&tinrc.wrap_on_next_unread,       /* 12: wrap_on_next_unread__ */
	&tinrc.show_signatures,           /* 13: show_signatures__ */
	&tinrc.alternative_handling,      /* 14: alternative_handling__ */
	&tinrc.tex2iso_conv,              /* 15: tex2iso_conv__ */
	&tinrc.ask_for_metamail,          /* 16: ask_for_metamail__ */
	&tinrc.catchup_read_groups,       /* 17: catchup_read_groups__ */
	&tinrc.group_catchup_on_exit,     /* 18: group_catchup_on_exit__ */
	&tinrc.thread_catchup_on_exit,    /* 19: thread_catchup_on_exit__ */
	&tinrc.mark_ignore_tags,          /* 20: mark_ignore_tags__ */
	&tinrc.use_mouse,                 /* 21: use_mouse__ */
#ifdef HAVE_KEYPAD
	&tinrc.use_keypad,                /* 22: use_keypad__ */
#endif
	&tinrc.add_posted_to_filter,      /* 23: add_posted_to_filter__ */
#ifdef HAVE_COLOR
	&tinrc.use_color,                 /* 24: use_color__ */
#endif
	&tinrc.url_highlight,             /* 25: url_highlight__ */
	&tinrc.word_highlight,            /* 26: word_highlight__ */
	&tinrc.prompt_followupto,         /* 27: prompt_followupto__ */
	&tinrc.sigdashes,                 /* 28: sigdashes__ */
	&tinrc.signature_repost,          /* 29: signature_repost__ */
	&tinrc.advertising,               /* 30: advertising__ */
#if defined(HAVE_ICONV_OPEN_TRANSLIT) && defined(CHARSET_CONVERSION)
	&tinrc.translit,                  /* 31: translit__ */
#endif
	&tinrc.post_8bit_header,          /* 32: post_8bit_header__ */
	&tinrc.mail_8bit_header,          /* 33: mail_8bit_header__ */
	&tinrc.auto_cc,                   /* 34: auto_cc__ */
	&tinrc.auto_bcc,                  /* 35: auto_bcc__ */
	&tinrc.batch_save,                /* 36: batch_save__ */
	&tinrc.auto_save,                 /* 37: auto_save__ */
	&tinrc.mark_saved_read,           /* 38: mark_saved_read__ */
	&tinrc.post_process_view,         /* 39: post_process_view__ */
	&tinrc.process_only_unread,       /* 40: process_only_unread__ */
#ifndef DISABLE_PRINTING
	&tinrc.print_header,              /* 41: print_header__ */
#endif
	&tinrc.force_screen_redraw,       /* 42: force_screen_redraw__ */
	&tinrc.start_editor_offset,       /* 43: start_editor_offset__ */
	&tinrc.unlink_article,            /* 44: unlink_article__ */
	&tinrc.keep_dead_articles,        /* 45: keep_dead_articles__ */
	&tinrc.strip_newsrc,              /* 46: strip_newsrc__ */
	&tinrc.auto_reconnect,            /* 47: auto_reconnect__ */
	&tinrc.cache_overview_files,      /* 48: cache_overview_files__ */
#ifdef XFACE_ABLE
	&tinrc.use_slrnface,              /* 49: use_slrnface__ */
#endif
#if defined(HAVE_LIBICUUC) && defined(MULTIBYTE_ABLE) && defined(HAVE_UNICODE_UBIDI_H) && !defined(NO_LOCALE)
	&tinrc.render_bidi,               /* 50: render_bidi__ */
#endif
};

typedef OTYP {
	OVAL(oinx_OPT_O, beginner_level__)
	OVAL(oinx_OPT_O, show_description__)
	OVAL(oinx_OPT_O, draw_arrow__)
	OVAL(oinx_OPT_O, inverse_okay__)
	OVAL(oinx_OPT_O, strip_blanks__)
	OVAL(oinx_OPT_O, pos_first_unread__)
	OVAL(oinx_OPT_O, show_only_unread_arts__)
	OVAL(oinx_OPT_O, show_only_unread_groups__)
	OVAL(oinx_OPT_O, tab_goto_next_unread__)
	OVAL(oinx_OPT_O, space_goto_next_unread__)
	OVAL(oinx_OPT_O, pgdn_goto_next__)
	OVAL(oinx_OPT_O, auto_list_thread__)
	OVAL(oinx_OPT_O, wrap_on_next_unread__)
	OVAL(oinx_OPT_O, show_signatures__)
	OVAL(oinx_OPT_O, alternative_handling__)
	OVAL(oinx_OPT_O, tex2iso_conv__)
	OVAL(oinx_OPT_O, ask_for_metamail__)
	OVAL(oinx_OPT_O, catchup_read_groups__)
	OVAL(oinx_OPT_O, group_catchup_on_exit__)
	OVAL(oinx_OPT_O, thread_catchup_on_exit__)
	OVAL(oinx_OPT_O, mark_ignore_tags__)
	OVAL(oinx_OPT_O, use_mouse__)
#ifdef HAVE_KEYPAD
	OVAL(oinx_OPT_O, use_keypad__)
#endif
	OVAL(oinx_OPT_O, add_posted_to_filter__)
#ifdef HAVE_COLOR
	OVAL(oinx_OPT_O, use_color__)
#endif
	OVAL(oinx_OPT_O, url_highlight__)
	OVAL(oinx_OPT_O, word_highlight__)
	OVAL(oinx_OPT_O, prompt_followupto__)
	OVAL(oinx_OPT_O, sigdashes__)
	OVAL(oinx_OPT_O, signature_repost__)
	OVAL(oinx_OPT_O, advertising__)
#if defined(HAVE_ICONV_OPEN_TRANSLIT) && defined(CHARSET_CONVERSION)
	OVAL(oinx_OPT_O, translit__)
#endif
	OVAL(oinx_OPT_O, post_8bit_header__)
	OVAL(oinx_OPT_O, mail_8bit_header__)
	OVAL(oinx_OPT_O, auto_cc__)
	OVAL(oinx_OPT_O, auto_bcc__)
	OVAL(oinx_OPT_O, batch_save__)
	OVAL(oinx_OPT_O, auto_save__)
	OVAL(oinx_OPT_O, mark_saved_read__)
	OVAL(oinx_OPT_O, post_process_view__)
	OVAL(oinx_OPT_O, process_only_unread__)
#ifndef DISABLE_PRINTING
	OVAL(oinx_OPT_O, print_header__)
#endif
	OVAL(oinx_OPT_O, force_screen_redraw__)
	OVAL(oinx_OPT_O, start_editor_offset__)
	OVAL(oinx_OPT_O, unlink_article__)
	OVAL(oinx_OPT_O, keep_dead_articles__)
	OVAL(oinx_OPT_O, strip_newsrc__)
	OVAL(oinx_OPT_O, auto_reconnect__)
	OVAL(oinx_OPT_O, cache_overview_files__)
#ifdef XFACE_ABLE
	OVAL(oinx_OPT_O, use_slrnface__)
#endif
#if defined(HAVE_LIBICUUC) && defined(MULTIBYTE_ABLE) && defined(HAVE_UNICODE_UBIDI_H) && !defined(NO_LOCALE)
	OVAL(oinx_OPT_O, render_bidi__)
#endif
	OVAL(oinx_OPT_O, s_MAX)
	OEND(oinx_OPT_O, Q1)
} oinx_OPT_O;

#define OINX_beginner_level              OINX(oinx_OPT_O, beginner_level__)
#define OINX_show_description            OINX(oinx_OPT_O, show_description__)
#define OINX_draw_arrow                  OINX(oinx_OPT_O, draw_arrow__)
#define OINX_inverse_okay                OINX(oinx_OPT_O, inverse_okay__)
#define OINX_strip_blanks                OINX(oinx_OPT_O, strip_blanks__)
#define OINX_pos_first_unread            OINX(oinx_OPT_O, pos_first_unread__)
#define OINX_show_only_unread_arts       OINX(oinx_OPT_O, show_only_unread_arts__)
#define OINX_show_only_unread_groups     OINX(oinx_OPT_O, show_only_unread_groups__)
#define OINX_tab_goto_next_unread        OINX(oinx_OPT_O, tab_goto_next_unread__)
#define OINX_space_goto_next_unread      OINX(oinx_OPT_O, space_goto_next_unread__)
#define OINX_pgdn_goto_next              OINX(oinx_OPT_O, pgdn_goto_next__)
#define OINX_auto_list_thread            OINX(oinx_OPT_O, auto_list_thread__)
#define OINX_wrap_on_next_unread         OINX(oinx_OPT_O, wrap_on_next_unread__)
#define OINX_show_signatures             OINX(oinx_OPT_O, show_signatures__)
#define OINX_alternative_handling        OINX(oinx_OPT_O, alternative_handling__)
#define OINX_tex2iso_conv                OINX(oinx_OPT_O, tex2iso_conv__)
#define OINX_ask_for_metamail            OINX(oinx_OPT_O, ask_for_metamail__)
#define OINX_catchup_read_groups         OINX(oinx_OPT_O, catchup_read_groups__)
#define OINX_group_catchup_on_exit       OINX(oinx_OPT_O, group_catchup_on_exit__)
#define OINX_thread_catchup_on_exit      OINX(oinx_OPT_O, thread_catchup_on_exit__)
#define OINX_mark_ignore_tags            OINX(oinx_OPT_O, mark_ignore_tags__)
#define OINX_use_mouse                   OINX(oinx_OPT_O, use_mouse__)
#ifdef HAVE_KEYPAD
#define OINX_use_keypad                  OINX(oinx_OPT_O, use_keypad__)
#endif
#define OINX_add_posted_to_filter        OINX(oinx_OPT_O, add_posted_to_filter__)
#ifdef HAVE_COLOR
#define OINX_use_color                   OINX(oinx_OPT_O, use_color__)
#endif
#define OINX_url_highlight               OINX(oinx_OPT_O, url_highlight__)
#define OINX_word_highlight              OINX(oinx_OPT_O, word_highlight__)
#define OINX_prompt_followupto           OINX(oinx_OPT_O, prompt_followupto__)
#define OINX_sigdashes                   OINX(oinx_OPT_O, sigdashes__)
#define OINX_signature_repost            OINX(oinx_OPT_O, signature_repost__)
#define OINX_advertising                 OINX(oinx_OPT_O, advertising__)
#if defined(HAVE_ICONV_OPEN_TRANSLIT) && defined(CHARSET_CONVERSION)
#define OINX_translit                    OINX(oinx_OPT_O, translit__)
#endif
#define OINX_post_8bit_header            OINX(oinx_OPT_O, post_8bit_header__)
#define OINX_mail_8bit_header            OINX(oinx_OPT_O, mail_8bit_header__)
#define OINX_auto_cc                     OINX(oinx_OPT_O, auto_cc__)
#define OINX_auto_bcc                    OINX(oinx_OPT_O, auto_bcc__)
#define OINX_batch_save                  OINX(oinx_OPT_O, batch_save__)
#define OINX_auto_save                   OINX(oinx_OPT_O, auto_save__)
#define OINX_mark_saved_read             OINX(oinx_OPT_O, mark_saved_read__)
#define OINX_post_process_view           OINX(oinx_OPT_O, post_process_view__)
#define OINX_process_only_unread         OINX(oinx_OPT_O, process_only_unread__)
#ifndef DISABLE_PRINTING
#define OINX_print_header                OINX(oinx_OPT_O, print_header__)
#endif
#define OINX_force_screen_redraw         OINX(oinx_OPT_O, force_screen_redraw__)
#define OINX_start_editor_offset         OINX(oinx_OPT_O, start_editor_offset__)
#define OINX_unlink_article              OINX(oinx_OPT_O, unlink_article__)
#define OINX_keep_dead_articles          OINX(oinx_OPT_O, keep_dead_articles__)
#define OINX_strip_newsrc                OINX(oinx_OPT_O, strip_newsrc__)
#define OINX_auto_reconnect              OINX(oinx_OPT_O, auto_reconnect__)
#define OINX_cache_overview_files        OINX(oinx_OPT_O, cache_overview_files__)
#ifdef XFACE_ABLE
#define OINX_use_slrnface                OINX(oinx_OPT_O, use_slrnface__)
#endif
#if defined(HAVE_LIBICUUC) && defined(MULTIBYTE_ABLE) && defined(HAVE_UNICODE_UBIDI_H) && !defined(NO_LOCALE)
#define OINX_render_bidi                 OINX(oinx_OPT_O, render_bidi__)
#endif

char * OPT_CHAR_list[] = {
	&tinrc.art_marked_deleted,        /*  0: art_marked_deleted__ */
	&tinrc.art_marked_inrange,        /*  1: art_marked_inrange__ */
	&tinrc.art_marked_return,         /*  2: art_marked_return__ */
	&tinrc.art_marked_selected,       /*  3: art_marked_selected__ */
	&tinrc.art_marked_recent,         /*  4: art_marked_recent__ */
	&tinrc.art_marked_unread,         /*  5: art_marked_unread__ */
	&tinrc.art_marked_read,           /*  6: art_marked_read__ */
	&tinrc.art_marked_killed,         /*  7: art_marked_killed__ */
	&tinrc.art_marked_read_selected,  /*  8: art_marked_read_selected__ */
};

typedef OTYP {
	OVAL(oinx_OPT_C, art_marked_deleted__)
	OVAL(oinx_OPT_C, art_marked_inrange__)
	OVAL(oinx_OPT_C, art_marked_return__)
	OVAL(oinx_OPT_C, art_marked_selected__)
	OVAL(oinx_OPT_C, art_marked_recent__)
	OVAL(oinx_OPT_C, art_marked_unread__)
	OVAL(oinx_OPT_C, art_marked_read__)
	OVAL(oinx_OPT_C, art_marked_killed__)
	OVAL(oinx_OPT_C, art_marked_read_selected__)
	OVAL(oinx_OPT_C, s_MAX)
	OEND(oinx_OPT_C, Q1)
} oinx_OPT_C;

#define OINX_art_marked_deleted          OINX(oinx_OPT_C, art_marked_deleted__)
#define OINX_art_marked_inrange          OINX(oinx_OPT_C, art_marked_inrange__)
#define OINX_art_marked_return           OINX(oinx_OPT_C, art_marked_return__)
#define OINX_art_marked_selected         OINX(oinx_OPT_C, art_marked_selected__)
#define OINX_art_marked_recent           OINX(oinx_OPT_C, art_marked_recent__)
#define OINX_art_marked_unread           OINX(oinx_OPT_C, art_marked_unread__)
#define OINX_art_marked_read             OINX(oinx_OPT_C, art_marked_read__)
#define OINX_art_marked_killed           OINX(oinx_OPT_C, art_marked_killed__)
#define OINX_art_marked_read_selected    OINX(oinx_OPT_C, art_marked_read_selected__)

char * OPT_STRING_list[] = {
	tinrc.news_headers_to_display,    /*  0: news_headers_to_display__ */
	tinrc.news_headers_to_not_display, /*  1: news_headers_to_not_display__ */
	tinrc.metamail_prog,              /*  2: metamail_prog__ */
	tinrc.mail_address,               /*  3: mail_address__ */
	tinrc.sigfile,                    /*  4: sigfile__ */
	tinrc.quote_chars,                /*  5: quote_chars__ */
	tinrc.news_quote_format,          /*  6: news_quote_format__ */
	tinrc.xpost_quote_format,         /*  7: xpost_quote_format__ */
	tinrc.mail_quote_format,          /*  8: mail_quote_format__ */
#ifndef CHARSET_CONVERSION
	tinrc.mm_charset,                 /*  9: mm_charset__ */
#endif
	tinrc.spamtrap_warning_addresses, /* 10: spamtrap_warning_addresses__ */
	tinrc.maildir,                    /* 11: maildir__ */
	tinrc.savedir,                    /* 12: savedir__ */
#ifndef DISABLE_PRINTING
	tinrc.printer,                    /* 13: printer__ */
#endif
#ifdef HAVE_COLOR
	tinrc.quote_regex,                /* 14: quote_regex__ */
	tinrc.quote_regex2,               /* 15: quote_regex2__ */
	tinrc.quote_regex3,               /* 16: quote_regex3__ */
#endif
	tinrc.slashes_regex,              /* 17: slashes_regex__ */
	tinrc.stars_regex,                /* 18: stars_regex__ */
	tinrc.strokes_regex,              /* 19: strokes_regex__ */
	tinrc.underscores_regex,          /* 20: underscores_regex__ */
	tinrc.strip_re_regex,             /* 21: strip_re_regex__ */
	tinrc.strip_was_regex,            /* 22: strip_was_regex__ */
	tinrc.editor_format,              /* 23: editor_format__ */
	tinrc.inews_prog,                 /* 24: inews_prog__ */
	tinrc.mailer_format,              /* 25: mailer_format__ */
	tinrc.posted_articles_file,       /* 26: posted_articles_file__ */
	tinrc.url_handler,                /* 27: url_handler__ */
	tinrc.date_format,                /* 28: date_format__ */
};

typedef OTYP {
	OVAL(oinx_OPT_S, news_headers_to_display__)
	OVAL(oinx_OPT_S, news_headers_to_not_display__)
	OVAL(oinx_OPT_S, metamail_prog__)
	OVAL(oinx_OPT_S, mail_address__)
	OVAL(oinx_OPT_S, sigfile__)
	OVAL(oinx_OPT_S, quote_chars__)
	OVAL(oinx_OPT_S, news_quote_format__)
	OVAL(oinx_OPT_S, xpost_quote_format__)
	OVAL(oinx_OPT_S, mail_quote_format__)
#ifndef CHARSET_CONVERSION
	OVAL(oinx_OPT_S, mm_charset__)
#endif
	OVAL(oinx_OPT_S, spamtrap_warning_addresses__)
	OVAL(oinx_OPT_S, maildir__)
	OVAL(oinx_OPT_S, savedir__)
#ifndef DISABLE_PRINTING
	OVAL(oinx_OPT_S, printer__)
#endif
#ifdef HAVE_COLOR
	OVAL(oinx_OPT_S, quote_regex__)
	OVAL(oinx_OPT_S, quote_regex2__)
	OVAL(oinx_OPT_S, quote_regex3__)
#endif
	OVAL(oinx_OPT_S, slashes_regex__)
	OVAL(oinx_OPT_S, stars_regex__)
	OVAL(oinx_OPT_S, strokes_regex__)
	OVAL(oinx_OPT_S, underscores_regex__)
	OVAL(oinx_OPT_S, strip_re_regex__)
	OVAL(oinx_OPT_S, strip_was_regex__)
	OVAL(oinx_OPT_S, editor_format__)
	OVAL(oinx_OPT_S, inews_prog__)
	OVAL(oinx_OPT_S, mailer_format__)
	OVAL(oinx_OPT_S, posted_articles_file__)
	OVAL(oinx_OPT_S, url_handler__)
	OVAL(oinx_OPT_S, date_format__)
	OVAL(oinx_OPT_S, s_MAX)
	OEND(oinx_OPT_S, Q1)
} oinx_OPT_S;

#define OINX_news_headers_to_display     OINX(oinx_OPT_S, news_headers_to_display__)
#define OINX_news_headers_to_not_display OINX(oinx_OPT_S, news_headers_to_not_display__)
#define OINX_metamail_prog               OINX(oinx_OPT_S, metamail_prog__)
#define OINX_mail_address                OINX(oinx_OPT_S, mail_address__)
#define OINX_sigfile                     OINX(oinx_OPT_S, sigfile__)
#define OINX_quote_chars                 OINX(oinx_OPT_S, quote_chars__)
#define OINX_news_quote_format           OINX(oinx_OPT_S, news_quote_format__)
#define OINX_xpost_quote_format          OINX(oinx_OPT_S, xpost_quote_format__)
#define OINX_mail_quote_format           OINX(oinx_OPT_S, mail_quote_format__)
#ifndef CHARSET_CONVERSION
#define OINX_mm_charset                  OINX(oinx_OPT_S, mm_charset__)
#endif
#define OINX_spamtrap_warning_addresses  OINX(oinx_OPT_S, spamtrap_warning_addresses__)
#define OINX_maildir                     OINX(oinx_OPT_S, maildir__)
#define OINX_savedir                     OINX(oinx_OPT_S, savedir__)
#ifndef DISABLE_PRINTING
#define OINX_printer                     OINX(oinx_OPT_S, printer__)
#endif
#ifdef HAVE_COLOR
#define OINX_quote_regex                 OINX(oinx_OPT_S, quote_regex__)
#define OINX_quote_regex2                OINX(oinx_OPT_S, quote_regex2__)
#define OINX_quote_regex3                OINX(oinx_OPT_S, quote_regex3__)
#endif
#define OINX_slashes_regex               OINX(oinx_OPT_S, slashes_regex__)
#define OINX_stars_regex                 OINX(oinx_OPT_S, stars_regex__)
#define OINX_strokes_regex               OINX(oinx_OPT_S, strokes_regex__)
#define OINX_underscores_regex           OINX(oinx_OPT_S, underscores_regex__)
#define OINX_strip_re_regex              OINX(oinx_OPT_S, strip_re_regex__)
#define OINX_strip_was_regex             OINX(oinx_OPT_S, strip_was_regex__)
#define OINX_editor_format               OINX(oinx_OPT_S, editor_format__)
#define OINX_inews_prog                  OINX(oinx_OPT_S, inews_prog__)
#define OINX_mailer_format               OINX(oinx_OPT_S, mailer_format__)
#define OINX_posted_articles_file        OINX(oinx_OPT_S, posted_articles_file__)
#define OINX_url_handler                 OINX(oinx_OPT_S, url_handler__)
#define OINX_date_format                 OINX(oinx_OPT_S, date_format__)

#define OPT_TITLE     0
#define OPT_ON_OFF    1
#define OPT_LIST      2
#define OPT_STRING    3
#define OPT_NUM       4
#define OPT_CHAR      5

struct t_option option_table[]={
  { OPT_TITLE,   0, NULL, NULL, 0, &txt_display_options },
  { OPT_ON_OFF,  OINX_beginner_level, 0, NULL, 0, &txt_beginner_level },
  { OPT_ON_OFF,  OINX_show_description, 0, NULL, 0, &txt_show_description },
  { OPT_LIST,    0, &tinrc.show_author, txt_show_from, SHOW_FROM_BOTH+1, &txt_show_author },
  { OPT_ON_OFF,  OINX_draw_arrow, 0, NULL, 0, &txt_draw_arrow },
  { OPT_ON_OFF,  OINX_inverse_okay, 0, NULL, 0, &txt_inverse_okay },
  { OPT_ON_OFF,  OINX_strip_blanks, 0, NULL, 0, &txt_strip_blanks },
  { OPT_LIST,    0, &tinrc.thread_articles, txt_threading, THREAD_MAX+1, &txt_thread_articles },
  { OPT_NUM,     0, &tinrc.thread_perc, NULL, 0, &txt_thread_perc },
  { OPT_LIST,    0, &tinrc.sort_article_type, txt_sort_a_type, SORT_ARTICLES_BY_LINES_ASCEND+1, &txt_sort_article_type },
  { OPT_LIST,    0, &tinrc.sort_threads_type, txt_sort_t_type, SORT_THREADS_BY_SCORE_ASCEND+1, &txt_sort_threads_type },
  { OPT_ON_OFF,  OINX_pos_first_unread, 0, NULL, 0, &txt_pos_first_unread },
  { OPT_ON_OFF,  OINX_show_only_unread_arts, 0, NULL, 0, &txt_show_only_unread_arts },
  { OPT_ON_OFF,  OINX_show_only_unread_groups, 0, NULL, 0, &txt_show_only_unread_groups },
  { OPT_LIST,    0, &tinrc.kill_level, txt_kill_level_type, KILL_NOTHREAD+1, &txt_kill_level },
  { OPT_ON_OFF,  OINX_tab_goto_next_unread, 0, NULL, 0, &txt_tab_goto_next_unread },
  { OPT_ON_OFF,  OINX_space_goto_next_unread, 0, NULL, 0, &txt_space_goto_next_unread },
  { OPT_ON_OFF,  OINX_pgdn_goto_next, 0, NULL, 0, &txt_pgdn_goto_next },
  { OPT_ON_OFF,  OINX_auto_list_thread, 0, NULL, 0, &txt_auto_list_thread },
  { OPT_ON_OFF,  OINX_wrap_on_next_unread, 0, NULL, 0, &txt_wrap_on_next_unread },
  { OPT_CHAR,    OINX_art_marked_deleted, 0, NULL, 0, &txt_art_marked_deleted },
  { OPT_CHAR,    OINX_art_marked_inrange, 0, NULL, 0, &txt_art_marked_inrange },
  { OPT_CHAR,    OINX_art_marked_return, 0, NULL, 0, &txt_art_marked_return },
  { OPT_CHAR,    OINX_art_marked_selected, 0, NULL, 0, &txt_art_marked_selected },
  { OPT_CHAR,    OINX_art_marked_recent, 0, NULL, 0, &txt_art_marked_recent },
  { OPT_CHAR,    OINX_art_marked_unread, 0, NULL, 0, &txt_art_marked_unread },
  { OPT_CHAR,    OINX_art_marked_read, 0, NULL, 0, &txt_art_marked_read },
  { OPT_CHAR,    OINX_art_marked_killed, 0, NULL, 0, &txt_art_marked_killed },
  { OPT_CHAR,    OINX_art_marked_read_selected, 0, NULL, 0, &txt_art_marked_read_selected },
  { OPT_NUM,     0, &tinrc.groupname_max_length, NULL, 0, &txt_groupname_max_length },
  { OPT_LIST,    0, &tinrc.show_info, txt_show_info_type, SHOW_INFO_BOTH+1, &txt_show_info },
  { OPT_LIST,    0, &tinrc.thread_score, txt_thread_score_type, THREAD_SCORE_WEIGHT+1, &txt_thread_score },
  { OPT_NUM,     0, &tinrc.scroll_lines, NULL, 0, &txt_scroll_lines },
  { OPT_ON_OFF,  OINX_show_signatures, 0, NULL, 0, &txt_show_signatures },
  { OPT_STRING,  OINX_news_headers_to_display, 0, NULL, 0, &txt_news_headers_to_display },
  { OPT_STRING,  OINX_news_headers_to_not_display, 0, NULL, 0, &txt_news_headers_to_not_display },
  { OPT_ON_OFF,  OINX_alternative_handling, 0, NULL, 0, &txt_alternative_handling },
  { OPT_LIST,    0, &tinrc.hide_uue, txt_hide_uue_type, UUE_ALL+1, &txt_hide_uue },
  { OPT_ON_OFF,  OINX_tex2iso_conv, 0, NULL, 0, &txt_tex2iso_conv },
  { OPT_STRING,  OINX_metamail_prog, 0, NULL, 0, &txt_metamail_prog },
  { OPT_ON_OFF,  OINX_ask_for_metamail, 0, NULL, 0, &txt_ask_for_metamail },
  { OPT_ON_OFF,  OINX_catchup_read_groups, 0, NULL, 0, &txt_catchup_read_groups },
  { OPT_ON_OFF,  OINX_group_catchup_on_exit, 0, NULL, 0, &txt_group_catchup_on_exit },
  { OPT_ON_OFF,  OINX_thread_catchup_on_exit, 0, NULL, 0, &txt_thread_catchup_on_exit },
  { OPT_LIST,    0, &tinrc.confirm_choice, txt_confirm_choices, NUM_CONFIRM_CHOICES, &txt_confirm_choice },
  { OPT_ON_OFF,  OINX_mark_ignore_tags, 0, NULL, 0, &txt_mark_ignore_tags },
  { OPT_ON_OFF,  OINX_use_mouse, 0, NULL, 0, &txt_use_mouse },
#ifdef HAVE_KEYPAD
  { OPT_ON_OFF,  OINX_use_keypad, 0, NULL, 0, &txt_use_keypad },
#endif
  { OPT_NUM,     0, &tinrc.wrap_column, NULL, 0, &txt_wrap_column },
  { OPT_TITLE,   0, NULL, NULL, 0, &txt_getart_limit_options },
  { OPT_NUM,     0, &tinrc.getart_limit, NULL, 0, &txt_getart_limit },
  { OPT_NUM,     0, &tinrc.recent_time, NULL, 0, &txt_recent_time },
  { OPT_TITLE,   0, NULL, NULL, 0, &txt_filtering_options },
  { OPT_LIST,    0, &tinrc.wildcard, txt_wildcard_type, 2, &txt_wildcard },
  { OPT_NUM,     0, &tinrc.score_limit_kill, NULL, 0, &txt_score_limit_kill },
  { OPT_NUM,     0, &tinrc.score_kill, NULL, 0, &txt_score_kill },
  { OPT_NUM,     0, &tinrc.score_limit_select, NULL, 0, &txt_score_limit_select },
  { OPT_NUM,     0, &tinrc.score_select, NULL, 0, &txt_score_select },
  { OPT_NUM,     0, &tinrc.filter_days, NULL, 0, &txt_filter_days },
  { OPT_ON_OFF,  OINX_add_posted_to_filter, 0, NULL, 0, &txt_add_posted_to_filter },
#ifdef HAVE_COLOR
  { OPT_TITLE,   0, NULL, NULL, 0, &txt_color_options },
  { OPT_ON_OFF,  OINX_use_color, 0, NULL, 0, &txt_use_color },
  { OPT_LIST,    0, &tinrc.col_normal, txt_colors, MAX_COLOR+1, &txt_col_normal },
  { OPT_LIST,    0, &tinrc.col_back, txt_colors, MAX_COLOR+1, &txt_col_back },
  { OPT_LIST,    0, &tinrc.col_invers_bg, txt_colors, MAX_COLOR+1, &txt_col_invers_bg },
  { OPT_LIST,    0, &tinrc.col_invers_fg, txt_colors, MAX_COLOR+1, &txt_col_invers_fg },
  { OPT_LIST,    0, &tinrc.col_text, txt_colors, MAX_COLOR+1, &txt_col_text },
  { OPT_LIST,    0, &tinrc.col_minihelp, txt_colors, MAX_COLOR+1, &txt_col_minihelp },
  { OPT_LIST,    0, &tinrc.col_help, txt_colors, MAX_COLOR+1, &txt_col_help },
  { OPT_LIST,    0, &tinrc.col_message, txt_colors, MAX_COLOR+1, &txt_col_message },
  { OPT_LIST,    0, &tinrc.col_quote, txt_colors, MAX_COLOR+1, &txt_col_quote },
  { OPT_LIST,    0, &tinrc.col_quote2, txt_colors, MAX_COLOR+1, &txt_col_quote2 },
  { OPT_LIST,    0, &tinrc.col_quote3, txt_colors, MAX_COLOR+1, &txt_col_quote3 },
  { OPT_LIST,    0, &tinrc.col_head, txt_colors, MAX_COLOR+1, &txt_col_head },
  { OPT_LIST,    0, &tinrc.col_newsheaders, txt_colors, MAX_COLOR+1, &txt_col_newsheaders },
  { OPT_LIST,    0, &tinrc.col_subject, txt_colors, MAX_COLOR+1, &txt_col_subject },
  { OPT_LIST,    0, &tinrc.col_response, txt_colors, MAX_COLOR+1, &txt_col_response },
  { OPT_LIST,    0, &tinrc.col_from, txt_colors, MAX_COLOR+1, &txt_col_from },
  { OPT_LIST,    0, &tinrc.col_title, txt_colors, MAX_COLOR+1, &txt_col_title },
  { OPT_LIST,    0, &tinrc.col_signature, txt_colors, MAX_COLOR+1, &txt_col_signature },
  { OPT_LIST,    0, &tinrc.col_urls, txt_colors, MAX_COLOR+1, &txt_col_urls },
#endif
  { OPT_ON_OFF,  OINX_url_highlight, 0, NULL, 0, &txt_url_highlight },
  { OPT_ON_OFF,  OINX_word_highlight, 0, NULL, 0, &txt_word_highlight },
  { OPT_LIST,    0, &tinrc.word_h_display_marks, txt_marks, MAX_MARK+1, &txt_word_h_display_marks },
#ifdef HAVE_COLOR
  { OPT_LIST,    0, &tinrc.col_markstar, txt_colors, MAX_COLOR+1, &txt_col_markstar },
  { OPT_LIST,    0, &tinrc.col_markdash, txt_colors, MAX_COLOR+1, &txt_col_markdash },
  { OPT_LIST,    0, &tinrc.col_markslash, txt_colors, MAX_COLOR+1, &txt_col_markslash },
  { OPT_LIST,    0, &tinrc.col_markstroke, txt_colors, MAX_COLOR+1, &txt_col_markstroke },
#endif
  { OPT_LIST,    0, &tinrc.mono_markstar, txt_attrs, MAX_ATTR+1, &txt_mono_markstar },
  { OPT_LIST,    0, &tinrc.mono_markdash, txt_attrs, MAX_ATTR+1, &txt_mono_markdash },
  { OPT_LIST,    0, &tinrc.mono_markslash, txt_attrs, MAX_ATTR+1, &txt_mono_markslash },
  { OPT_LIST,    0, &tinrc.mono_markstroke, txt_attrs, MAX_ATTR+1, &txt_mono_markstroke },
  { OPT_TITLE,   0, NULL, NULL, 0, &txt_posting_options },
  { OPT_STRING,  OINX_mail_address, 0, NULL, 0, &txt_mail_address },
  { OPT_ON_OFF,  OINX_prompt_followupto, 0, NULL, 0, &txt_prompt_followupto },
  { OPT_STRING,  OINX_sigfile, 0, NULL, 0, &txt_sigfile },
  { OPT_ON_OFF,  OINX_sigdashes, 0, NULL, 0, &txt_sigdashes },
  { OPT_ON_OFF,  OINX_signature_repost, 0, NULL, 0, &txt_signature_repost },
  { OPT_STRING,  OINX_quote_chars, 0, NULL, 0, &txt_quote_chars },
  { OPT_LIST,    0, &tinrc.quote_style, txt_quote_style_type, (QUOTE_COMPRESS|QUOTE_SIGS|QUOTE_EMPTY)+1, &txt_quote_style },
  { OPT_STRING,  OINX_news_quote_format, 0, NULL, 0, &txt_news_quote_format },
  { OPT_STRING,  OINX_xpost_quote_format, 0, NULL, 0, &txt_xpost_quote_format },
  { OPT_STRING,  OINX_mail_quote_format, 0, NULL, 0, &txt_mail_quote_format },
  { OPT_ON_OFF,  OINX_advertising, 0, NULL, 0, &txt_advertising },
#if defined(HAVE_ICONV_OPEN_TRANSLIT) && defined(CHARSET_CONVERSION)
  { OPT_ON_OFF,  OINX_translit, 0, NULL, 0, &txt_translit },
#endif
#ifndef CHARSET_CONVERSION
  { OPT_STRING,  OINX_mm_charset, 0, NULL, 0, &txt_mm_charset },
#endif
#ifdef CHARSET_CONVERSION
  { OPT_LIST,    0, &tinrc.mm_network_charset, txt_mime_charsets, NUM_MIME_CHARSETS, &txt_mm_network_charset },
#endif
  { OPT_LIST,    0, &tinrc.post_mime_encoding, txt_mime_encodings, NUM_MIME_ENCODINGS, &txt_post_mime_encoding },
  { OPT_ON_OFF,  OINX_post_8bit_header, 0, NULL, 0, &txt_post_8bit_header },
  { OPT_LIST,    0, &tinrc.mail_mime_encoding, txt_mime_encodings, NUM_MIME_ENCODINGS, &txt_mail_mime_encoding },
  { OPT_ON_OFF,  OINX_mail_8bit_header, 0, NULL, 0, &txt_mail_8bit_header },
  { OPT_ON_OFF,  OINX_auto_cc, 0, NULL, 0, &txt_auto_cc },
  { OPT_ON_OFF,  OINX_auto_bcc, 0, NULL, 0, &txt_auto_bcc },
  { OPT_STRING,  OINX_spamtrap_warning_addresses, 0, NULL, 0, &txt_spamtrap_warning_addresses },
  { OPT_TITLE,   0, NULL, NULL, 0, &txt_saving_options },
  { OPT_STRING,  OINX_maildir, 0, NULL, 0, &txt_maildir },
  { OPT_LIST,    0, &tinrc.mailbox_format, txt_mailbox_formats, NUM_MAILBOX_FORMATS, &txt_mailbox_format },
  { OPT_ON_OFF,  OINX_batch_save, 0, NULL, 0, &txt_batch_save },
  { OPT_STRING,  OINX_savedir, 0, NULL, 0, &txt_savedir },
  { OPT_ON_OFF,  OINX_auto_save, 0, NULL, 0, &txt_auto_save },
  { OPT_ON_OFF,  OINX_mark_saved_read, 0, NULL, 0, &txt_mark_saved_read },
  { OPT_LIST,    0, &tinrc.post_process, txt_post_process_type, POST_PROC_YES+1, &txt_post_process },
  { OPT_ON_OFF,  OINX_post_process_view, 0, NULL, 0, &txt_post_process_view },
  { OPT_ON_OFF,  OINX_process_only_unread, 0, NULL, 0, &txt_process_only_unread },
#ifndef DISABLE_PRINTING
  { OPT_ON_OFF,  OINX_print_header, 0, NULL, 0, &txt_print_header },
  { OPT_STRING,  OINX_printer, 0, NULL, 0, &txt_printer },
#endif
  { OPT_TITLE,   0, NULL, NULL, 0, &txt_expert_options },
#ifdef HAVE_COLOR
  { OPT_STRING,  OINX_quote_regex, 0, NULL, 0, &txt_quote_regex },
  { OPT_STRING,  OINX_quote_regex2, 0, NULL, 0, &txt_quote_regex2 },
  { OPT_STRING,  OINX_quote_regex3, 0, NULL, 0, &txt_quote_regex3 },
#endif
  { OPT_STRING,  OINX_slashes_regex, 0, NULL, 0, &txt_slashes_regex },
  { OPT_STRING,  OINX_stars_regex, 0, NULL, 0, &txt_stars_regex },
  { OPT_STRING,  OINX_strokes_regex, 0, NULL, 0, &txt_strokes_regex },
  { OPT_STRING,  OINX_underscores_regex, 0, NULL, 0, &txt_underscores_regex },
  { OPT_STRING,  OINX_strip_re_regex, 0, NULL, 0, &txt_strip_re_regex },
  { OPT_STRING,  OINX_strip_was_regex, 0, NULL, 0, &txt_strip_was_regex },
  { OPT_ON_OFF,  OINX_force_screen_redraw, 0, NULL, 0, &txt_force_screen_redraw },
  { OPT_ON_OFF,  OINX_start_editor_offset, 0, NULL, 0, &txt_start_editor_offset },
  { OPT_STRING,  OINX_editor_format, 0, NULL, 0, &txt_editor_format },
  { OPT_STRING,  OINX_inews_prog, 0, NULL, 0, &txt_inews_prog },
  { OPT_STRING,  OINX_mailer_format, 0, NULL, 0, &txt_mailer_format },
  { OPT_LIST,    0, &tinrc.interactive_mailer, txt_interactive_mailers, NUM_INTERACTIVE_MAILERS, &txt_interactive_mailer },
  { OPT_ON_OFF,  OINX_unlink_article, 0, NULL, 0, &txt_unlink_article },
  { OPT_STRING,  OINX_posted_articles_file, 0, NULL, 0, &txt_posted_articles_file },
  { OPT_ON_OFF,  OINX_keep_dead_articles, 0, NULL, 0, &txt_keep_dead_articles },
  { OPT_ON_OFF,  OINX_strip_newsrc, 0, NULL, 0, &txt_strip_newsrc },
  { OPT_LIST,    0, &tinrc.strip_bogus, txt_strip_bogus_type, BOGUS_SHOW+1, &txt_strip_bogus },
  { OPT_NUM,     0, &tinrc.reread_active_file_secs, NULL, 0, &txt_reread_active_file_secs },
  { OPT_ON_OFF,  OINX_auto_reconnect, 0, NULL, 0, &txt_auto_reconnect },
  { OPT_ON_OFF,  OINX_cache_overview_files, 0, NULL, 0, &txt_cache_overview_files },
#ifdef XFACE_ABLE
  { OPT_ON_OFF,  OINX_use_slrnface, 0, NULL, 0, &txt_use_slrnface },
#endif
  { OPT_STRING,  OINX_url_handler, 0, NULL, 0, &txt_url_handler },
  { OPT_STRING,  OINX_date_format, 0, NULL, 0, &txt_date_format },
#ifdef HAVE_UNICODE_NORMALIZATION
#	ifdef HAVE_LIBICUUC
  { OPT_LIST,    0, &tinrc.normalization_form, txt_normalization_forms, NORMALIZE_NFD+1, &txt_normalization_form },
#	else
#		ifdef HAVE_LIBIDN
  { OPT_LIST,    0, &tinrc.normalization_form, txt_normalization_forms, 2, &txt_normalization_form },
#		endif
#	endif
#endif
#if defined(HAVE_LIBICUUC) && defined(MULTIBYTE_ABLE) && defined(HAVE_UNICODE_UBIDI_H) && !defined(NO_LOCALE)
  { OPT_ON_OFF,  OINX_render_bidi, 0, NULL, 0, &txt_render_bidi },
#endif
};

/* We needed these only to make the table compile */
#undef OINX
#undef OVAL
#undef OEND
#undef OTYP

#endif /* TINCFG_H */