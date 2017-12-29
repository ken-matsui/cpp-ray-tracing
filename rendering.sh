#!/bin/bash

TOTAL_WIDTH=512
TOTAL_HEIGHT=512
TILE_WIDTH=8
TILE_HEIGHT=8

print_progress_bar () {
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
}

calc_time () {
	HOUR=$(($SECONDS / 3600))
	MIN=$((($SECONDS - $HOUR * 3600) / 60))
	SEC=$(($SECONDS - ($HOUR * 3600 + $MIN * 60)))
	echo "It took ${HOUR}h ${MIN}m ${SEC}s."
}

main () {
	TMP_DIR=tmp
	mkdir -p $TMP_DIR
	MAX=$((($TOTAL_WIDTH / $TILE_WIDTH) * ($TOTAL_HEIGHT / $TILE_HEIGHT)))
	print_progress_bar 0 $MAX
	for ((y=0; y<TOTAL_HEIGHT; y+=TILE_HEIGHT)); do
		for ((x=0; x<TOTAL_WIDTH; x+=TILE_WIDTH)); do
			mkdir -p $TMP_DIR/$y/
			binname=$x.$y.out
			g++ $1 -o $binname -std=gnu++0x \
				-DDARKROOM_TOTAL_WIDTH=$TOTAL_WIDTH \
				-DDARKROOM_TOTAL_HEIGHT=$TOTAL_HEIGHT \
				-DDARKROOM_TILE_WIDTH=$TILE_WIDTH \
				-DDARKROOM_TILE_HEIGHT=$TILE_HEIGHT \
				-DDARKROOM_OFFSET_X=$x \
				-DDARKROOM_OFFSET_Y=$y
			./$binname > $TMP_DIR/$y/$x.ppm
			rm $binname
			# Call print_progress_bar function.
			print_progress_bar $(( (x+TILE_WIDTH)/TILE_WIDTH + (y/TILE_HEIGHT)*(TOTAL_WIDTH/TILE_WIDTH) )) $MAX
		done
		pushd $TMP_DIR/$y/ > /dev/null
		# InImage1 <- InImage2 <- InImage3 <- ... => OutImage
		convert +append $(ls *.ppm | sort -n) ../$y.ppm
		popd > /dev/null
		rm -r $TMP_DIR/$y/
	done

	echo -en "\n"
	pushd $TMP_DIR > /dev/null
	# InImage1 ↑ InImage2 ↑ InImage3 ↑ ... => OutImage
	convert -append $(ls *.ppm | sort -n) ../$(basename $1 .cpp).ppm
	popd > /dev/null
	rm -r $TMP_DIR
}

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 sample.cpp" 1>&2
	exit 1
else
	# Call main function.
	main $1
	echo "done."
	calc_time
fi
