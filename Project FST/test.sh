#!/bin/bash


# Required files in directory:
#
#		if you want to directly use a word to test an fst, word2fst.py
#		
#


if [ "$#" != "2" ]
then 
	echo "Correct usage: "
	echo "		$0 arg1 arg2"
	echo "			arg1 - fst to be tested"
	echo "			arg2 - test fst file or word to test"
	echo " "
	echo "Note - fst files not .fst will be compiled"
	echo "Note - results will be placed in the same directory as the fst to be tested"
	exit
fi

filesToDelete=()


toTestDirname=$(dirname "$1")
testDirname=$(dirname "$2")

toTestBasename=$(basename "$1")
testBasename=$(basename "$2")

toTestFilename="${toTestBasename%.*}"
toTestExtension="${toTestBasename##*.}"
testFilename="${testBasename%.*}"
testExtension="${testBasename##*.}"


# if test has no extension nor dir
if [ "$testExtension" == "$testFilename" ]
then
	testDirname="."
	testFilename="$2"
	testExtension="txt"
	testBasename="$testFilename.$testExtension"
	python3 word2fst.py -s syms.txt "$2" > "$testBasename"
	filesToDelete+=("$testBasename")
fi

################### Testa os tradutores ################
#
# Compila e gera a versão gráfica do transdutor que traduz Inglês em Português

if [ "$toTestExtension" != "fst" ]
then
	fstcompile --isymbols=syms.txt --osymbols=syms.txt  "$toTestDirname/$toTestBasename" | fstarcsort > "$toTestFilename.fst"
	filesToDelete+=("$toTestDirname/$toTestFilename.fst")
fi

if [ "$testExtension" != "fst" ]
then
	fstcompile --isymbols=syms.txt --osymbols=syms.txt  "$testDirname/$testBasename" | fstarcsort > "$testDirname/$testFilename.fst"
	filesToDelete+=("$testDirname/$testFilename.fst")
fi

fstcompose "$testDirname/$testFilename.fst" "$toTestDirname/$toTestFilename.fst" > "$toTestDirname/test$testFilename""_$toTestFilename.fst"
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait "$toTestDirname/test$testFilename""_$toTestFilename.fst" | dot -Tpdf > "$toTestDirname/test$testFilename""_$toTestFilename.pdf"

for index in ${!filesToDelete[*]}
do
    rm "${filesToDelete[$index]}"
done
