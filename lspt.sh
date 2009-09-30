#!/bin/bash
#
# lspt.sh - much simpler version of lspt.py
#
# CREATED:  2009-09-03 17:30
# MODIFIED: 2009-09-09 14:01
#

error() {
    echo $1 && exit 1
}

lsperms(){
    echo -e "$(ls -ld | cut -d' ' -f1,3,4)\t$1" |\
        sed -r "s/([^ ]* [^ ]*) (.*)/\1:\2/"
}

arg=$1

if [ -z $arg ]; then
    arg=$PWD
fi

[ -a $arg ] || error "$arg does not exist"
[ -d $arg ] && cd $arg || cd $(dirname $arg)

startdir=$PWD

while [ $PWD != "/" ]; do pushd .. &> /dev/null; done

while [ $PWD != $startdir ]; do
    lsperms $PWD
    popd &> /dev/null
done

lsperms $PWD

[ -f $(basename $arg) ] && lsperms ${PWD}/$(basename $arg) || exit 0
