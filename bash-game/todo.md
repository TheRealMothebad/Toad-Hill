# TO DO

. break into smaller functions
	. load map / doors
. save function
	- sed '/map=/d' and then write in `echo -n "map=("; for i in ${map[@]}; do echo -n "\"$i\" "; done; echo ")"`
