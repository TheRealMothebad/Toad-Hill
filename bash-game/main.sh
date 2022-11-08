#!/bin/bash

map=""

function menu {
	map=$( cat maps/menu.txt )
	clear && echo -n "$map"
}

menu
