#!/bin/bash

GNL='../get_next_line/'

RED='\e[31m'
GREEN='\e[32m'
NC='\e[39m' # No Colo
ERROR=0
echo -n "" > DEEPTHOUGHT

if [ $# -eq 0 ]
  then
	MAX=20
    echo "20 tests per BUFFER_SIZE"
else
	MAX=$1
fi
for (( i=1; i<=1000000; i = i < 3 ? i + 1 : i * i / 2))
do
	echo "BUFFER_SIZE : [$i]"
	gcc -Wall -Wextra -Werror main.c ${GNL}get_next_line.c ${GNL}get_next_line_utils.c -I${GNL} -D BUFFER_SIZE=$i
	for (( j=1; j <= $MAX; j++))
	do
		NUMBER=$[( $RANDOM % 50000 * 10 )]
		touch sample
		# echo "$NUMBER caractere(s)"
		head -c $NUMBER /dev/urandom | tr -dc '[:print:] \n' > sample
		RESULT=$(valgrind -q --leak-check=full ./a.out)
		if [[ $RESULT == "OK" ]]; then
			echo -e -n "${GREEN}OK${NC} "
		else
			echo -e "KO with BUFFER_SIZE=[$i] and generated text len of $NUMBER\n\n" >> DEEPTHOUGHT
			echo -e "GENERATED TEXT :" >> DEEPTHOUGHT
			echo -e "--------------------------------------" >> DEEPTHOUGHT
			cat sample >> DEEPTHOUGHT
			echo -e "\n--------------------------------------\n" >> DEEPTHOUGHT
			echo -e "$RESULT" >> DEEPTHOUGHT
			echo -e "\n======================================" >> DEEPTHOUGHT
			echo -e -n "${RED}KO${NC} "
			ERROR=$((ERROR + 1))
		fi
	done
	echo
done
if [ $ERROR -gt 0 ]; then
	echo -e "\nIl y a $ERROR erreur(s), retrouve le detail dans DEEPTHOUGHT\n"
else
	echo -e "\nC'est parfait bravo !"
fi
