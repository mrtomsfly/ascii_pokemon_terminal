#!/bin/bash

# a wild ascii pokemon will be summoned
summon_wild_pokemon () {
    local POKEMON_WORLD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)""/ascii"
    local POKEDEX_ID=$(echo -n 00$((1 + ${RANDOM} % 151)) | tail -c 3)
    local FOUND_POKEMON=$(find "${POKEMON_WORLD}" -maxdepth 1 -name "${POKEDEX_ID}*.txt" 2>/dev/null)
    
    if [[ -n "${FOUND_POKEMON}" ]]; then
        cat "${FOUND_POKEMON}"
    else
        echo "Found missingo! Please verify the pokedex in ${POKEMON_WORLD}/."
    fi
}

# this will summon one requested ascii pokemon in the terminal
summon_pokemon () {
    local POKEMON_WORLD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)""/ascii"
    local WANTED_POKEMON="${1,,}" # make all lowercase
    local ERROR_MSG=$(cat <<-EOF
	${WANTED_POKEMON} has never been registered! Use the gen1 pokedex(${POKEMON_WORLD}/); 001-->151.
	Remember to always write 3 numbers if submiting id, eg. 001.
	EOF
    )
    local MISSINGNO_MSG=$(cat <<-EOF

	                           Wild MISSINGNO. 
	                           appeared!
	 
	EOF
    )
    local FOUND_POKEMON=$(find "${POKEMON_WORLD}" -maxdepth 1 -name "*${WANTED_POKEMON}*.txt" 2>/dev/null)

    if [[ $(find "${POKEMON_WORLD}" -maxdepth 1 -name "*${WANTED_POKEMON}*.txt" 2>/dev/null | wc -l) -ne 1 ]]; then
        echo "${ERROR_MSG}"
        return
    fi
    
    local POKEDEX_FILE=$(find "${POKEMON_WORLD}" -maxdepth 1 -name "*${WANTED_POKEMON}*.txt" -type f -exec basename {} \; 2>/dev/null)
    local POKEDEX_ID=$(echo ${POKEDEX_FILE} | head -c 3)
    local POKEMON=$(echo ${POKEDEX_FILE} | head -c -5 | tail -c +4)
    
    if [[ "${WANTED_POKEMON}" == "${POKEDEX_ID}" || "${WANTED_POKEMON}" == "${POKEMON}" ]]; then
        cat "${FOUND_POKEMON}"
    else
        cat ${POKEMON_WORLD}"/glitchy_cave/missingno.txt"
        echo "${MISSINGNO_MSG}"
        echo "${ERROR_MSG}"
    fi
}

# this will summon all ascii pokemon in the terminal
summon_all_pokemon () {
    local POKEMON_WORLD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)""/ascii"
    mapfile -t FOUND_POKEMON < <(find "${POKEMON_WORLD}" -maxdepth 1 -name "*${WANTED_POKEMON}*.txt" -type f 2>/dev/null | sort)
    
    if [[ -n "${FOUND_POKEMON}" ]]; then
        cat "${FOUND_POKEMON[@]}"
    else
        echo "Every pokemon have gone missing! Please verify the pokedex in ${POKEMON_WORLD}/."
    fi
}

