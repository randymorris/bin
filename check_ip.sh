#!/bin/bash
#
# check_ip.sh - check if external ip address has changed, notify via email if
# it has
#
# CREATED: 2009-08-10 12:23
# MODIFIED: 2009-10-06 08:07
#
 
IP=$HOME/tmp/ip/current_external_ip
TEMP=$HOME/tmp/ip/temp_ip
EMAIL_LIST=$(< $HOME/.email)
LOG=$HOME/tmp/ip/error_log
IP_SERVICE="www.whatismyip.com/automation/n09230945.asp" 

function _save_and_mail {
    cp $TEMP $IP
    echo "$HOSTNAME is now at $(< $IP)" | mail -s $(< $IP) $EMAIL_LIST
}

function _get_ip {
    wget -q $IP_SERVICE -O $TEMP
    [ "$(file -b $TEMP)" == empty ] && return 0 || return 1
}

function _log {
    echo -n $(date) >> $LOG
    echo " - $1" >> $LOG
}

while true; do 
    _get_ip
    [ $? -eq 1 ] && break
    _log "$IP_SERVICE returned a zero byte file"
    sleep 30s
done
    
chmod 600 $TEMP
 
if [ -f $IP ]; then
    diff $TEMP $IP &> /dev/null || _save_and_mail
else
    _save_and_mail
fi
