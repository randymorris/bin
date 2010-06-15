#!/bin/bash
#
# check_mail.sh
#
# CREATED:  2009-02-02 08:43
# MODIFIED: 2010-05-20 09:25
#
MAILDIR="$HOME/.mail/lists/INBOX/new/"
mail=$(ls -1 $MAILDIR | wc -l)

[ $mail -gt 0 ] && echo "  $mail mail"

MAILDIR="$HOME/.mail/gmail/INBOX/new/"
mail=$(ls -1 $MAILDIR | wc -l)

[ $mail -gt 0 ] && echo "  $mail gmail" || exit 0
