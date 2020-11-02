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
	while IFS= read -r line; do
		# echo "Text read from file : $line"
		run_test $line
	done < "$1"
}

function run_test(){
	# echo "inside run_test"
	# echo $line
	TEST1=$(echo $line "; exit" | ./minishell 2>&-)
	# echo "----"
	# echo $TEST1
	ES_1=$?
	TEST2=$(echo $line "; exit" | bash 2>&-)
	ES_2=$?
	if [ "$TEST1" == "$TEST2" ] && [ "$ES_1" == "$ES_2" ]; then
		printf " $GREEN%s$RESET" "OK"
	else
		printf " $RED%s$RESET" "X"
	fi
	printf "$CYAN \"$line\" $RESET"
	if [ "$TEST1" != "$TEST2" ]; then
		echo
		echo
		printf $RED"Your output :\n%.20s\n$RED$TEST1\n%.20s$RESET\n" "----"
		printf $GREEN"Expected output :\n%.20s\n$GREEN$TEST2\n%.20s$RESET\n" "----"
	fi
	if [ "$ES_1" != "$ES_2" ]; then
		echo
		echo
		printf $RED"Your exit status : $RED$ES_1$RESET\n"
		printf $GREEN"Expected exit status : $GREEN$ES_2$RESET\n"
	fi
	echo
	sleep 0.1
}

get_test $1
rm file2 file3 doethet newfile.txt newfile test1 test2 test3 test4 x1 x2 x3 y1 y2 ilovewords.txt hardesttest.txt
