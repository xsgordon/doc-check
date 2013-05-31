#!/bin/sh

#
# Checks for repeated words using a list of those which are repeated most 
# often. The script should be run from the root directory of a publican
# created book.
#
# Usage: repetition_check.sh
#

GREP='/bin/grep'
SORT='/bin/sort'
ASPELL='/usr/bin/aspell'

#
# entity:
#
#   Check for use of non-standard entities which may hamper translation. Some
#   chance of false positives here so just a warning.
#
function entity() {

	for FILE in `find ./en-US/ -name '*.xml'`; do
		if [ "${FILE}" != "./en-US/Feedback.xml" ]; then
			if [ "${FILE}" != "./en-US/Legal_Notice.xml" ]; then
				if [ "${FILE}" != "./en-US/Book_Info.xml" ]; then
					entity_file ${FILE}
				fi
			fi
		fi
	done

}

function entity_file() {

	RESULT=`${GREP} -o '&[A-Z]*;' ${1}`
	for LINE in ${RESULT}; do
		echo "${1}: WARNING: Instances of '${LINE}' entity found. Consider replacing with literal text to aid translation."
	done

}

#
# repetition:
#
#   Check for repeated words using grep.
#
function repetition() {

	for FILE in `find ./en-US/ -name '*.xml'`; do
		repetition_file ${FILE}
	done

}

function repetition_file() {

	RESULT=`${GREP} -Pro '\s+(\w+)\s+\1\s+' ${1}`
	for LINE in ${RESULT}; do
		echo "${1}: ERROR: Repetition check failed on repeated instance of: '${LINE}'."
	done

}

#
# spelling:
#
#    Call to run aspell on xml files under the en-US directory, skipping words 
#    contained in specific markup elements.
#
function spelling {

	for FILE in `find ./en-US/ -name '*.xml'`; do
		spelling_file ${FILE}
	done 


}

function spelling_file {

	WORDS=`${ASPELL} --list --lang=en-US --mode=sgml --add-sgml-skip={parameter,option,package,replaceable,programlisting,userinput,screen,filename,command,computeroutput,abbrev,accel,orgname,surname,foreignphrase,acronym,hardware,keycap,systemitem,application} < ${1} | ${SORT} -u;`
	for WORD in ${WORDS}; do
		echo "${1}: ERROR: spell check failed on '${WORD}'"
	done

}

# contraction:
#	Check for the use of contractions such as:
#		could've
#		wouldn't
#	The check is pattern based, not limited to
#	these styles of contraction.
function contraction {

	for FILE in `find ./en-US/ -name '*.xml'`; do
		contraction_file ${FILE}
	done

}

function contraction_file {

	# *n't, *'ve, *'re, *'d, *'ll 
	PATTERNS=("\w*n\'t" "\w*\'ve" "\w*\'re" "\w*\'d" "\w*\'ll")

	for PATTERN in ${PATTERNS}; do
		RESULT=`${GREP} -Pro "${PATTERN}" ${1}`
		for LINE in ${RESULT}; do
			echo "${1}: ERROR: Contraction check found instance(s) of: '${LINE}'."
		done
	done

}

# If first argument is empty then assume we are scanning a book.
if [ -z "$1" ]; then
	if [ ! -d 'en-US' ]; then
		echo "ERROR: No en-US directory within current working directory."
		exit
	fi

	# Run both the repetition and spelling check then sort the results. The idea
	# is to group errors based on the filename.
	(repetition && spelling && entity && contraction) | ${SORT} -u
# Otherwise scan a single file.
else
	(repetition_file ${1} && spelling_file ${1} && entity_file ${1} && contraction_file) | ${SORT} -u
fi
