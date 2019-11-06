fstinvert lemma2word.fst > word2lemma.fst

fstdraw --isymbols=../syms.txt --osymbols=../syms.txt --portrait word2lemma.fst | dot -Tpdf > word2lemma.pdf