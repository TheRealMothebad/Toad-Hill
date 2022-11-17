#!/bin/bash

domain=$( tput cols )
range=$( tput lines )

centx=$(( $domain / 2 ))
centy=$(( $range / 2 ))

posx="$centx"
posy="$centy"

mapx="0"
mapy="0"


initobjects=("009 016 a" "011 019 b" "011 024 c" "010 018 #")


function win {
	clear
	n=0 ; while [ "$n" -lt $centy ]
	do
		n=$(( n + 1 ))
		echo ""
	done
	xpad=""
	n=0 ; while [ "$n" -lt $centx ]
	do
		n=$(( n + 1 ))
		xpad+=" "
	done
	echo -n "$xpad"
	echo "you won!"
	exit
}


function draw {
	plrzerx=""
	n=0 ; while [ "$n" -lt $(( 3 - ${#posx} )) ]
	do
		n=$(( $n + 1 ))
		plrzerx+="0"
	done
	plrzery=""
	n=0 ; while [ "$n" -lt $(( 3 - ${#posy} )) ]
	do
		n=$(( $n + 1 ))
		plrzery+="0"
	done
	plrx="$plrzerx$posx"
	plry="$plrzery$posy"
	objects=("${initobjects[@]}")
	objects+=("$plry $plrx @")
	IFS=$'\n' objects=($(sort <<<"${objects[*]}"))
	unset IFS


	yacc="0"
	xacc="0"
	prevobj=""
	n=0 ; while [ "$n" -lt ${#objects[@]} ]
	do
		m=0
		for i in ${objects[$n]}
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

		objy=$( echo "$objy" | sed 's/^0*//' )
		objx=$( echo "$objx" | sed 's/^0*//' )

		#echo "operating $obj at [$objx, $objy] while already [$xacc, $yacc]"

		n=$(( $n + 1 ))

		if [ $objx -ge $domain ] || [ $objx -lt 0 ] || [ $objy -ge $(( $range - 1 )) ] || [ $objy -lt 0 ]
		then
			echo "$obj exceeded bounds"
		else
			if [ $objy == $yacc ] && [ $objx == $xacc ]
			then
				echo -ne "\b!"
				if [ $obj == "@" ] && [ $prevobj == "#" ]
				then
					win
				elif [ $obj == "#" ] && [ $prevobj == "@" ]
				then
					win
				fi
			elif [ $objy == $yacc ] && ! [ $objx == $xacc ]
			then
				xunacc=$(( $objx - $xacc - 1 ))
				xspace=""
				m=0 ; while [ "$m" -lt $xunacc ]
				do
					m=$(( $m + 1 ))
					xspace+=" "
				done
				echo -n "$xspace$obj"
				xacc="$objx"
			else
				yunacc=$(( $objy - $yacc ))
				m=0 ; while [ "$m" -lt $yunacc ]
				do
					m=$(( $m + 1 ))
					echo ""
				done
				xspace=""
				m=0 ; while [ "$m" -lt $objx ]
				do
					m=$(( $m + 1 ))
					xspace+=" "
				done
				echo -n "$xspace$obj"
				yacc="$objy"
				xacc="$objx"
			fi
		fi
		prevobj="$obj"
	done
	remy=$(( $range - $yacc - 1 ))
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
		clear && echo "quitting" && exit
	fi
	clear
}


function navloop {
	#while [ $posx -lt $domain ] && [ $posy -lt $range ]
	# this is because of the "planting [x, y]" printout, it won't be there in the game unless there are stats or something
	clear
	while [ $posx -lt $domain ] && [ $posx -ge 0 ] && [ $posy -lt $(( $range - 1 )) ] && [ $posy -ge 0 ]
	do
		draw
		nav
	done
	if [ $posx -ge $domain ] ; then
		# posx exceeds domain
		mapx=$(( $mapx + 1 ))
		posx="0"
		navloop
	elif [ $posx -lt 0 ] ; then
		# posx less than 0
		mapx=$(( $mapx - 1 ))
		posx=$(( $domain - 1 ))
		navloop
	elif [ $posy -ge $(( $range - 1 )) ] ; then
		# posy exceeds range
		mapy=$(( $mapy + 1 ))
		posy="0"
		navloop
	elif [ $posy -lt 0 ] ; then
		# posy less than 0
		mapy=$(( $mapy - 1 ))
		posy=$(( $range - 2 ))
		navloop
	fi
}


function main {
	navloop
}


main
