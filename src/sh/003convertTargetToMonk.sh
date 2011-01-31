
# Run XMLtoMonkXML on XML files in target directory

count=1
total=`ls $target_dir/*.xml | wc -l`

for i in `ls $target_dir/*.xml`
do
	file=`basename $i`
	echo -e -n "\rProcessing (${count}/${total}): $file ... "
	java net.sf.saxon.Transform -w0 $i src/xslt/XMLtoMonkXML.xsl > output/${file} file=$file
	let "count += 1"
done;

echo "done"
