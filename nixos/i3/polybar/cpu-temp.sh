#!/usr/bin/env bash
sensors=`which sensors`
egrep=`which egrep`
cut=`which cut`
sort=`which sort`
uniq=`which uniq`
tail=`which tail`

max_temp=`$sensors | $egrep -o '[0-9][0-9]\.[0-9].*\(' | $cut -d' ' -f 1 | $sort | $uniq | $tail -n 1`

echo "${max_temp}"
