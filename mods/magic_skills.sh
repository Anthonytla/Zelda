#!/bin/bash

option_replace() {
    better_options=()
    for i in "${options_arr[@]}";do
        if [[ $i == "Heal" ]];then
            better_options+=("Skills")
        else
            better_options+=($i)
        fi
    done
    options_arr=("${better_options[@]}") 
}

display_skills() {
    skills=("Cheat Heal" "Cheat Restore" "Cheat Fireball")
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
    character_class_name=$(echo "$character_class_name" | tr '[:upper:]' '[:lower:]')
    while IFS=',' read -r id name cost dmg effect cooldown race class rarity;do
        if [[ $first_line -ne 0 ]];then
            IFS=";"
            for i in $class;do
                if [[ $i =~ $character_class_name ]];then
                    skills+=("$name")
                    magic_damage=$dmg
                    mp_cost=$cost
                fi
            done
        else
            first_line=1
        fi
    done < spells.csv
    j=1
    for i in "${skills[@]}"; do
        echo $j". "$i
        ((j+=1))
    done
}

execute_spell() {
    skill=$(echo "$skill" | tr '[:upper:]' '[:lower:]')
    if [[ $skill =~ [0-9] ]];then
        ((skill-=1))
    fi

    if [[ $skill == "fireball" ]] || ([[ $skill =~ [0-9] ]] && [ ${skills[$skill]} == "Fireball" ]);then
        if [ $character_mp -ge 10 ];then
            damage=20
            use_spell=1
            ((character_mp-=10))
        else 
            echo "Not enough Mana!"
        fi
    elif [[ $skill == "heal" ]] || ([[ $skill =~ [0-9] ]] && [ ${skills[$skill]} == "Heal" ]);then
        if [ $character_mp -ge 10 ];then
            ((character_hp+=20))
            echo "You healed!"
            ((character_mp-=10))
        else
            echo "Not enough Mana!"
        fi
        heal_spell=1
    elif [[ $skill == "heal ii" ]] || ([[ $skill =~ [0-9] ]] && [ ${skills[$skill]} == "Heal II" ]);then
        if [ $character_mp -ge 30 ];then
            ((character_hp+=50))
            echo "You healed!"
            ((character_mp-=30))
        else
            echo "Not enough Mana!"
        fi
        heal_spell=1
    elif [[ $skill == "cheat heal" ]] || ([[ $skill =~ [0-9] ]] && [ ${skills[$skill]} == "Cheat Heal" ]);then
        if [ $character_mp -ge 20 ];then
            ((character_hp+=100))
            echo "You healed!"
            ((character_mp-=20))
        else
            echo "Not enough Mana!"
        fi
        heal_spell=1
    elif [[ $skill == "cheat restore" ]] || ([[ $skill =~ [0-9] ]] && [ ${skills[$skill]} == "Cheat Restore" ]);then
        ((character_mp+=100))
        echo "MP restored!"
        if [ $character_mp -gt $max_mp ];then
            character_mp=$max_mp
        fi
        heal_spell=1
    elif ([[ $skill == "cheat fireball" ]] || ([[ $skill =~ [0-9] ]] && [ ${skills[$skill]} == "Cheat Fireball" ]));then
        if [ $character_mp -ge 20 ];then
            damage=200
            ((character_mp-=20))
            use_spell=1
        else
            echo "Not enough Mana!"
        fi
    fi
    if [ $character_hp -gt $max_hp ];then
		character_hp=$max_hp
	fi
}