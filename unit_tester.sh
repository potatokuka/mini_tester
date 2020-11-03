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

MSHELL_PATH=../minishell/

get_test() {
	CAT=0
	for var in $@; do
		if [ "$var" = "-e" ]; then
			CAT=1
		fi
	done

	if ! [ -f "${MSHELL_PATH}minishell" ]; then
		printf "${RED}ERROR${RESET}: Minishell path doesn't contain 'minishell' executable\nMinishell path is currently set to: \"${MSHELL_PATH}\"\nChange the MSHELL_PATH variable in the script to set the path\n"
		exit 1
	fi

	for var in $@; do
		if [ "${var::1}" = "-" ]; then
			continue
		fi
		if [ ! -f "$var" ]; then
			printf "File '$var' does not exist\n"
			continue
		fi
		while IFS= read -r line; do
			# echo "Text read from file : $line"
			run_test $line
			# printf " $YELLOW--- NEW CMD ---\n\n$RESET"
		done < "$var"
	done
}

run_test() {
	# echo "inside run_test"
#	# echo $line
	RESULT=$(echo $line "; exit" | ${MSHELL_PATH}minishell 2>&-)
	# echo "----"
	# echo $RESULT
	FLAG=0
	EXIT_MS=$?
	EXPECTED=$(echo $line "; exit" | bash 2>&-)
	EXIT_BASH=$?
	if [ "$RESULT" = "$EXPECTED" ] && [ "$EXIT_MS" = "$EXIT_BASH" ]; then
		printf " "
		1>&2 printf "$GREEN"
		printf "%s" "[OK]"
		1>&2 printf "$RESET"
	else
		printf " "
		1>&2 printf "$RED"
		printf "%s" "[KO]"
		1>&2 printf "$RESET"
	fi
	echo " "$line
	if [ "$RESULT" != "$EXPECTED" ]; then
		echo
		FLAG=1
		# printf $RED"Your output :\n%.20s\n$RED$RESULT\n%.20s$RESET\n" "----"
		1>&2 printf "$RED"
		printf "Your output :\n"
		if [ "$CAT" = 1 ]; then
			echo $RESULT | cat -e
		else
			echo $RESULT
		fi
		# printf $GREEN"Expected output :\n%.20s\n$GREEN$EXPECTED\n%.20s$RESET\n" "----"
		1>&2 printf "$GREEN"
		printf "Bash output :\n"
		if [ "$CAT" = 1 ]; then
			echo $EXPECTED | cat -e
		else
			echo $EXPECTED
		fi
	fi
	if [ "$EXIT_MS" != "$EXIT_BASH" ]; then
		echo
		FLAG=1
		1>&2 printf "$RED"
		printf "Your exit status : "
		1>&2 printf "$RED"
		printf "$EXIT_MS"
		1>&2 printf "$RESET"
		echo
		1>&2 printf "$GREEN"
		printf "Bash exit status : "
		1>&2 printf "$GREEN"
		printf "$EXIT_BASH"
		1>&2 printf "$RESET"
		echo
	fi
	if [ $FLAG -eq 1 ]; then
		printf "\n "
		1>&2 printf "$YELLOW"
		printf "%s NEW CMD %s\n\n" "---" "---"
		1>&2 printf "$RESET"
		sleep 0.1
	fi
}

if [ $# -eq 0 ]; then
	printf "${RED}ERROR${RESET}: Please provide atleast one argument\nUsage: ./unit_tester.sh <TEST_FILE> [OPTIONS]\n"
	exit 1
fi

get_test $@
# rm file1 file2 file3 doethet newfile.txt newfile test1 test2 test3 test4 x1 x2 x3 y1 y2 ilovewords.txt hardesttest.txt
