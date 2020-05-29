#!/bin/sh
# *******************************************************************
# Run a Jess-based test
# *******************************************************************

. ../shelldefs.mk

# 
# Now, run the test, and make sure we get the right output.
# 

echo "Running the test program..."
${JAVA} jess.Main -nologo test.clp >test.out 2>&1

# Diff the output with the expected outout.
if diff --ignore-space-change   test.out test.ref > /dev/null ; then
    # files are the same
    echo "Test succeeded"
else
    # files are different
    echo "Test failed.  Try:"
    echo "  diff --ignore-space-change test.out test.ref"
fi



