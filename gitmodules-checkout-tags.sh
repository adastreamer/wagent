#!/bin/bash

WORKING_DIR=$PWD

MOD_FILE=.gitmodules
SUBMODULE_DECLARATION_HEADER='\[submodule "(.+)"\]'

MODS_NUMS=($(grep -n -E "$SUBMODULE_DECLARATION_HEADER" $MOD_FILE | cut -d ":" -f1))
MODS_DIRS=($(grep -n -E "$SUBMODULE_DECLARATION_HEADER" $MOD_FILE | cut -d "\"" -f2))
LINE_MAX="$(($(cat $MOD_FILE | wc -l)))"

for i in ${!MODS_NUMS[@]}
do
    cd $WORKING_DIR
    LINE_FROM=${MODS_NUMS[$i + 0]}
    LINE_TO=${MODS_NUMS[$i + 1]:=$LINE_MAX}
    DIR=${MODS_DIRS[$i]}
    TAG=$(sed -n ${LINE_FROM},${LINE_TO}p $MOD_FILE | grep tag | cut -d '=' -f2)
    if [ -z $TAG ]; then continue; fi

    echo -e "---\n$DIR: $TAG"
    cd $DIR && git checkout $TAG
done
