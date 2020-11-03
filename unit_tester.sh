# Unit tester for Minishell

RESET="\033[0m"

BLACK="\033[1m\033[30m"
RED="\033[1m\033[31m"
GREEN="\033[1m\033[32m"
YELLOW="\033[1m\033[33m"
BLUE="\033[1m\033[34m"
MAGENTA="\033[1m\033[35m"
CYAN="\033[1m\033[36m"
WHITE="\033[1m\033[37m"

# make -C ../ > /dev/null
# cp ../minishell .
# chmod 755 minishell


function get_test(){
	if [ "$2" == "-e" ]; then
		CAT=1
	else
		CAT=0
	fi
	while IFS= read -r line; do
		# echo "Text read from file : $line"
		run_test $line
		# printf " $YELLOW--- NEW CMD ---\n\n$RESET"
	done < "$1"
}

function run_test(){
	# echo "inside run_test"
#	# echo $line
	TEST1=$(echo $line "; exit" | ../minishell 2>&-)
	# echo "----"
	# echo $TEST1
	FLAG=0
	ES_1=$?
	TEST2=$(echo $line "; exit" | bash 2>&-)
	ES_2=$?
	if [ "$TEST1" == "$TEST2" ] && [ "$ES_1" == "$ES_2" ]; then
		printf " $GREEN%s$RESET" "OK"
	else
		printf " $RED%s$RESET" "X"
	fi
	echo " "$line
	if [ "$TEST1" != "$TEST2" ]; then
		echo
		echo
		FLAG=1
		# printf $RED"Your output :\n%.20s\n$RED$TEST1\n%.20s$RESET\n" "----"
		printf $RED"Your output :\n"
		if [ $CAT=1 ]; then
			echo $TEST1 | cat -e
		else
			echo $TEST1
		fi
		# printf $GREEN"Expected output :\n%.20s\n$GREEN$TEST2\n%.20s$RESET\n" "----"
		printf $GREEN"Expected output :\n"
		if [ $CAT=1 ]; then
			echo $TEST2 | cat -e
		else
			echo $TEST2
		fi
	fi
	if [ "$ES_1" != "$ES_2" ]; then
		echo
		echo
		FLAG=1
		printf $RED"Your exit status : $RED$ES_1$RESET\n"
		printf $GREEN"Expected exit status : $GREEN$ES_2$RESET\n"
	fi
	if [ $FLAG == 1 ]; then
		echo
		printf " $YELLOW--- NEW CMD ---\n\n$RESET"
		sleep 0.1
	fi
}

get_test $1 $2
# rm file1 file2 file3 doethet newfile.txt newfile test1 test2 test3 test4 x1 x2 x3 y1 y2 ilovewords.txt hardesttest.txt
