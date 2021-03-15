#!/bin/bash

sw_extract() {
    first_line=0

    while IFS=',' read -r id name strength weakness attack_type alignment rarity;do
        if [[ $first_line -ne 0 ]];then
            if [[ $id -eq $1 ]];then
                class_weaknesses=$weakness
                class_strength=$strength
            fi
        else
            first_line=1
        fi
        
    done < classes.csv

    first_line=0
    while IFS=',' read -r id name strength weakness rarity;do
        if [[ $first_line -ne 0 ]];then
            if [[ $id -eq $2 ]];then
                race_weaknesses=$weakness
                race_strength=$strength
            fi
        else
            first_line=1
        fi
        
    done < races.csv

}

damage_modifier() {
    sw_extract $1 $2
    coeff=1
    IFS=";"
    for i in $class_weaknesses; do
        if [[ $i == $3 ]];then
            coeff=$(echo "scale=2;$coeff * 2 / 1" | bc -l)
        fi
    done

    for i in $race_weaknesses; do
        if [[ $i == $4 ]];then
            coeff=$(echo "scale=2;$coeff * 2 / 1" | bc -l)
        fi
    done
    for i in $class_strength; do
        if [[ $i == $3 ]];then
            coeff=$(echo "scale=2; $coeff / 2" | bc -l)
        fi
    done
    for i in $race_strength;do
        if [[ $i == $4 ]];then
            coeff=$(echo "scale=2;$coeff / 2" | bc -l)
        fi
    done
}

display_character() {
    first_line=0

    while IFS=',' read -r id name strength weakness attack_type alignment rarity;do
        if [[ $first_line -ne 0 ]];then
            if [[ $character_class -eq $id ]];then
                character_class_name=$name
            fi
        else
            first_line=1
        fi
        
    done < classes.csv

    first_line=0
    while IFS=',' read -r id name strength weakness rarity;do
        if [[ $first_line -ne 0 ]];then
            if [[ $character_race -eq $id ]];then
                character_race_name=$name
            fi
        else
            first_line=1
        fi
        
    done < races.csv
    echo $character_name
    echo "HP "$max_hp"       INT "$character_int
    echo "MP "$max_mp"       RES "$character_res
    echo "STR "$character_str"       LUCK "$character_luck
    echo "DEF "$character_def"       SPD "$character_spd
    echo "Class "$character_class_name"       Race "$character_race_name
    if [ $basic_game_customization -eq 1 ];then
        echo "Coins "$coins
    fi
    if [ $level_and_experience -eq 1 ];then
        echo "Level "$level"       Exp "$xp
    fi
    }
 