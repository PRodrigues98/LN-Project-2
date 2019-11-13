#!/bin/bash

tempos=("+ip" "+if" "+is")
pessoas=("+1s" "+2s" "+3s" "+1p" "+2p" "+3p")

for t in ${tempos[@]}
do
	for p in ${pessoas[@]}
	do
		echo "$1$t$p"
	done
done