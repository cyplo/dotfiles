#!/usr/bin/bash
RESULT=""
for arg
do
if [[ "" != "$arg" ]] && [[ -e $arg ]];
then
OUT=`cygpath -wa $arg`
else
if [[ $arg == -* ]];
then
OUT=$arg
else
OUT="'$arg'"
fi
fi
RESULT=$RESULT$OUT" "
done
echo "$RESULT"

