#!/bin/bash

function save {
	printf "$( cat saves/$mapfile | sed '/posx/d' | sed '/map=/d' )\nmap=($( for i in "${map[@]}"; do printf "\"$i\" "; done ))\nposx=\"$prevposx\" && posy=\"$prevposy\"" > saves/$mapfile
	printf "mapfile=\"$mapfile\"\ninventory=($( for i in "${inventory[@]}"; do printf "\"$i\" "; done ))" > saves/main.save
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

function inventory {
	if [ ${#inventory[@]} -gt 0 ]; then
		printf "\nInventory (${#inventory[@]}):\n"
		n=0; while [ $n -lt ${#inventory[@]} ]; do
			echo "$n. ${inventory[$n]}"
			n=$(( $n + 1 ))
		done
		printf "use item (enter number, leave empty to close): "
		read use
		if ! [ -z "$use" ]; then
			if [[ $use =~ ^[0-9]+$ ]]; then
				if [ $use -lt ${#inventory[@]} ]; then
					map+=("$plry $plrx ${inventory[$(( $use ))]}")
					inventory=("${inventory[@]:0:$use}" "${inventory[@]:$(( $use + 1 ))}")
				else
					printf "That item does not exist!\n" && sleep 0.5
				fi
			else
				printf "Invalid entry!\n" && sleep 0.5
			fi
		fi
	else
		printf "\nInventory is empty!\n" && sleep 0.5
	fi
}

function npcs {
	npcbuffer=()
	for i in "${npcs[@]}"; do
		i=($i)
		npcy="${i[0]}"
		npcx="${i[1]}"
		npc="${i[2]}"

		if [ $npcy -gt 0 ]; then
			npcy=$( printf "$npcy" | sed 's/^0*//' )
		fi
		if [ $npcx -gt 0 ]; then
			npcx=$( printf "$npcx" | sed 's/^0*//' )
		fi

		if [ $npcx -lt $plrx ]; then
			npcx=$(( $npcx + 1 ))
		elif [ $npcx -gt $plrx ]; then
			npcx=$(( $npcx - 1 ))
		fi
		if [ $npcy -lt $plry ]; then
			npcy=$(( $npcy + 1 ))
		elif [ $npcy -gt $plry ]; then
			npcy=$(( $npcy - 1 ))
		fi

		npczerx=""
		n=0 ; while [ "$n" -lt $(( 2 - ${#npcx} )) ]
		do
			n=$(( $n + 1 ))
			npczerx+="0"
		done
		npczery=""
		n=0 ; while [ "$n" -lt $(( 2 - ${#npcy} )) ]
		do
			n=$(( $n + 1 ))
			npczery+="0"
		done

		npcx="$npczerx$npcx"
		npcy="$npczery$npcy"

		npcbuffer+=("$npcy $npcx $npc")
	done
	npcs=()
	for i in "${npcbuffer[@]}"; do
		npcs+=("$i")
	done
}

function draw {
	clear

	pad=true

	plrzerx=""
	n=0 ; while [ "$n" -lt $(( 2 - ${#posx} )) ]; do
		n=$(( $n + 1 ))
		plrzerx+="0"
	done
	plrzery=""
	n=0 ; while [ "$n" -lt $(( 2 - ${#posy} )) ]; do
		n=$(( $n + 1 ))
		plrzery+="0"
	done
	plrx="$plrzerx$posx"
	plry="$plrzery$posy"

	objects=("${map[@]}" "$plry $plrx @" "${npcs[@]}")
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

		if [ $objy -gt 0 ]; then objy=$( printf "$objy" | sed 's/^0*//' ); fi
		if [ $objx -gt 0 ]; then objx=$( printf "$objx" | sed 's/^0*//' ); fi

		if [ "$objy" == "$yacc" ] && [ "$objx" == "$xacc" ]; then
			# position of object to print matches last-printed object (overlap)
			printf "\b!"
			case ${obj}+${prevobj} in
				x+i | i+x)
					win ;;
				q+@ | @+q)
					quit ;;
				s+@ | @+s)
					printf "you found a secret!" ;;
				\#+@ | @+\#)
					posx=$prevposx && posy=$prevposy
					draw
					pad=false && break ;;
			esac
			for i in "${doors[@]}"; do
				b=($i); doortile=${b[0]}; doormap=${b[1]}
				case ${obj}+${prevobj} in
					@+$doortile | $doortile+@)
						load $doormap && main ;;
				esac
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
	if [ $pad == true ]; then
		remy=$(( $range - $yacc ))
		n=0 ; while [ "$n" -le $remy ]
		do
			n=$(( $n + 1 ))
			printf "\n"
		done
	fi
}

function nav {
	prevposy=$posy
	prevposx=$posx
	read -s -n 1 key
	case $key in
		w | k) # UP
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
			fi ;;
		a | h) # LEFT
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
			fi ;;
		s | j) # DOWN
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
			fi ;;
		d | l) # RIGHT
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
			fi ;;
		p) # PLACE
			place ;;
		g) # GRAB
			standingon=$( for i in "${map[@]}"; do printf "$i" | grep "$plry $plrx"; done )
			if ! [ -z "$standingon" ]; then
				if [ ${#inventory[@]} -le 9 ]; then
					map=("${map[@]/$standingon}")
					standingon=($standingon)
					inventory+=("${standingon[2]}")
				else
					printf "\nInventory is full!\n" && sleep 0.5
				fi
			fi ;;
		i) # INVENTORY
			inventory ;;
		:) # COMMAND
			printf "\n:" && read cmd
			eval "$cmd" ;;
		q) # QUIT
			quit ;;
	esac
}

function main {
	prevposx="$posx"
	prevposy="$posy"
	while true; do
		draw && printf "$mapfile ($posx, $posy) -- $desc"
		nav
		npcs
	done
}

if ! [ -d saves ]; then
	mkdir saves
	cp maps/start.map saves
	printf "mapfile=\"start.map\"\ninventory=()" > saves/main.save
fi
eval $( cat saves/main.save )
eval $( cat saves/$mapfile )
main
