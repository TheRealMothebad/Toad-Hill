#!/bin/bash

posx=$(( $( tput cols ) / 2 ))
posy=$(( $( tput lines) / 2 ))


echo -n "cols: "
tput cols
echo -n "lines: "
tput lines
echo "q	quit
w	up
a	left
s	down
d	right
"


function plant {
	clear && echo "planting [$posx, $posy]"
	n=0
	while [ "$n" -lt $posy ]
	do
		n=$(( $n + 1 ))
		echo ""
	done
	n=0
	while [ "$n" -lt $posx ]
	do
		n=$(( $n + 1 ))
		echo -n " "
	done
}


function nav {
	while [ true ]
	do
		plant
		read -s -n 1 key
		if [ $key == "w" ]
		then
			posy=$(( $posy - 1 ))
		elif [ $key == "a" ]
		then
			posx=$(( $posx - 1 ))
		elif [ $key == "s" ]
		then
			posy=$(( $posy + 1 ))
		elif [ $key == "d" ]
		then
			posx=$(( $posx + 1 ))
		elif [ $key == "q" ]
		then
			exit
		fi
	done
}

nav
