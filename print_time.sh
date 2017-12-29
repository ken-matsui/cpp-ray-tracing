ALL_SEC=$1

HOUR=$(($ALL_SEC / 3600))
MIN=$((($ALL_SEC - $HOUR * 3600) / 60))
SEC=$(($ALL_SEC - ($HOUR * 3600 + $MIN * 60)))

echo "It took ${HOUR}h ${MIN}m ${SEC}s."