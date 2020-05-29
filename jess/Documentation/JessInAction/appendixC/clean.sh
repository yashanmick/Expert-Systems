#!/bin/sh
# *******************************************************************
# Clean up the test directories:
# "make reallyclean"  in each directory.
# *******************************************************************

rm -f *~

for i in * ; do
    if test CVS = $i ; then 
        continue;
    fi
    if test -d $i ; then
        ( echo "   $i ..."; cd $i; \
	  MAKEFLAGS= ; export MAKEFLAGS ; make reallyclean )
    fi
done

