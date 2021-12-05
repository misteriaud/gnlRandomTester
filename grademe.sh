#!/bin/bash

GNL='../get_next_line/'

RED='\e[31m'
GREEN='\e[32m'
NC='\e[39m' # No Colo
ERROR=0

if [ -d "temp" ];then
	rm -r temp
fi
mkdir temp

cd temp

if [ $# -eq 0 ]
  then
	MAX=20
	echo "20 tests per BUFFER_SIZE (you can defne a custom number of test by adding a number after \"./grademe\")"
else
	MAX=$1
fi
for (( i=1; i<=1000000; i = i < 3 ? i + 1 : i * i / 2))
do
	echo "BUFFER_SIZE : [$i]"
	gcc -Wall -Wextra -Werror ../srcs/main.c ../${GNL}get_next_line.c ../${GNL}get_next_line_utils.c -g -I../${GNL} -D BUFFER_SIZE=$i -o bin
	for (( j=1; j <= $MAX; j++))
	do
		NUMBER=$[( $RANDOM % 50000 * 10 )]
		head -c $NUMBER /dev/urandom | tr -dc '[:print:] \n' > sample
		RESULT=$(valgrind -q --show-leak-kinds=all --leak-check=yes ./bin)
		if [[ $RESULT == "OK" ]]; then
			echo -e -n "${GREEN}OK${NC} "
		else
			echo -e "KO with BUFFER_SIZE=[$i] and generated text len of $NUMBER\n\n" >> ../DEEPTHOUGHT
			echo -e "GENERATED TEXT :" >> ../DEEPTHOUGHT
			echo -e "--------------------------------------" >> ../DEEPTHOUGHT
			cat sample >> ../DEEPTHOUGHT
			echo -e "\n--------------------------------------\n" >> ../DEEPTHOUGHT
			echo -e "$RESULT" >> ../DEEPTHOUGHT
			echo -e "\n======================================" >> ../DEEPTHOUGHT
			echo -e -n "${RED}KO${NC} "
			ERROR=$((ERROR + 1))
		fi
	done
	echo
done


if [ -f ../${GNL}get_next_line_bonus.c -a -f ../${GNL}get_next_line_bonus.h -a -f ../${GNL}get_next_line_utils_bonus.c ]; then
	echo -e "\n\nTESTS SUR LES BONUS :"
	for (( i=1; i<=1000000; i = i < 3 ? i + 1 : i * i / 2))
	do
		echo "BUFFER_SIZE : [$i]"
		gcc -Wall -Wextra -Werror ../srcs/main_bonus.c ../${GNL}get_next_line_bonus.c ../${GNL}get_next_line_utils_bonus.c -g -I../${GNL} -D BUFFER_SIZE=$i -o bin_bonus
		for (( j=1; j <= $MAX; j++))
		do
			NUMBER0=$[( $RANDOM % 50000 * 10 )]
			NUMBER1=$[( $RANDOM % 50000 * 10 )]
			NUMBER2=$[( $RANDOM % 50000 * 10 )]
			head -c $NUMBER0 /dev/urandom | tr -dc '[:print:] \n' > sample_bonus0
			head -c $NUMBER1 /dev/urandom | tr -dc '[:print:] \n' > sample_bonus1
			head -c $NUMBER2 /dev/urandom | tr -dc '[:print:] \n' > sample_bonus2
			RESULT=$(valgrind -q --show-leak-kinds=definite,possible --leak-check=yes ./bin_bonus)
			if [[ $RESULT == "OK" ]]; then
				echo -e -n "${GREEN}OK${NC} "
			else
				echo -e "KO with BUFFER_SIZE=[$i] and generated text1 len of $NUMBER1\n\n" >> ../DEEPTHOUGHT
				echo -e "GENERATED TEXT1 :" >> ../DEEPTHOUGHT
				echo -e "--------------------------------------" >> ../DEEPTHOUGHT
				cat sample_bonus0 >> ../DEEPTHOUGHT
				echo -e "\n--------------------------------------" >> ../DEEPTHOUGHT
				echo -e "generated text2 len of $NUMBER2\n\n" >> ../DEEPTHOUGHT
				echo -e "GENERATED TEXT2 :" >> ../DEEPTHOUGHT
				echo -e "--------------------------------------" >> ../DEEPTHOUGHT
				cat sample_bonus1 >> ../DEEPTHOUGHT
				echo -e "\n--------------------------------------" >> ../DEEPTHOUGHT
				echo -e "generated text3 len of $NUMBER3\n\n" >> ../DEEPTHOUGHT
				echo -e "GENERATED TEXT3 :" >> ../DEEPTHOUGHT
				echo -e "--------------------------------------" >> ../DEEPTHOUGHT
				cat sample_bonus2 >> ../DEEPTHOUGHT
				echo -e "\n--------------------------------------\n" >> ../DEEPTHOUGHT
				echo -e "$RESULT" >> ../DEEPTHOUGHT
				echo -e "\n======================================" >> ../DEEPTHOUGHT
				echo -e -n "${RED}KO${NC} "
				ERROR=$((ERROR + 1))
			fi
		done
		echo
	done
fi

cd ..
rm -r temp

if [ $ERROR -gt 0 ]; then
	echo -e "\nIl y a $ERROR erreur(s), retrouve le detail dans ../DEEPTHOUGHT\n"
else
	echo -e "\nC'est parfait bravo !"
fi
