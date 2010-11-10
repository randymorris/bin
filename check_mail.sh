#!/bin/bash
#
# check_mail.sh
#
# CREATED:  2009-02-02 08:43
# MODIFIED: 2010-07-22 07:19
#
MAILDIR="$HOME/.mail/INBOX/new/"
mail=$(ls -1 $MAILDIR | wc -l)

[ $mail -gt 0 ] && echo "  $mail mail"

MAILDIR="$HOME/.personal_mail/INBOX/new/"
mail=$(ls -1 $MAILDIR | wc -l)

[ $mail -gt 0 ] && echo "  $mail gmail" || exit 0
