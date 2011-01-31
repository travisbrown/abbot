# Use TEIAnalytic schema and MonMetaStylesheet to generate
# XML

echo -n "`date +%H:%M` XMLtoMonkXML.xsl created ... " >> log/abbot_log

if java net.sf.saxon.Transform -w0 src/xsd/TEIAnalytics.xsd src/xslt/MonkMetaStylesheet.xsl > src/xslt/XMLtoMonkXML.xsl 2>> log/error_log
then
	echo -n "MonkMetaStylesheet created ... "
	echo " Success!"
else
	echo "Failure :(" >>log/abbot_log
	echo "There was a problem generating the MonkMetaStylesheet."
	echo "Please see log/error_log for details."
	exit
fi
