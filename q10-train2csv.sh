#!/bin/sh

dataset=${1?}
shift

for lr in "$@"
do
    for activation in relu sigmoid
    do
        for nesterov in false true
        do
            python experiments/train_mlp.py -e 10 -D $dataset -a $activation -l $lr -m 0.9 $(eval $nesterov && printf %s -n) \
                | perl -lne 'print $1 if /\s+accuracy: (.*)/' \
                | awk -v OFS=, -v d=$dataset -v a=$activation -v l=$lr -v m=0.9 -v n=$nesterov '{print d,a,l,m,n,NR-1,$0}'
        done
    done
done

