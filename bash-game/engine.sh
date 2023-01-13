#!/bin/bash

if [ -z "$1" ]; then
	echo -n "map file: "
	read mapfile
else
	mapfile=$1
fi
eval $( cat $mapfile )


echo "MAPFILE: $mapfile"
echo "MAP:"
for i in "${map[@]}"; do
	b=($i)
	echo "${b[2]} (${b[1]}, ${b[0]})"
done
echo "POSX: $posx; POSY: $posy"
echo "DOORS:"
for i in "${doors[@]}"; do
	b=($i)
	echo "${b[0]}: ${b[1]}"
done
