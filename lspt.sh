#!/bin/bash
#
# lspt.sh - much simpler version of lspt.py
#
# CREATED:  2009-09-03 17:30
# MODIFIED: 2009-10-22 16:44
#

error() {
    echo $1 && exit 1
}

lsperms() {
    stat -c $'%A %U:%G\t%n' $1
}

while [ $# -ne 0 ]; do
    arg=$1
    shift

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

    [ -f $(basename $arg) ] && lsperms ${PWD}/$(basename $arg)

    echo
done

exit 0
