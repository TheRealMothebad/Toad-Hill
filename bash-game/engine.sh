#!/bin/bash

function save {
	printf "$( cat saves/$mapfile | sed '/posx/d' | sed '/map=/d' )\nmap=($( for i in "${map[@]}"; do printf "\"$i\" "; done ))\nposx=\"$prevposx\" && posy=\"$prevposy\"" > saves/$mapfile
	printf "$mapfile" > saves/main.save
}

function load {
	save
	eval $( cat maps/reset.map )
	mapfile="$1"
	if ! [ -f "saves/$mapfile" ]; then
		cp maps/$mapfile saves
	fi
	eval $( cat saves/$mapfile )
}

function quit {
	save
	printf "\n"
	exit
}

function win {
	save
	printf "\nyou won!\n"
	exit
}

function place {
	if [ -z "$1" ]; then
		map+=("$plry $plrx P")
	else
		map+=("$plry $plrx $1")
	fi
}

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

		if [ $objy -gt 0 ]; then
			objy=$( printf "$objy" | sed 's/^0*//' )
		fi
		if [ $objx -gt 0 ]; then
			objx=$( printf "$objx" | sed 's/^0*//' )
		fi

		if [ "$objy" == "$yacc" ] && [ "$objx" == "$xacc" ]; then
			# position of object to print matches last-printed object (overlap)
			printf "\b!"
			if [ $obj == "@" ] && [ $prevobj == "w" ]; then
				win
			elif [ $obj == "w" ] && [ $prevobj == "@" ]; then
				win
			elif [ $obj == "@" ] && [ $prevobj == "q" ]; then
				quit
			elif [ $obj == "q" ] && [ $prevobj == "@" ]; then
				quit
			elif [ $obj == "@" ] && [ $prevobj == "s" ]; then
				printf "you found a secret!"
			elif [ $obj == "s" ] && [ $prevobj == "@" ]; then
				printf "you found a secret!"
			fi
			for i in "${doors[@]}"; do
				b=($i)
				if [ $obj == "@" ] && [ $prevobj == "${b[0]}" ]; then
					load ${b[1]}
					main
				elif [ $obj == "${b[0]}" ] && [ $prevobj == "@" ]; then
					load ${b[1]}
					main
				fi
			done
		elif [ "$objy" == "$yacc" ] && ! [ "$objx" == "$xacc" ]; then
			# same row, different position
			xunacc=$(( $objx - $xacc - 1 ))
			xspace=""
			m=0 ; while [ "$m" -lt $xunacc ]; do
				m=$(( $m + 1 ))
				xspace+=" "
			done
			printf "$xspace$obj"
			xacc="$objx"
		else
			# different row, different position
			yunacc=$(( $objy - $yacc ))
			m=0 ; while [ $m -lt $yunacc ]; do
				m=$(( $m + 1 ))
				printf "\n"
			done
			xspace=""
			m=0 ; while [ $m -lt $objx ]; do
				m=$(( $m + 1 ))
				xspace+=" "
			done
			printf "$xspace"
			printf "$obj"
			yacc="$objy"
			xacc="$objx"
		fi
		prevobj="$obj"
	done
	remy=$(( $range - $yacc ))
	n=0 ; while [ "$n" -le $remy ]
	do
		n=$(( $n + 1 ))
		printf "\n"
	done
}

function nav {
	read -s -n 1 key
	prevposy=$posy
	prevposx=$posx
	if [ $key == "w" ] || [ $key == "k" ]; then
		if [ $posy -gt 0 ]; then
			posy=$(( $posy - 1 ))
		else
			if ! [ -z "$north" ]; then
				load $north
			fi
			posx=$prevposx
			if [ $posx -gt $domain ]; then
				posx=$domain
			fi
		fi
	elif [ $key == "a" ] || [ $key == "h" ]; then
		if [ $posx -gt 0 ]; then
			posx=$(( $posx - 1 ))
		else
			if ! [ -z "$west" ]; then
				load $west
			fi
			posy=$prevposy
			if [ $posy -gt $range ]; then
				posy=$range
			fi
		fi
	elif [ $key == "s" ] || [ $key == "j" ]; then
		if [ $posy -lt $range ]; then
			posy=$(( $posy + 1 ))
		else
			if ! [ -z "$south" ]; then
				load $south
			fi
			posx=$prevposx
			if [ $posx -gt $domain ]; then
				posx=$domain
			fi
		fi
	elif [ $key == "d" ] || [ $key == "l" ]; then
		if [ $posx -lt $domain ]; then
			posx=$(( $posx + 1 ))
		else
			if ! [ -z "$east" ]; then
				load $east
			fi
			posy=$prevposy
			if [ $posy -gt $range ]; then
				posy=$range
			fi
		fi
	elif [ $key == "p" ]; then
		place
	elif [ $key == ":" ]; then
		printf "\n"
		printf ":" && read cmd
		eval "$cmd"
	elif [ $key == "q" ]; then
		quit
	fi
}

function main {
	prevposx="$posx"
	prevposy="$posy"
	while true; do
		time draw
		printf "$mapfile ($posx, $posy)"
		nav
	done
}

if ! [ -d saves ]; then
	mkdir saves
	cp maps/start.map saves
	printf "start.map" > saves/main.save
fi
mapfile=$( cat saves/main.save )
eval $( cat saves/$mapfile )
main
