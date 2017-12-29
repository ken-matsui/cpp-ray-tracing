#!/bin/bash

set -eu
: $1

TOTAL_WIDTH=512
TOTAL_HEIGHT=512
TILE_WIDTH=8
TILE_HEIGHT=8

COUNT_MAX=$((($TOTAL_WIDTH / $TILE_WIDTH) * ($TOTAL_HEIGHT / $TILE_HEIGHT)))

TMP_DIR=$(mktemp -d)
mkdir -p $TMP_DIR
trap "rm -r $TMP_DIR" 0

source print_progress.sh 0 $COUNT_MAX
for ((y=0; y<TOTAL_HEIGHT; y+=TILE_HEIGHT)); do
	for ((x=0; x<TOTAL_WIDTH; x+=TILE_WIDTH)); do
		mkdir -p $TMP_DIR/$y/
		binname=$x.$y.out
		set +e
		g++ $1 -o $TMP_DIR/$binname -std=gnu++0x \
			-DDARKROOM_TOTAL_WIDTH=$TOTAL_WIDTH \
			-DDARKROOM_TOTAL_HEIGHT=$TOTAL_HEIGHT \
			-DDARKROOM_TILE_WIDTH=$TILE_WIDTH \
			-DDARKROOM_TILE_HEIGHT=$TILE_HEIGHT \
			-DDARKROOM_OFFSET_X=$x \
			-DDARKROOM_OFFSET_Y=$y
		set -e
		$TMP_DIR/$binname > $TMP_DIR/$y/$x.ppm
		rm $TMP_DIR/$binname
		source print_progress.sh $(( (x+TILE_WIDTH)/TILE_WIDTH + (y/TILE_HEIGHT)*(TOTAL_WIDTH/TILE_WIDTH) )) $COUNT_MAX
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

echo "done."
source print_time.sh $SECONDS
