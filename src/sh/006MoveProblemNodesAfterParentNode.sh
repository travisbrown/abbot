# 

for i in `ls output/*.xml`
do
	file=`basename $i`
	java net.sf.saxon.Transform -w0 $i src/xslt/moveProblemNodesAfterParentNode.xsl > output/${file}.tmp file=$file
	mv output/${file}.tmp output/${file}
done;





