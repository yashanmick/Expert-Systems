#!/bin/sh
# *******************************************************************
# Run the test suite.
# *******************************************************************

for i in * ; do
    if test CVS = $i ; then
        continue;
    fi
    if test -d $i ; then
        ( sh run1test.sh $i ) || failed=1
    fi
done

exit ${failed:-0}
