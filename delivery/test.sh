#!/bin/bash


# Required files in directory:
#
#		word2fst.py
#

tests=tests/*.txt
counter=1

for t in $tests
do
	fstToTest=$(echo "$t" | sed "s/.*test_\(.*\).txt/\1/")

	echo "$fstToTest:"

	while IFS= read -r line
	do
		inout=($line)

		if [ "${#inout[*]}" == "1" ]
		then
			inout[1]=""
		fi

		python3 word2fst.py -s syms.txt "${inout[0]}" > test_tmp.txt
		fstcompile --isymbols=syms.txt --osymbols=syms.txt  test_tmp.txt | fstarcsort > "FINALexamples/test$counter.fst"
		rm test_tmp.txt
		fstcompose "FINALexamples/test$counter.fst" "FINALtransducers/$fstToTest.fst" > "FINALexamples/test$counter""_$fstToTest.fst"
		fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait "FINALexamples/test$counter""_$fstToTest.fst" | dot -Tpdf > "FINALexamples/test$counter""_$fstToTest.pdf"

		result=$(fstproject --project_output "FINALexamples/test$counter""_$fstToTest.fst" | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{printf "%s", $3}')

		toPrint="${inout[0]} -> $result"

		totalExpectedSize=0
		wrong="0"

		for expected in "${inout[@]:1}"
		do
			check=$(python -c "print(all(x in iter(\"$result\") for x in \"$expected\"))")

			totalExpectedSize=$(($totalExpectedSize + ${#expected}))

			if [ "$check" != "True" ]
			then
				toPrint+=" ERROR expected: ${inout[@]:1}"
				wrong="1"
				break
			fi
		done

		if [ "$wrong" == "0" ] && [ "$totalExpectedSize" != "${#result}" ]
		then
			toPrint+=" ERROR expected: ${inout[@]:1}"
		fi

		echo $toPrint

		let "counter++"
			
	done < "$t"

	echo " "
done

exit