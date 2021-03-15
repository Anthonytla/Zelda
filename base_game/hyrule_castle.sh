#!/bin/bash

rougefonce='\e[0;31m'
vertclair='\e[1;32m'

neutre='\e[0;m'

italic='\e[3m'
none='\e[0m'
turn2=0
stagenb=1

rarity_tab=(4 4 4 4 5)
for i in $(seq 1 15);do
    rarity_tab=( 3 ${rarity_tab[*]} )
done
for i in $(seq 1 30);do
    rarity_tab=( 2 ${rarity_tab[*]} )
done
for i in $(seq 1 50);do
    rarity_tab=( 1 ${rarity_tab[*]} )
done


function rarity_extract(){
    first_line=0
    r=$RANDOM%100
    i=0
    line1="id,name,hp,mp,str,int,def,res,spd,luck,race,class,rarity"
    echo $line1 >> tmp
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity;do
        if [[ $first_line -ne 0 ]];then
            if [[ $rarity -eq ${rarity_tab[$r]} ]];then
                line="$i,$name,$hp,$mp,$str,$int,$def,$res,$spd,$luck,$race,$class,$rarity"
                echo $line >> tmp
		((i+=1))
            fi
        else
            first_line=1
        fi
    done < $1
    nline1=$(cat tmp | wc -l)
    ((nline1-=1))
}


character () {

    rarity_extract players.csv
    first_line=0
    r=$(($RANDOM % $nline1))
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity;do
        if [[ $first_line -ne 0 ]];then
            if [ $id -eq $r ];then
                character_hp=$hp
		        character_mp=$mp
                character_str=$str
                character_int=$int
                character_def=$def
                character_res=$res
                character_spd=$spd
                character_luck=$luck
                character_class=$class
                character_race=$race
                max_hp=$hp
		        max_mp=$mp
                character_name=$name
                break
            fi
        else
            first_line=1
        fi
    done < tmp
    rm tmp
#    rm tmp
#    name="Link"
#    str=15
#    max_hp=$1
#    max_mp=$2
#    character_hp=$1
#    character_mp=$2
}

display(){
    echo " "
    echo " "
    echo "==========FIGHT" $fight"=========="

    echo " "
    echo -e "${vertclair}"$character_name"${neutre}"
    health_bar=""
    mp_bar=""
    j=1
    while [ $j -le $character_hp ];do
	    health_bar+="I"
        ((j+=1))
    done
    j=1
    while [ $j -le $(($max_hp-$character_hp)) ];do
	    health_bar+="_"
        ((j+=1))
    done
    
    j=1
    while [ $j -le $(($character_mp)) ];do
	    mp_bar+="I"
        ((j+=1))
    done
    echo "HP:" $health_bar $character_hp"/"$max_hp
    echo "MP:" $mp_bar $character_mp"/"$max_mp
    echo " "
    echo -e "${rougefonce}"$en_name"${neutre}"
    health_bar=""
    mp_bar=""
    j=1
    while [ $j -le $en_hp ];do
	    health_bar+="I"
        ((j+=1))
    done
    j=1
    while [ $j -le $(($max_en_hp-$en_hp)) ];do
	    health_bar+="_"
        ((j+=1))
    done
    j=1
    while [ $j -le $en_mp ];do
	    mp_bar+="I"
        ((j+=1))
    done
    echo "HP:" $health_bar $en_hp"/"$max_en_hp
    echo "MP:" $mp_bar $en_mp"/"$max_en_mp

    echo " "
    if [ $turn2 -eq 0 ];then
            echo " "
            echo -e "${italic}You encounter a "$en_name"${none}"
            turn2=1;
    fi

}

ennemy () {
    rarity_extract enemies.csv
    first_line=0
    r2=$(($RANDOM % $nline1))
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity;do
        if [[ $first_line -ne 0 ]];then
            if [[ $id -eq $r2 ]];then

                en_name=$name
                en_hp=$(echo "scale=0;$hp*$diff_coeff/1" | bc -l)
                en_mp=$(echo "scale=0;$mp*$diff_coeff/1" | bc -l)
                en_spd=$(echo "scale=0;$spd*$diff_coeff/1" | bc -l)
                en_class=$class
                en_race=$race
                max_en_hp=$(echo "scale=0;$hp*$diff_coeff/1" | bc -l)
                max_en_mp=$(echo "scale=0;$mp*$diff_coeff/1" | bc -l)
                en_str=$(echo "scale=0;$str*$diff_coeff/1" | bc -l)
                en_def=$(echo "scale=0;$def*$diff_coeff/1" | bc -l)
            fi
        else
            first_line=1
        fi
    done < tmp
    rm tmp
    
}

boss() {
    #en_name="Ganon"
    #en_str=20
    #max_en_hp=$1
    #max_en_mp=$2
    #en_class=8
    #en_race=12
    #en_hp=$max_en_hp
    #en_mp=$max_en_mp
    rarity_extract bosses.csv
    first_line=0
    r3=$(($RANDOM % $nline1))
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity;do
        if [[ $first_line -ne 0 ]];then
            if [[ $id -eq $r3 ]];then
                en_name=$name
                en_hp=$(echo "scale=0;$hp*$diff_coeff/1" | bc -l)
                en_mp=$(echo "scale=0;$mp*$diff_coeff/1" | bc -l)
                en_spd=$(echo "scale=0;$spd*$diff_coeff/1" | bc -l)
                en_class=$class
                en_race=$race
                max_en_hp=$(echo "scale=0;$hp*$diff_coeff/1" | bc -l)
                max_en_mp=$(echo "scale=0;$mp*$diff_coeff/1" | bc -l)
                en_str=$(echo "scale=0;$str*$diff_coeff/1" | bc -l)
                en_def=$(echo "scale=0;$def*$diff_coeff/1" | bc -l)
            fi
        else
            first_line=1
        fi
    done < tmp
    rm tmp   
}

stage() {
    stages=10
    if [ $basic_game_customization -eq 1 ];then
        echo "Entrez le nombre d'étages"
        read stages
    fi
}
    
character_init() {
    character
#    echo -e "${italic}You encounter a "$en_name"${none}"
}

ennemy_init() {
    ennemy
}

options() {
    opt=0;
    options_arr=("Attack" "Heal")
    echo "---Options-----------"
    if [ $basic_characteristics -eq 1 ];then
        options_arr+=("Character")
    fi
    if [ $better_combat_options -eq 1 ];then
        better_options
    fi
    if [ $magic_skills -eq 1 ];then
        option_replace
    fi
    j=1
    for i in "${!options_arr[@]}";do
        echo $j". ${options_arr[i]}"
        ((j+=1))
    done
    read opt
}

character_attack() {
    if [ -z $use_spell ] || [ $use_spell -lt 1 ];then
        damage=$character_str
    fi
    if [ $basic_characteristics -eq 1 ];then
        damage_modifier $en_class $en_race $character_class $character_race
        damage=$(echo "scale=0; $damage * $coeff / 1" | bc -l)
        if [ $(echo "scale=0;$coeff / 1" | bc -l) -gt 1 ];then
            echo "Crushing hit"
        fi
        if [ $(echo "scale=0;$coeff / 1" | bc -l) -lt 1 ];then
            echo "Glancing hit"
        fi
    fi
    

}
execute_option() {
    if [[ $opt =~ [0-9] ]];then
        ((opt-=1))
    fi
    opt=$(echo "$opt" | tr '[:upper:]' '[:lower:]')
    if [ $magic_skills -eq 1 ] && ([[ $opt == "skills" ]] || ([[ $opt =~ [0-9] ]] && [[ ${options_arr[$opt]} == "Skills" ]]));then
        display_skills
        read skill
        execute_spell
        
    elif [[ $opt == "attack" ]] || ([[ $opt =~ [0-9] ]] && [[ ${options_arr[$opt]} == "Attack" ]]);then
        attack=1
        character_attack
        #if [ -z use_spell ];then
        #    damage=$character_str
        #fi
        #if [ $basic_characteristics -eq 1 ];then
        #    echo $character_str
        #    damage_modifier $en_class $en_race $character_class $character_race
        #    damage=$(echo "scale=0; $damage * $coeff / 1" | bc -l)
        #    echo "------"$coeff $damage
        #    if [ $(echo "scale=0;$coeff / 1" | bc -l) -gt 1 ];then
        #        echo "Crushing hit"
        #    fi
        #fi
        if [ $more_statistics -eq 1 ];then
            dodge $en_spd $character_spd $en_name
            damage_modifier2 $en_def
        fi
        
        
	
	    
	elif [[ $opt == "heal" ]] || ([[ $opt =~ [0-9] ]] && [[ ${options_arr[$opt]} == "Heal" ]]);then
	    ((character_hp+=$(($max_hp/2))))
	    echo "You healed" $(($max_hp/2)) "hp"
	    if [ $character_hp -gt $max_hp ];then
		    character_hp=$max_hp
	    fi

    elif [ $basic_characteristics -eq 1 ] && ([ $opt == "character" ] || ([[ $opt =~ [0-9] ]] && [ ${options_arr[$opt]} == "Character" ]));then
        display_character

    elif [ $better_combat_options -eq 1 ] && ([ $opt == "escape" ] || ([[ $opt =~ [0-9] ]] && [ ${options_arr[$opt]} == "Escape" ]));then
        echo "You fled"
        exit    
    fi

    if ([ ! -z $use_spell ] && [ $use_spell -eq 1 ]) || ([ ! -z $attack ] && [ $attack -eq 1 ]);then
        if [ $character_hp -gt 0 ];then
            ((en_hp-=$damage))
        
            echo "You attacked and dealt" $damage "damages"
        fi
        unset use_spell
        unset attack
    fi
    if [ $en_hp -le 0 ] && [ $character_hp -gt 0 ];then
        echo $en_name "died"
        ((coins+=1))
        echo "You earn 1 coin"
        ((stagenb+=1))
        turn2=0
        fight=0
        if [ $level_and_experience -eq 1 ];then
            gain_level
        fi
        if [ $stagenb -le $stages ];then
            echo "You passed stage" $stagenb
        else
            echo "Congratulation"
        fi

        if [ $(($stagenb % 10)) -eq 0 ];then
            boss
        fi
    fi
}

ennemy_attack() {
    damage=$en_str
    if [ $basic_characteristics -eq 1 ];then
        damage_modifier $character_class $character_race $en_class $en_race
        
        damage=$(echo "scale=0; $damage * $coeff / 1" | bc -l)
        if [ $(echo "scale=0;$coeff / 1" | bc -l) -lt 1 ];then
            echo "Glancing hit"
        fi
        if [ $(echo "scale=0;$coeff / 1" | bc -l) -gt 1 ];then
            echo "Crushing hit"
        fi
    fi
    if [ $better_combat_options -eq 1 ] && ([[ $opt == "protect" ]] || ([[ $opt =~ [0-9] ]] && [ ${options_arr[$opt]} == "Protect" ]));then
        ((damage/=2))
            
    fi
    if [ $more_statistics -eq 1 ];then
        dodge $character_spd $en_spd $character_name
        damage_modifier2 $character_def
    fi
    if [ $en_hp -gt 0 ];then
        character_hp=$(echo "scale=2; $character_hp-$damage" | bc -l)
    fi
    echo $en_name "attacked and dealt" $damage "damages"
    if [ $character_hp -le 0 ];then
        echo "You died"
        exit
    fi
}

combat() {
    ((fight+=1))
    en_turn=0
    if [ $more_statistics -eq 1 ] && [ $en_spd -gt $character_spd ];then
        en_turn=1
    fi
    if [ $en_turn -ne 1 ];then
        display
        #if [ $turn2 -eq 0 ];then
        #    echo " "
        #    echo -e "${italic}You encounter a "$en_name"${none}"
        #    turn2=1;
        #fi
    fi
    if [ $en_turn -eq 1 ];then
        ennemy_attack
        display
        options
        execute_option
    else
        options
        execute_option
        if [ $en_hp -gt 0 ];then
            ennemy_attack
        fi
        #en_turn=1
    fi
    if [ $en_hp -le 0 ];then
        ennemy_init
    fi
    #if [ $en_hp -le 0 ] && [ $character_hp -gt 0 ];then
    #    ennemy_init
    #    ((stagenb+=1))
    #    turn2=0
    #    fight=0
     #   if [ $level_and_experience -eq 1 ];then
     #       earn_xp
      #  fi
	  #  echo "You passed stage" $stagenb
      #  if [ $(($stagenb % 10)) -eq 0 ];then
      #      boss
      #  fi
	
    #fi
}

mods() {
    mod=0
    echo "Choose your mod and then enter ok"
    
    basic_characteristics=0
    level_and_experience=0
    better_combat_options=0
    more_statistics=0
    magic_skills=0
    basic_game_customization=0

    while [ $mod != "ok" ];do
        echo "1. No mods   2.Basic characteristics"
        echo "3. Level_and_experience   4. Better_combat_option"
        echo "5. More_statistics   6. Magic_skills"
        echo "7. Basic_game_customization"
        read mod
        if [[ $mod -eq 2 ]];then
            basic_characteristics=1
            source ../mods/basic_characteristics.sh
        fi
        if [[ $mod -eq 3 ]];then
            level_and_experience=1
            source ../mods/level_and_experience.sh
        fi
        if [[ $mod -eq 4 ]];then
            better_combat_options=1
            source ../mods/better_combat_options.sh
        fi
        if [[ $mod -eq 5 ]];then
            more_statistics=1
            source ../mods/more_statistics.sh
        fi
        if [[ $mod -eq 6 ]];then
            magic_skills=1
            source ../mods/magic_skills.sh
        fi
        if [[ $mod -eq 7 ]];then
            basic_game_customization=1
            source ../mods/basic_game_customization.sh
        fi

    done

    echo " "
    echo " "
}

main(){
    diff_coeff=1
    mods
    if [ $basic_game_customization -eq 1 ];then
        start
    fi
    stage
    character_init
    ennemy_init
    fight=0
    turn2=0
    while [ $stagenb -le $stages ];do
	    combat
    done
    
#    echo -e "${italic}You encounter a "$en_name"${none}"
}

main


