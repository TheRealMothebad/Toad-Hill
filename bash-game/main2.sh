#!/bin/bash

function draw {
	clear

	plrzerx=""
	n=0 ; while [ "$n" -lt $(( 2 - ${#posx} )) ]
	do
		n=$(( $n + 1 ))
		plrzerx+="0"
	done
	plrzery=""
	n=0 ; while [ "$n" -lt $(( 2 - ${#posy} )) ]
	do
		n=$(( $n + 1 ))
		plrzery+="0"
	done
	plrx="$plrzerx$posx"
	plry="$plrzery$posy"

	objects=("${map[@]}")
	objects+=("$plry $plrx @")
	IFS=$'\n' objects=($(sort <<<"${objects[*]}"))
	unset IFS

	yacc="0"
	xacc="0"
	prevobj=""
	for item in "${objects[@]}"; do
		item=($item)
		objy=${item[0]}
		objx=${item[1]}
		obj=${item[2]}

		objy=$( echo "$objy" | sed 's/^0*//' )
		objx=$( echo "$objx" | sed 's/^0*//' )

		if [ "$objy" == "$yacc" ] && [ "$objx" == "$xacc" ]; then
			# position of object to print matches last-printed object (overlap)
			echo -ne "\b!"
			if [ $obj == "@" ] && [ $prevobj == "w" ]; then
				win
			elif [ $obj == "w" ] && [ $prevobj == "@" ]; then
				win
			elif [ $obj == "@" ] && [ $prevobj == "q" ]; then
				exit
			elif [ $obj == "q" ] && [ $prevobj == "@" ]; then
				exit
			elif [ $obj == "@" ] && [ $prevobj == "s" ]; then
				echo -n "you found a secret!"
			elif [ $obj == "s" ] && [ $prevobj == "@" ]; then
				echo -n "you found a secret!"
			fi
#			for i in "${doors[@]}"; do
#				b=($i)
#				if [ $obj == "@" ] && [ $prevobj == "${b[0]}" ]; then
#					echo -n "door ${b[1]}..."
#				elif [ $obj == "${b[0]}" ] && [ $prevobj == "@" ]; then
#					echo -n "door ${b[1]}..."
#				fi
#			done
		elif [ "$objy" == "$yacc" ] && ! [ "$objx" == "$xacc" ]; then
			# same row, different position
			xunacc=$(( $objx - $xacc - 1 ))
			xspace=""
			m=0 ; while [ "$m" -lt $xunacc ]; do
				m=$(( $m + 1 ))
				xspace+=" "
			done
			echo -n "$xspace$obj"
			xacc="$objx"
		else
			# different row, different position
			yunacc=$(( $objy - $yacc ))
			m=0 ; while [ $m -lt $yunacc ]; do
				m=$(( $m + 1 ))
				echo ""
			done
			xspace=""
			m=0 ; while [ $m -lt $objx ]; do
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
}

function nav {
	read -s -n 1 key
	if [ $key == "w" ] || [ $key == "k" ]; then
		if [ $posy -gt 0 ]; then
			posy=$(( $posy - 1 ))
		fi
	elif [ $key == "a" ] || [ $key == "h" ]; then
		if [ $posx -gt 0 ]; then
			posx=$(( $posx - 1 ))
		fi
	elif [ $key == "s" ] || [ $key == "j" ]; then
		if [ $posy -lt $range ]; then
			posy=$(( $posy + 1 ))
		fi
	elif [ $key == "d" ] || [ $key == "l" ]; then
		if [ $posx -lt $domain ]; then
			posx=$(( $posx + 1 ))
		fi
	elif [ $key == ":" ]; then
		echo -n ": " && read
	elif [ $key == "q" ]; then
		exit
	fi
}

function main {
	while true; do
		draw
		nav
	done
}

eval $( cat maps/start.map )
main
