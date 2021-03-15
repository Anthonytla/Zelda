#!/bin/bash

level=1
xp=0
offset=50
earn_xp () {
    gain=$((15+$RANDOM%36))
    ((xp+=$gain))
}

gain_level() {
    earn_xp
    if [[ $xp -ge $offset ]];then
        ((level+=1))
        ((max_hp+=$RANDOM%10))
        ((max_mp+=$RANDOM%10))
        ((character_str+=$RANDOM%5))
        ((character_def+=$RANDOM%5))
        ((character_int+=$RANDOM%5))
        ((character_res+=$RANDOM%5))
        ((character_spd+=$RANDOM%5))
        ((character_luck+=$RANDOM%5))
        ((offset*=2))
        echo "You passed to lvl"$level
    fi

}
