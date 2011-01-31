
# Make adjustments to converted files

echo -n "`date +%H:%M` Adjusting converted file . . ." >> log/abbot_log
echo -n "Adjusting converted files ... "

for i in `ls output/*.xml`
do
	if sed -i.bak -f src/sed/xml_adjustments.sed $i 2> log/error_log
	then
		echo "$i . . . Success!" >> log/abbot_log
	else
		echo "Failure :(" >> log/abbot_log
		echo "There was a problem applying sed expressions to ${i}"
		echo "Please see log/error_log for details."
		exit
	fi
done

echo "done"
