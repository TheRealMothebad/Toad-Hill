#!/bin/bash

initobjects=("009 016 a" "011 019 b" "011 024 c")

domain=$( tput cols )
range=$( tput lines )

centx=$(( $domain / 2 ))
centy=$(( $range / 2 ))

posx="17"
posy="10"

mapx="0"
mapy="0"


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
	objects+=("$plry $plrx P")
	IFS=$'\n' objects=($(sort <<<"${objects[*]}"))
	unset IFS


	yacc="0"
	xacc="0"
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
				echo -n "!"
			elif [ $objy == $yacc ] && ! [ $objx == $xacc ]
			then
				xunacc=$(( $objx - $xacc ))
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
	done
}

draw
