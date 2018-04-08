#!/bin/bash
string="hello,shell,haha"
echo 'string' $string
OLD_IFS="$IFS"
echo 'OLD_IFS' $OLD_IFS
IFS=","
echo 'IFS' $IFS
array=($string)
echo 'array' $array
IFS="$OLD_IFS"
echo 'IFS' $IFS
for var in ${array[@]}
do
   echo $var
done
