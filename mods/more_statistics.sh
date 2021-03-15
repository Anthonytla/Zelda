#!/bin/bash

whofirst() {
    prob=$(($1 - $2))
    i=1
    while [ $i -le 100 ];do
        if [ $i -le $prob ];then
            prob_vec+=("1")
        else
            prob_vec+=("0")
        fi
        ((i+=1))
    done
}

dodge() {
    
    diff=$(($1-$2))

    r=$RANDOM%100
    if [ $diff -gt 0 ];then
        whofirst $1 $2
        if [[ ${prob_vec[$r]} == "1" ]];then
            damage=0
            echo $3" dodged!"
        fi
        
    fi
}

damage_modifier2() {
    def=$1
    error=$(echo "scale=2;$damage * $def / 100 / 1" | bc -l)
    damage=$(echo "scale=0;($damage - $error) / 1" | bc -l)
}