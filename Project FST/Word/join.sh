fstunion lemma2verb.fst lemma2adverb.fst > int.fst
fstunion lemma2noun.fst int.fst > lemma2word.fst

fstdraw --isymbols=../syms.txt --osymbols=../syms.txt --portrait lemma2word.fst | dot -Tpdf > lemma2word.pdf

rm int.fst