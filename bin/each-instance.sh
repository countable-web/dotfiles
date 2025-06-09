#!/bin/bash


for i in $(ls -d */ | grep cortico | grep -v website | grep -v tmp | grep -v cerebro | grep -v efk); do
    cd /home/jenkins/workspace/$i
    echo 'processing' $i;
    $@
done
