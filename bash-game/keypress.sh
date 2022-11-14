#!/bin/bash


function nav {
	while [ true ]
	do
		read -s -n 1 key
		echo ":: $key ::"
		if [ $key == "q" ]
		then
			exit
		fi
	done
}

nav
