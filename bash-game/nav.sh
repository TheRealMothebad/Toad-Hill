#!/bin/bash

domain=$( tput cols )
range=$( tput lines )
# this is so i have room at the top for debug:
range=$(( $range - 1 ))

centx=$(( $domain / 2 ))
centy=$(( $range / 2 ))

posx="$centx"
posy="$centy"

mapx="0"
mapy="0"


fullobjects=("009 016 a" "011 019 b" "011 024 c" "010 018 #" "120 170 p" "017 57 q" "020 085 g" "020 086 o" "020 088 t" "020 089 h" "020 090 i" "020 091 s" "021 089 w" "021 090 a" "021 091 y" "021 092 ." "021 093 ." "021 094 .")


function centerprint_line {
	xpad=""
	n=0 ; while [ "$n" -lt $(( $centx - ${#1} / 2 )) ]
	do
		n=$(( n + 1 ))
		xpad+=" "
	done
	echo "$xpad$1"
}


function centerprint {
	maxw=$(( $domain / 2 ))
	line=($1)
	row=""
	for l in "${line[@]}"
	do
		testrow="$row $l"
		if [ "${#testrow}" -le $maxw ]
		then
			row="$testrow"
		else
			centerprint_line "$row"
			row="$l"
		fi
	done
	centerprint_line "$row"

}


function quit {
	clear
	n=0 ; while [ "$n" -lt $centy ]
	do
		n=$(( n + 1 ))
		echo ""
	done
	centerprint "goodbye"
	exit
}


function win {
	n=0 ; while [ "$n" -lt $centy ]
	do
		n=$(( n + 1 ))
		echo ""
	done
	centerprint "you won!"
	exit
}


function draw {
	echo "map [$mapx, $mapy] (showing [$minx, $miny] thru. [$maxx, $maxy]); pos @ [$posx, $posy]"
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
	objects=("${thismapobjects[@]}")
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
				objy="$i"
			elif [ $m == "2" ] ; then
				objx="$i"
			elif [ $m == "3" ] ; then
				obj="$i"
			fi
		done

		objy=$( echo "$objy" | sed 's/^0*//' )
		objx=$( echo "$objx" | sed 's/^0*//' )

		#echo "operating $obj at [$objx, $objy] while already [$xacc, $yacc]"

		n=$(( $n + 1 ))

		if [ "$objy" == "$yacc" ] && [ "$objx" == "$xacc" ]
		then
			echo -ne "\b!"
			if [ $obj == "@" ] && [ $prevobj == "#" ]
			then
				win
			elif [ $obj == "#" ] && [ $prevobj == "@" ]
			then
				win
			fi
		elif [ "$objy" == "$yacc" ] && ! [ "$objx" == "$xacc" ]
		then
			xunacc=$(( $objx - $xacc - 1 ))
			xspace=""
			m=0 ; while [ "$m" -lt $xunacc ]
			do
				m=$(( $m + 1 ))
				xspace+=" "
			done
			echo -n "$xspace"
			echo -n "$obj"
			xacc="$objx"
		else
			# got a syntax error here at one point donno: `operand expected (error token is "-  ")`
			yunacc=$(( $objy - $yacc ))
			m=0 ; while [ "$m" -lt $yunacc ]
			do
				m=$(( $m + 1 ))
				echo ""
			done
			xspace=""
			# this line throws an error, unary operator expected
			m=0 ; while [ "$m" -lt $objx ]
			do
				m=$(( $m + 1 ))
				xspace+=" "
			done
			echo -n "$xspace"
			echo -n "$obj"
			yacc="$objy"
			xacc="$objx"
		fi
		prevobj="$obj"
	done
	remy=$(( $range - $yacc - 1 ))
	n=0 ; while [ "$n" -lt $remy ]
	do
		n=$(( $n + 1 ))
		echo ""
	done
	#spacewidth=""	
	#n=0 ; while [ "$n" -lt $domain ]
	#do
	#	n=$(( $n + 1 ))
	#	spacewidth+=" "
	#done
	#echo -n "$spacewidth"
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
		quit
	fi
	clear
}


function parseobjects {
	minx=$(( $mapx * $domain ))
	maxx=$(( $minx + $domain ))
	miny=$(( $mapy * $range ))
	maxy=$(( $miny + $range ))
	#echo "map [$mapx, $mapy], meaning domain [$minx, $maxx] and range [$miny, $maxy]"
	thismapobjects=("")
	n=0 ; while [ "$n" -lt ${#fullobjects[@]} ]
	do
		m=0
		for i in ${fullobjects[$n]}
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
		echo "examining obj $obj @ [$objx, $objy]"
		if [ $objx -lt $maxx ] && [ $objx -ge $minx ] && [ $objy -lt $maxy ] && [ $objy -ge $miny ]
		then
			echo ". passed obj $obj"
			m=0 ; while [ "$m" -lt 1 ]
			do
				if [ "$objx" -ge "$domain" ]
				then
					objx=$(( $objx - $domain ))
				elif [ "$objx" -lt 0 ]
				then
					objx=$(( $objx + $domain ))
				elif [ "$objy" -ge "$range" ]
				then
					objy=$(( $objy - $range ))
				elif [ "$objy" -lt 0 ]
				then
					objy=$(( $objy + $range ))
				else
					m=1
				fi
			done
			echo ". recentered obj $obj @ [$objx, $objy]"
			objxzer=""
			m=0 ; while [ "$m" -lt $(( 3 - ${#objx} )) ]
			do
				m=$(( $m + 1 ))
				objxzer+="0"
			done
			objyzer=""
			m=0 ; while [ "$m" -lt $(( 3 - ${#objy} )) ]
			do
				m=$(( $m + 1 ))
				objyzer+="0"
			done
			objxpad="$objxzer$objx"
			objypad="$objyzer$objy"
			thismapobjects+=("$objypad $objxpad $obj")
		fi
		n=$(( $n + 1 ))
	done
	echo "objects in this map:"
	echo "${thismapobjects[*]}"
}


function navloop {
	parseobjects
	clear
	while [ $posx -lt $domain ] && [ $posx -ge 0 ] && [ $posy -lt $range ] && [ $posy -ge 0 ]
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
	elif [ $posy -ge $range ] ; then
		# posy exceeds range
		mapy=$(( $mapy + 1 ))
		posy="0"
		navloop
	elif [ $posy -lt 0 ] ; then
		# posy less than 0
		mapy=$(( $mapy - 1 ))
		posy=$(( $range - 1 ))
		navloop
	fi
}


function menu {
	y=0
	menuopts=("")
	menufuncs=("")
	menuno=0
	for i in "${@:2}"
	do
		if [[ $(( $y % 2 )) -eq 0 ]]
		then
			menuopts[$menuno]="$i"
			echo "menuopts $menuno is now $i"
		else
			menufuncs[$menuno]="$i"
			echo "menufuncs $menuno is now $i"
			menuno=$(( $menuno + 1 ))
		fi
		y=$(( $y + 1 ))
	done



	optscount=$(( ( ${#@} - 1 ) / 2 - 1 ))
	selected=0
	s=0 ; while [ "$s" -lt 1 ]
	do
		menuoptsmod=("${menuopts[@]}")
		menuoptsmod[$selected]="> ${menuoptsmod[$selected]} <"
		clear
		n=0 ; while [ "$n" -lt $centy ]
		do
			n=$(( n + 1 ))
			echo ""
		done
		centerprint "$1" && echo ""
		o=0 ; while [ "$o" -le $optscount ]
		do
			centerprint "${menuoptsmod[$o]}"
			o=$(( $o + 1 ))
		done

		read -s -n 1 key
		if [ $key == "w" ] || [ $key == "k" ]
		then
			if [ "$selected" -gt 0 ]
			then
				selected=$(( $selected - 1 ))
			fi
		elif [ $key == "s" ] || [ $key == "j" ]
		then
			if [ "$selected" -lt $optscount ]
			then
				selected=$(( $selected + 1 ))
			fi
		elif [ $key == "d" ] || [ $key == "l" ]
		then
			s=1
			echo "selected $selected"
			echo "which is (${menuoptsmod[$selected]})[${menufuncs[$selected]}]."
			eval ${menufuncs[$selected]}
		fi
	done
}


function main {
	menu "Welcome to Toad Hill! This game does not really exist yet, but here is something like a bash game engine." "Walk around" "navloop" "Quit" "quit"
}


main
