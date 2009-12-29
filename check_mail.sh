#!/bin/bash
#
# check_mail.sh
#
# CREATED:  2009-02-02 08:43
# MODIFIED: 2009-12-01 16:32
#
MAILDIR="$HOME/.mail/INBOX/new/"
mail=$(ls -1 $MAILDIR | wc -l)

[ $mail -gt 0 ] && echo "  $mail mail" || exit 0
