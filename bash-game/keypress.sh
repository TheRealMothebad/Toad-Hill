#!/bin/bash

domain=$( tput cols )
range=$( tput lines )

centx=$(( $domain / 2 ))
centy=$(( $range / 2 ))

posx="$centx"
posy="$centy"

mapx="0"
mapy="0"



objects=("002 012 a" "003 013 b")





function plant {
	clear && echo "planting [$posx, $posy] on map [$mapx, $mapy]"

	# add zeros before posx & posy, up to 3 digits
	xzpad=""
	n=0 ; while [ "$n" -lt $(( 3 - ${#posx} )) ]
	do
		xzpad+="0"
		n=$(( $n + 1 ))
	done
	plrx="$xzpad$posx"

	yzpad=""
	n=0 ; while [ "$n" -lt $(( 3 - ${#posy} )) ]
	do
		yzpad+="0"
		n=$(( $n + 1 ))
	done
	plry="$yzpad$posy"

	# add character to objects list

	tmpobj=("${objects[*]}")
	tmpobj+=("$plry $plrx #")

	# (i don't understand this next line but it sorts it)
	IFS=$'\n' tmpobj=($(sort <<<"${tmpobj[*]}"))
	unset IFS

	echo "${tmpobj[*]}"


	yacc="0"
	xacc="0"
	n=0 ; while [ "$n" -lt ${#tmpobj[@]} ]
	do
		m=0
		for i in ${tmpobj[$n]}
		do
			m=$(( $m + 1 ))
			if [ $m == "1" ] ; then
				objy=$i
			elif [ $m == "2" ] ; then
				objx=$i
			elif [ $m == "3" ] ; then
				obj=$i
			fi
		done

		# remove leading zeros
		objy=$( echo "$objy" | sed 's/^0*//' )
		objx=$( echo "$objx" | sed 's/^0*//' )

		if [ $objx -ge $domain ] || [ $objx -lt 0 ] || [ $objy -ge $(( $range - 1 )) ] || [ $objy -lt 0 ]
		then
			return
		else
			if [ $objy == $yacc ] && [ $objx == $xacc ]
			then
				echo -ne "\r"
				xgap=""
				m=0 ; while [ "$m" -lt $objx ]
				do
					m=$(( $m + 1 ))
					xgap+=" "
				done
				echo -ne "$xgap!\r$xgap"
			elif [ $objy == $yacc ] && ! [ $objx == $xacc ]
			then
				xtogo=$(( $objx - $xacc ))
				xacc="$objx"
				xgap=""
				m=0 ; while [ "$m" -lt $xtogo ]
				do
					m=$(( $m + 1 ))
					xgap+=" "
				done
				echo -ne "$xgap$obj\r$xgap"
			else
				ytogo=$(( $objy - $yacc ))

				m=0 ; while [ "$m" -lt $ytogo ]
				do
					m=$(( $m + 1 ))
					echo ""
				done

				xgap=""
				m=0 ; while [ "$m" -lt $objx ]
				do
					m=$(( $m + 1 ))
					xgap+=" "
				done
				echo -ne "$xgap$obj\r$xgap"

				xacc="$objx"
				yacc=$(( $yacc + $objy ))
			fi
		fi
		n=$(( $n + 1 ))
	done

	#remy=$(( $range - $posy - 1 ))
	# this is because of the "planting [x, y]" printout, it won't be there in the game unless there are stats or something

	#yrem=$(( $range - $yacc - 2 ))
	#n=0 ; while [ "$n" -lt $yrem ]
	#do
	#	n=$(( $n + 1 ))
	#	echo ""
	#done

	#n=0 ; while [ "$n" -lt $domain ]
	#do
	#	n=$(( $n + 1 ))
	#	echo -n " "
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
		echo "posx exceeds domain"
		mapx=$(( $mapx + 1 ))
		posx="0"
		navloop
	elif [ $posx -lt 0 ] ; then
		echo "posx less than 0"
		mapx=$(( $mapx - 1 ))
		posx=$(( $domain - 1 ))
		navloop
	elif [ $posy -ge $(( $range - 1 )) ] ; then
		echo "posy exceeds range"
		mapy=$(( $mapy + 1 ))
		posy="0"
		navloop
	elif [ $posy -lt 0 ] ; then
		echo "posy less than 0"
		mapy=$(( $mapy - 1 ))
		posy=$(( $range - 2 ))
		navloop
	fi
}

function main {
	navloop
}

main
