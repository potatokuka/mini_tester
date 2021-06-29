#!/bin/bash
# Unit tester for Minishell

MINISHELL_PATH="../minishell/"

RESET="\033[0m"
BLACK="\033[1m\033[30m"
RED="\033[1m\033[31m"
GREEN="\033[1m\033[32m"
YELLOW="\033[1m\033[33m"
BLUE="\033[1m\033[34m"
MAGENTA="\033[1m\033[35m"
CYAN="\033[1m\033[36m"
WHITE="\033[1m\033[37m"

#Automatic clean up of created files in current directory:

record_filestate_of_current_directory()
{
	ls > .filestate_before
}
remove_files_created_by_test()
{
	ls > .filestate_after
	FILESTATE_DIFF=$(diff .filestate_before .filestate_after | grep ">" | sed "s|> ||g" | tr '\n' ' ')
	rm $FILESTATE_DIFF .filestate_before .filestate_after
}

#$1 = color, ${@:2} is string
printf_color()
{
	1>&2 printf $1
	printf "${@:2}"
	1>&2 printf $RESET
}

echo_color()
{
	1>&2 printf $1
	echo "$2"
	echo "$3"
	1>&2 printf $RESET
}

separate_options_from_files()
{
	OPTIONS=()
	FILES=()

	for var in $@; do
	{
		if [ "${var::1}" = "-" ]; then
			OPTIONS+=("$var")
		else
			FILES+=("$var")
		fi
	}
	done
}

parse_options()
{
	CAT=0
	for var in $@; do
		if [ "$var" = "-e" ]; then
			CAT=1
		fi
	done
}

check_if_minishell_path_is_valid()
{
	if ! [ -f "${MINISHELL_PATH}minishell" ]; then
		printf "${RED}ERROR${RESET}: Minishell path doesn't contain 'minishell' executable\nMinishell path is currently set to: \"${MINISHELL_PATH}\"\nChange the MINISHELL_PATH variable in the script to set the path\n"
		exit 1
	fi
}

run_all_tests()
{
	PASS_COUNTER=0
	FAIL_COUNTER=0

	for file in $@; do
	{
		if [ ! -f "$file" ]; then
			printf "File '$file' does not exist\n"
			continue
		fi
		while IFS= read line || [[ "$line" ]]; do
			run_single_test $line
		done < "$file"
	}
	done
	echo "---- Finished Tests -----"
	echo ""
	printf "Passed = ""$PASS_COUNTER""\n"
	printf "Failed = ""$FAIL_COUNTER""\n"
}

run_single_test()
{
	FAILED=0
	RESULT_MS=$(echo $line "; exit" | ${MINISHELL_PATH}minishell 2>/dev/null)
	EXIT_MS=$?
	RESULT_BASH=$(echo $line "; exit" | bash 2>/dev/null)
	EXIT_BASH=$?
	if [ "$RESULT_MS" = "$RESULT_BASH" ] && [ "$EXIT_MS" = "$EXIT_BASH" ]; then
		printf_color $GREEN "[OK]"
		let PASS_COUNTER++
	else
		printf_color $RED "[KO]"
		let FAIL_COUNTER++
		FAILED=1
	fi
	echo " "$line
	if [ "$RESULT_MS" != "$RESULT_BASH" ]; then
		if [ "$CAT" = 1 ]; then
			echo_color $RED "Your output :" "$(echo $RESULT_MS | cat -e)"
		else
			echo_color $RED "Your output :" "$(echo $RESULT_MS)"
		fi
		if [ "$CAT" = 1 ]; then
			echo_color $GREEN "Bash output :" "$(echo $RESULT_BASH | cat -e)"
		else
			echo_color $GREEN "Bash output :" "$(echo $RESULT_BASH)"
		fi
	fi
	if [ "$EXIT_MS" != "$EXIT_BASH" ]; then
		echo
		printf_color $RED "Your exit status : $EXIT_MS\n"
		printf_color $GREEN "Bash exit status : $EXIT_BASH\n"
	fi
	if [ $FAILED -eq 1 ]; then
		printf_color $YELLOW '\n %s NEW CMD %s\n\n' '---' '---'
		sleep 0.1
	fi
}

if [ $# -eq 0 ]; then
	printf "${RED}ERROR${RESET}: Please provide atleast one argument\nUsage: ./unit_tester.sh <TEST_FILES>... [OPTIONS]\n"
	exit 1
fi

check_if_minishell_path_is_valid

separate_options_from_files $@
parse_options ${OPTIONS[@]}

record_filestate_of_current_directory
run_all_tests ${FILES[@]}
remove_files_created_by_test