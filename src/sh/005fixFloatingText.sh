# Fix end of page hyphens in XML files in target directory

fileCount=`grep -l "<\/floatingText>" output/*.xml | wc -l`

echo $target_dir

echo $fileCount

if [ "$fileCount" -ne '0' ]
then 
	 
	 echo -n "Note: ${fileCount} files contain problematic <floatingText>, and will be examined.  "

	mkdir $target_dir/fixedFloatingTextTemp

	for i in `grep -l "<\/floatingText>" output/*.xml` 
	do
		 file=`basename $i`
   echo "Correcting <floatingText> elements in $file ...."
    java net.sf.saxon.Transform -w0 $i src/xslt/fixFloatingText.xsl > $target_dir/fixedFloatingTextTemp/temp.xml
    mv $target_dir/fixedFloatingTextTemp/temp.xml output/$file
	done 
fi





