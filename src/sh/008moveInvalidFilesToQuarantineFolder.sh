#remove prior items, if any, from quarantined folder

rm -f quarantined/*.xml

#identify invalid files
for f in `grep -c "is NOT valid" log/*.plog` 

do

      base=`basename $f .xml.plog:1`
      
#if invalid file exists, move to quarantine

      if [ -e output/${base}.xml ]
      then
     
      `mv output/$base.xml quarantined`
      echo "File $base.xml was moved to 'quarantined' folder.  "

      fi

echo " "

done;
