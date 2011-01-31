#!/bin/sh

# Undertake a parse check on converted files

echo -n "`date +%H:%M` Validating converted files ... " >> log/abbot_log
echo -n "Validating converted files ... "

for i in `ls output/*.xml`
do
	if  sed -i.bak -f src/sed/pre-parse.sed $i 2> log/error_log
	then
		echo "${i}: Success!" >> log/abbot_log
	else
		echo "Failure :(" >> log_abbot_log
		echo "There was a problem applying sed expressions to ${i}"
		echo "Please see log/error_log for details."
		exit
	fi

	if java -jar lib/msv.jar src/rng/TEIAnalytics.rng $i > log/`basename $i`.plog
	then
		echo "${i} Success!" >> log/abbot_log
	else
		echo "Failure :(" >> log/abbot_log
		echo "There was a problem parsing file `basename $i`. "
		echo "Please see log/error_log for details."
		echo " "
	fi
done;



