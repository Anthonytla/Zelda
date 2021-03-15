#!/bin/bash

new_game() {
    new=0;
    echo "1. New game   2. Quit"
    read new
}

difficulty() {
    lvl=0;
    new_game
    if [ $new -eq 1 ];then
        echo "1. Normal  2. Difficult  3. Insane"
        read lvl
    elif [ $new -eq 2 ];then
        exit
    fi
}

start() {
    coins=12
    difficulty
    diff_coeff=1
    if [ $lvl -eq 2 ];then
        diff_coeff=1.5
    elif [ $lvl -eq 3 ];then
        diff_coeff=2
    fi
}