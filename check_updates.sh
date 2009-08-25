#!/bin/bash
#
# check_updates.sh
#
# CREATED:  2008-11-03 13:32
# MODIFIED: 2009-08-25 11:02
#
ignore=$(sed -r 's/^\s*IgnorePkg\s*=\s*//;tx;d;:x;s/\s+/|/g' /etc/pacman.conf)
updates=$(pacman -Qqu | grep -Ev "^$ignore$" | wc -l)

[ $updates -gt 0 ] && echo -n "  $updates update"
[ $updates -gt 1 ] && echo "s" || echo
