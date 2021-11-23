#!/bin/sh

dataset=${1?}
shift

for lr in "$@"
do
    for activation in relu sigmoid
    do
        python experiments/train_mlp.py -D $dataset -a $activation -l $lr \
            | perl -lne 'print $1 if /\s+accuracy: (.*)/' \
            | awk -v OFS=, -v d=$dataset -v a=$activation -v l=$lr '{print d,a,l,NR-1,$0}'
    done
done

