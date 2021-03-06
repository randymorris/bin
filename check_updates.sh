#!/bin/bash
#
# check_updates.sh
#
# CREATED:  2008-11-03 13:32
# MODIFIED: 2010-11-10 12:29
#
ignore=$(sed -rn '/^\s*IgnorePkg/{s/.*=\s*//; s/\s+/|/gp}' /etc/pacman.conf)
updates=$(pacman -Qqu | grep -Ev "^($ignore)$" | wc -l)

[ $updates -gt 0 ] && echo -n "  $updates update"
[ $updates -gt 1 ] && echo "s" || exit 0
