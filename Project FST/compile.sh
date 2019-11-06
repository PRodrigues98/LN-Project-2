#!/bin/bash

if [ "$#" != "1" ] && [ "$#" != "2" ]
then 
	echo "Correct usage: "
	echo "		$0 arg1 [arg2]"
	echo "			arg1 - fst (in text format) file to be compiled"
	echo "			(Optional) arg2 - name of compiled file"
	exit
fi

if [ "$#" == "2" ]
then
	dirname=$(dirname "$2")
	basename=$(basename "$2")
	filename="$2"
	filenameNoExt="${basename%.*}"
else
	dirname=$(dirname "$1")
	basename=$(basename "$1")
	filename="$1"
	filenameNoExt="${basename%.*}"
fi

################### letras ################
#
# Compila e gera a versão gráfica do transdutor passado como argumento
fstcompile --isymbols=syms.txt --osymbols=syms.txt  "$1" | fstarcsort > "$dirname/$filenameNoExt.fst"
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait "$dirname/$filenameNoExt.fst" | dot -Tpdf  > "$dirname/$filenameNoExt.pdf"