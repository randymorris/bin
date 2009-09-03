#!/bin/bash
#
# check_ip.sh - check if external ip address has changed, notify via email if
# it has
#
# CREATED: 2009-08-10 12:23
# MODIFIED: 2009-09-03 07:56
#
 
IP=$HOME/tmp/ip/current_external_ip
TEMP=$HOME/tmp/ip/temp_ip
EMAIL_LIST=$(< $HOME/.email)

function _save_and_mail {
    mv $TEMP $IP
    echo "$HOSTNAME is now at $(< $IP)" | mail -s $(< $IP) $EMAIL_LIST
}
 
wget -q "www.whatismyip.com/automation/n09230945.asp" -O $TEMP
chmod 600 $TEMP
 
if [ -f $IP ]; then
    diff $TEMP $IP &> /dev/null || _save_and_mail
else
    _save_and_mail
fi
