#!/bin/bash

domain=$( tput cols )
range=$( tput lines )

posx=$(( $domain / 2 ))
posy=$(( $range / 2 ))


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
	n=0 ; while [ "$n" -lt $posy ]
	do
		n=$(( $n + 1 ))
		echo ""
	done
	n=0 ; while [ "$n" -lt $posx ]
	do
		n=$(( $n + 1 ))
		echo -n " "
	done
	echo -n "#"
	#remy=$(( $range - $posy - 1 ))
	# this is because of the "planting [x, y]" printout, it won't be there in the game unless there are stats or something
	remy=$(( $range - $posy - 2 ))
	n=0 ; while [ "$n" -lt $remy ]
	do
		n=$(( $n + 1 ))
		echo ""
	done
	n=0 ; while [ "$n" -lt $domain ]
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
		if [ $key == "w" ] || [ $key == "k" ]
		then
			posy=$(( $posy - 1 ))
		elif [ $key == "a" ] || [ $key == "h" ]
		then
			posx=$(( $posx - 1 ))
		elif [ $key == "s" ] || [ $key == "j" ]
		then
			posy=$(( $posy + 1 ))
		elif [ $key == "d" ] || [ $key == "l" ]
		then
			posx=$(( $posx + 1 ))
		elif [ $key == "q" ]
		then
			exit
		fi
	done
}

nav
