TOOL="/usr/local/stage/thisfish/tools/pythontidy.py"
USAGE="Usage: $0 [directory]\nRuns .py files in [dir] through $TOOL while preserving shebang lines"
TMP=".py.tmp"

if [ -z "$1" ]; then
	echo -e $USAGE
	exit 1
fi

find $1 -name "*.py" | while read FILE; do
	if [ "`basename $FILE`" == "`basename $TOOL`" ]; then
		continue
	fi

	echo -n "Processing $FILE ... " &&
	$TOOL $FILE > $TMP &&
	grep -q '#!' $FILE &&
	if [ $? -eq 0 ]; then
		echo -n "preserving shebang ... " &&
		SHEBANG=`head -n1 $FILE` &&
		sed -i "1i$SHEBANG" $TMP
	fi
	mv $TMP $FILE &&
	echo "OK"
done
