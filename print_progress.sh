NOW_COUNT=$1
MAX_COUNT=$2

MAX_BAR_SIZE=50

PERCENT=$(( (NOW_COUNT*100)/MAX_COUNT ))
BAR_NUM=$(( PERCENT/2 ))

BAR=""
if [[ $(( BAR_NUM-1 )) -gt 0 ]]; then
	for i in `seq $(( BAR_NUM-1 ))`; do
		BAR="$BAR="
	done
	BAR="$BAR>"
	for i in `seq $(( MAX_BAR_SIZE-BAR_NUM ))`; do
		BAR="$BAR "
	done
elif [[ $BAR_NUM -eq 1 ]]; then
	BAR=">"
	for i in `seq $(( MAX_BAR_SIZE-1 ))`; do
		BAR="$BAR "
	done
else
	for i in `seq $MAX_BAR_SIZE`; do
		BAR="$BAR "
	done
fi

echo -en "${NOW_COUNT}/${MAX_COUNT} [${BAR}] - $PERCENT%\r"