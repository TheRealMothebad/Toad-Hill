#!/bin/bash

map=""

function menu {
	clear && echo "

	Hello and welcome to Toad. it is.
	please enjoy it.


		[N] Start from the beginning
		[C] Continue a saved game
		[Q] Quit

"
	echo -n "	: "
	read meninpt
	if [ "$mininpt" == "N" ] || [ "$meninpt" == "n" ]
	then
		echo "selected start"
	elif [ "$mininpt" == "C" ] || [ "$meninpt" == "c" ]
	then
		echo "elected continue"
	elif [ "$mininpt" == "Q" ] || [ "$meninpt" == "q" ]
	then
		exit
	else
		echo "That was not a valid selection. Please try again."
		sleep 1
		menu
	fi
}

menu
echo "end"
