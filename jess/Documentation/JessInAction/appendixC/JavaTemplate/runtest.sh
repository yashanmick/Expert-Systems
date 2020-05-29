#!/bin/sh
# *******************************************************************
# Run a test written in Java
# *******************************************************************

. ../shelldefs.mk

#
# First, build the test.
# 

echo "Building..."
make clean > /dev/null 2>&1
make > test.errs 2>&1
echo "Build done"

if test ! -f test.class ; then
    echo "Build failed:"
    cat test.errs
    exit
else
    echo "Build Succeeded."
    rm test.errs
fi

# 
# Now, run the test, and make sure we get the right output.
# 

echo "Running the test program..."
${JAVA} test >test.out 2>&1

# Diff the output with the expected outout.
if diff --ignore-space-change test.out test.ref > /dev/null ; then
    # files are the same
    echo "Test succeeded"
else
    # files are different
    echo "Test failed.  Try:"
    echo "  diff --ignore-space-change test.out test.ref"
fi



