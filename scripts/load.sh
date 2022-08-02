#!/bin/bash

DNS=100.64.0.10;
for i in `seq 1 1000`; do
    QPS=$((i*10));
    echo "sending approx $QPS QPS to $DNS";
    GOT=$(
        for i in `seq 1 $QPS`; do
            dig +noall +short +search +answer +time=1 +retry=0 @$DNS google.com |
head -1;
        done | wc -l);
    echo got $GOT responses;
    sleep 1;
done

# "0x8180" for request with no error
# "0x0120" means response with no error
# "0x8183" shows whenever user asks for a domain that doesn't exist on the server.
#

for x in {1..100}
do
  dig +answer @100.64.0.10 gitlab.ouest-france.fr.eu-central-1.compute.internal a | grep -v -e 'NOERROR' > /dev/null || echo FAILURE
done


for x in {1..100}
do
  dig +answer +search gitlab.ouest-france.fr.eu-central-1.compute.internal a | grep -v -e 'NOERROR' > /dev/null || echo FAILURE
done


for x in {1..100}
do
  dig +answer +search gitlab.ouest-france.fr AAAA gitlab.ouest-france.fr A
done

for x in {1..100}
do
  dig +answer @198.18.0.1 gitlab.ouest-france.fr.eu-central-1.compute.internal a | grep -v -e 'NOERROR' > /dev/null || echo "FAILURE"
done

for x in {1..10000}; do  dig +answer @198.18.0.1 gitlab.ouest-france.fr.eu-central-1.compute.internal a | grep -v -e 'NOERROR' > /dev/null || echo "FAILURE"; done

for x in {1..10000}; do  dig +answer @198.18.0.1 gitlab.ouest-france.fr.eu-central-1.compute.internal a | grep -v -e 'NOERROR' > /dev/null || echo "FAILURE"; done

for x in {1..100}
do
  echo $x
done


  111  curl gitlab.ouest-france.fr
  112  curl gitlab.ouest-france.fr
  113  dig +answer +search gitlab.ouest-france.fr AAAA gitlab.ouest-france.fr A
  114  dig +answer +search gitlab.ouest-france.fr AAAA gitlab.ouest-france.fr A
  115  curl gitlab.ouest-france.fr
  116  dig +answer +search gitlab.ouest-france.fr AAAA gitlab.ouest-france.fr A
  117  curl gitlab.ouest-france.fr
