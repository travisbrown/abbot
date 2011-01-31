#!/bin/sh

for i in `ls ../../output/*.xml`; 

do

# normalize superscripts

sed -i.bak -e 's/y\^e/the/g' $i
sed -i.bak -e 's/y\^t/that/g' $i
sed -i.bak -e 's/y\^u/thou/g' $i
sed -i.bak -e 's/y\^c/the/g' $i
sed -i.bak -e 's/y\^r/the/g' $i
sed -i.bak -e 's/w\^t/with/g' $i
sed -i.bak -e 's/1\^s\^t/1st/g' $i
sed -i.bak -e 's/2\^d/2nd/g' $i
sed -i.bak -e 's/2\^n\^d/2nd/g' $i
sed -i.bak -e 's/3\^d/3rd/g' $i
sed -i.bak -e 's/3\^r\^d/3rd/g' $i
sed -i.bak -e 's/\([3-9]\)\+\^th/\1th/g' $i
sed -i.bak -e 's/\([3-9]\)\+\^t\^h/\1th/g' $i
sed -i.bak -e 's/M\^r\s/Mrs/g' $i
sed -i.bak -e 's/M\^r/Mr/g' $i
sed -i.bak -e 's/S\^t/St/g' $i
sed -i.bak -e 's/D\^r/Dr/g' $i
sed -i.bak -e 's/S\^r\./Sir/g' $i
sed -i.bak -e 's/S\^r/Sir/g' $i
sed -i.bak -e 's/S\^i\^r/Sir/g' $i
sed -i.bak -e 's/w\^c\^h/which/g' $i

# Superscripts followed by gaps
sed -i.bak -e 's/\^\(<gap[^>]\+\)/<sup>\1><\/sup>/g' $i
  
# Reorders words with <hi> tags so that the superscript is
# included in the enclosing span.
 sed -i.bak -e 's/<hi>\(.\+?\)<\/hi>\^\(\w\+\)/<hi>\1<sup>\2<\/sup><\/hi>/g' $i
      
# Generic substitution for remaining superscripts
sed -i.bak -e 's/\^\([a-z^]\+\)/<sup>\1<\/sup>/g' $i
sed -i.bak -e 's/\^//g' $i

done;

rm ../xml/*.bak

echo "TCP superscripts have been converted. "
echo " "
