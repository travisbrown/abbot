# Fix end of page hyphens in XML files in target directory

fileCount=`grep -l "\-[ ]*<\/orig>[ ]*<pb" ${target_dir}/*.xml | wc -l`


if [ "$fileCount" -ne '0' ]
then 
	 
	 echo -n "Note: ${fileCount} files contain problematic end-of-page hyphens, and will be corrected.  "

	mkdir $target_dir/fixedHyphensTemp

	for i in `grep -l "\-[ ]*<\/orig>[ ]*<pb" ${target_dir}/*.xml` 
	do
		 file=`basename $i`
    echo "Correcting end-of-page hyphen(s) in $file ...."
    java net.sf.saxon.Transform -w0 $i src/xslt/fixEndOfPageHyphensForMONK.xsl > $target_dir/fixedHyphensTemp/temp.xml
    mv $target_dir/fixedHyphensTemp/temp.xml $target_dir/fixedHyphensTemp/$file
	done 
fi





