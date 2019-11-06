fstunion lemma2verbif.fst lemma2verbip.fst > int.fst
fstunion lemma2verbis.fst int.fst > lemma2verb.fst

fstdraw --isymbols=../syms.txt --osymbols=../syms.txt --portrait lemma2verb.fst | dot -Tpdf > lemma2verb.pdf

rm int.fst