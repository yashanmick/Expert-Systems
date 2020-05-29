#!/bin/sh
# *******************************************************************
# Run one test.
# 
# First arg is the directory in which to run the test. 
# *******************************************************************

. shelldefs.mk

export CLASSPATH

cd $1

SCRIPT=runtest.sh
chmod +x $SCRIPT

echo
echo "$1..."

if test -f $SCRIPT.disable ; then
    echo "    Test is disabled."
    cat $SCRIPT.disable
    exit 0
fi

$SCRIPT > runtest.out 

# Diff the output with the expected outout.
if diff  runtest.out runtest.ref > /dev/null ; then
    # files are the same
    echo "     Test succeeded"
else
    # files are different
    failed=1
    echo "     Test failed.  See:"
    echo "           diff $1/runtest.out $1/runtest.ref"
fi

exit ${failed:-0}

