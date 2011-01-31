
# Make adjustments to XMLtoMonkXML.xsl

echo -n "`date +%H:%M` Adjusting XMLtoMonkXML.xsl ... " >> log/abbot_log

xsl=src/xslt/XMLtoMonkXML.xsl

if sed -i.bak -f src/sed/xslt_adjustments.sed $xsl 2>>log/error_log
then
	echo -n "Adjusting XMLtoMonkXML.xsl ... "
	echo "Success!"
else
	echo "Failure :(" >>log/abbot_log
	echo "There was a problem applying sed expressions to XMLtoMonkXML.xsl."
	echo "Please see log/error_log for details."
	exit
fi

