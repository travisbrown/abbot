#remove prior items, if any, from quarantined folder

rm -f quarantined/*.xml

#switch to log folder

cd log/

#identify invalid files
for f in `grep -l "is NOT valid" *.plog` 

do

      base=`basename $f .xml.plog`
      
#if invalid file exists, move to quarantine

      if [ -e ../output/${base}.xml ]
      then
     
      `mv ../output/${base}.xml ../quarantined/`
      echo "File $base.xml was moved to 'quarantined' folder.  "

      fi

echo " "

done;
