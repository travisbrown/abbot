#!/bin/sh

### Abbot.sh #############################################################
# 
# Written and Maintained by Brian Pytlik-Zillig and Stephen Ramsay
# for The MONK Project <htttp://www.monkproject.org>
#
# Copyright © 2007-2009.  Please see LICENSE for details.
# 
##########################################################################

### Cleanup/Housekeeping Routines ###

if [ -e log/abbot_log ]
then
	rm log/abbot_log
fi

if [ -e log/error_log ]
then
	rm log/error_log
fi

rm -f output/*
rm -f log/*.plog

if [[ $1 && -d $1 ]]
then
	export target_dir=$1
else
	echo "Usage: abbot.sh [target_dir]"
	exit
fi

if [ -d ${target_dir} ]
then
	rm -rf ${target_dir}/fixedHyphensTemp
fi

export CLASSPATH=lib/saxon9.jar:lib/msv.jar:lib/isorelax.jar:relaxngDatatype.jar:lib/xsdlib.jar

### Main ###

echo "Conversion initiated on `date`" > log/abbot_log
echo

echo -n "`date +%H:%M`"

src/sh/title.sh
src/sh/001generateXMLtoMonkXMLstylesheet.sh
src/sh/002editTheXMLtoMonkXMLstylesheet.sh
src/sh/003convertTargetToMonk.sh
src/sh/004fixEndOfPageHyphenation.sh
src/sh/005fixFloatingText.sh
src/sh/006MoveProblemNodesAfterParentNode.sh
src/sh/007checkHierarchyProblems.sh
src/sh/008removeStrayNamespaces.sh
src/sh/009parseToValidateTheConvertedFiles.sh
src/sh/010fixSuperscripts.sh
src/sh/011moveInvalidFilesToQuarantineFolder.sh
src/sh/012createTabDelimitedTeiHeaderReport.sh


rm output/*.bak
rm quarantined/*.bak
echo "The application has completed. "
#echo " "
#echo " "
