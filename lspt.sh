#!/bin/bash
#
# lspt.sh - much simpler version of lspt.py
#
# CREATED:  2009-09-03 17:30
# MODIFIED: 2009-09-03 17:46
#

error() {
    echo $1 && exit 1
}

lsperms(){
    echo -e "$(ls -ld | cut -d' ' -f1,3,4)\t$1" |\
        sed -r "s/([^ ]* [^ ]*) (.*)/\1:\2/"
}

[ -a $1 ] || error "$1 does not exist"

[ -d $1 ] && cd $1 || cd $(dirname $1)

startdir=$PWD

while [ $PWD != "/" ]; do pushd .. &> /dev/null; done

while [ $PWD != $startdir ]; do
    lsperms $PWD
    popd &> /dev/null
done

[ -f $(basename $1) ] && lsperms ${PWD}$(basename $1)
