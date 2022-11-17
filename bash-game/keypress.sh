#!/bin/bash

domain=$( tput cols )
range=$( tput lines )

centx=$(( $domain / 2 ))
centy=$(( $range / 2 ))

posx="$centx"
posy="$centy"

mapx="0"
mapy="0"




function plant {
	clear && echo "planting [$posx, $posy] on map [$mapx, $mapy]"
	n=0 ; while [ "$n" -lt $posy ]
	do
		n=$(( $n + 1 ))
		echo ""
	done
	xgap=""
	n=0 ; while [ "$n" -lt $posx ]
	do
		n=$(( $n + 1 ))
		xgap+=" "
	done
	#echo -n "$xgap"
	#echo -n "🐀"
	echo -n "$xgap🐀" && echo -ne "\r$xgap"
	#remy=$(( $range - $posy - 1 ))
	# this is because of the "planting [x, y]" printout, it won't be there in the game unless there are stats or something
	#remy=$(( $range - $posy - 2 ))
	#n=0 ; while [ "$n" -lt $remy ]
	#do
		#n=$(( $n + 1 ))
		#echo ""
	#done
	#n=0 ; while [ "$n" -lt $domain ]
	#do
		#n=$(( $n + 1 ))
		#echo -n " "
	#done
}


function nav {
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
}

function navloop {
	#while [ $posx -lt $domain ] && [ $posy -lt $range ]
	# this is because of the "planting [x, y]" printout, it won't be there in the game unless there are stats or something
	while [ $posx -lt $domain ] && [ $posx -ge 0 ] && [ $posy -lt $(( $range - 1 )) ] && [ $posy -ge 0 ]
	do
		plant
		nav
	done
	if [ $posx -ge $domain ] ; then
		#echo "posx exceeds domain"
		mapx=$(( $mapx + 1 ))
		posx="0"
		navloop
	elif [ $posx -lt 0 ] ; then
		#echo "posx less than 0"
		mapx=$(( $mapx - 1 ))
		posx=$(( $domain - 1 ))
		navloop
	elif [ $posy -ge $(( $range - 1 )) ] ; then
		#echo "posy exceeds range"
		mapy=$(( $mapy + 1 ))
		posy="0"
		navloop
	elif [ $posy -lt 0 ] ; then
		#echo "posy less than 0"
		mapy=$(( $mapy - 1 ))
		posy=$(( $range - 2 ))
		navloop
	fi
}

function main {
	navloop
}

main
