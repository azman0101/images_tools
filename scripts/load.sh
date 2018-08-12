#!/bin/bash

DNS=100.64.0.10;
for i in `seq 1 1000`; do
    QPS=$((i*10));
    echo "sending approx $QPS QPS to $DNS";
    GOT=$(
        for i in `seq 1 $QPS`; do
            dig +noall +short +answer +time=1 +retry=0 @$DNS google.com |
head -1;
        done | wc -l);
    echo got $GOT responses;
    sleep 1;
done
