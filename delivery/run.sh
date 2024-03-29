#!/bin/bash
# Transdutores básicos

# Compila e gera a versão gráfica de lemma2noun
fstcompile --isymbols=syms.txt --osymbols=syms.txt lemma2noun.txt | fstarcsort > FINALtransducers/lemma2noun.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait FINALtransducers/lemma2noun.fst | dot -Tpdf  > FINALpdf/lemma2noun.pdf

# Compila e gera a versão gráfica de lemma2adverb
fstcompile --isymbols=syms.txt --osymbols=syms.txt lemma2adverb.txt | fstarcsort > FINALtransducers/lemma2adverb.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait FINALtransducers/lemma2adverb.fst | dot -Tpdf  > FINALpdf/lemma2adverb.pdf

# Compila e gera a versão gráfica de lemma2verbip
fstcompile --isymbols=syms.txt --osymbols=syms.txt lemma2verbip.txt | fstarcsort > FINALtransducers/lemma2verbip.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait FINALtransducers/lemma2verbip.fst | dot -Tpdf  > FINALpdf/lemma2verbip.pdf

# Compila e gera a versão gráfica de lemma2verbis
fstcompile --isymbols=syms.txt --osymbols=syms.txt lemma2verbis.txt | fstarcsort > FINALtransducers/lemma2verbis.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait FINALtransducers/lemma2verbis.fst | dot -Tpdf  > FINALpdf/lemma2verbis.pdf

# Compila e gera a versão gráfica de lemma2verbif
fstcompile --isymbols=syms.txt --osymbols=syms.txt lemma2verbif.txt | fstarcsort > FINALtransducers/lemma2verbif.fst
fstdraw    --isymbols=syms.txt --osymbols=syms.txt --portrait FINALtransducers/lemma2verbif.fst | dot -Tpdf  > FINALpdf/lemma2verbif.pdf

# Uniões entre transdutores

# Compila e gera a versão gráfica de lemma2verb
fstunion FINALtransducers/lemma2verbif.fst FINALtransducers/lemma2verbip.fst > int.fst
fstunion FINALtransducers/lemma2verbis.fst int.fst > FINALtransducers/lemma2verb.fst
rm int.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait FINALtransducers/lemma2verb.fst | dot -Tpdf > FINALpdf/lemma2verb.pdf

# Compila e gera a versão gráfica de lemma2word
fstunion FINALtransducers/lemma2verb.fst FINALtransducers/lemma2adverb.fst > int.fst
fstunion FINALtransducers/lemma2noun.fst int.fst > FINALtransducers/lemma2word.fst
rm int.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait FINALtransducers/lemma2word.fst | dot -Tpdf > FINALpdf/lemma2word.pdf

# Compila e gera a versão gráfica de word2lemma
fstinvert FINALtransducers/lemma2word.fst > FINALtransducers/word2lemma.fst
fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait FINALtransducers/word2lemma.fst | dot -Tpdf > FINALpdf/word2lemma.pdf

tests_lemma2verb=(1 2 3 4)
tests_lemma2word=(5 6 7 8)
tests_word2lemma=(9 10 11 12)


for t in ${tests_lemma2verb[@]}
do
	fstcompile --isymbols=syms.txt --osymbols=syms.txt  "test_$t.txt" | fstarcsort > "FINALexamples/test$t.fst"
	fstcompose "FINALexamples/test$t.fst" "FINALtransducers/lemma2verb.fst" > "FINALexamples/test$t""_lemma2verb.fst"
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait "FINALexamples/test$t""_lemma2verb.fst" | dot -Tpdf > "FINALexamples/test$t""_lemma2verb.pdf"
done

for t in ${tests_lemma2word[@]}
do
	fstcompile --isymbols=syms.txt --osymbols=syms.txt  "test_$t.txt" | fstarcsort > "FINALexamples/test$t.fst"
	fstcompose "FINALexamples/test$t.fst" "FINALtransducers/lemma2word.fst" > "FINALexamples/test$t""_lemma2word.fst"
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait "FINALexamples/test$t""_lemma2word.fst" | dot -Tpdf > "FINALexamples/test$t""_lemma2word.pdf"
done

for t in ${tests_word2lemma[@]}
do
	fstcompile --isymbols=syms.txt --osymbols=syms.txt  "test_$t.txt" | fstarcsort > "FINALexamples/test$t.fst"
	fstcompose "FINALexamples/test$t.fst" "FINALtransducers/word2lemma.fst" > "FINALexamples/test$t""_word2lemma.fst"
	fstdraw --isymbols=syms.txt --osymbols=syms.txt --portrait "FINALexamples/test$t""_word2lemma.fst" | dot -Tpdf > "FINALexamples/test$t""_word2lemma.pdf"
done
