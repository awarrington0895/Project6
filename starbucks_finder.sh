#!/bin/bash


clear

echo "What area do you wish to find a Starbucks in?"
echo " "
echo "1 - DC Area"
echo "2 - Anywhere Else"
echo "3 - Exit"

printf "Enter choice: "
read input

if [[ $input == 1 ]]; then
    printf "Enter a city name to search: "
    read city
    awk -F: --assign city="$city" '$12 ~ city{print}' DC_Area.csv  > foundCities.tmp
    numberOfHits=`cat foundCities.tmp | wc -l`
    
    # Checks if there is at least one city found
    if [[ $numberOfHits == 0 ]]; then
        echo "Starbucks couldn't be found in that city"
        exit 50
    elif [[ $numberOfHits == 1 ]]; then
        printf "There are $numberOfHits stores in $city\n"
        awk -F: '{printf "Store Number: %d\nAddress: %-40s\nCity, State: %-s, %2s\nPhone Number: %-12s\n", $1, $9,$12,$13,$8}' foundCities.tmp
        rm foundCities.tmp
        
    else
        printf "There are $numberOfHits stores in $city\n"
        printf "Please enter a single word from the street name: "
        read street
        awk -F: --assign streetSearch=$street '$9 ~ streetSearch{printf "%2d:%-40s\n",NR,$9}' foundCities.tmp > foundStreet.tmp
        streetFound=`cat foundStreet.tmp | wc -l`
        
        # Checks if there are any streets found
            if [[ $streetFound > 0 ]]; then
            cat foundStreet.tmp
            echo "First field is record number"
            printf "Select a record number: "
            read recordNumber
            grep "^$recordNumber" foundStreet.tmp
            awk --assign record=$recordNumber -F: 'NR ~ record{printf "Store Number: %d\nAddress: %-40s\nCity, State: %-s, %2s\nPhone Number: %-12s\n", $1, $9,$12,$13,$8}' foundCities.tmp
            rm foundStreet.tmp
            rm foundCities.tmp
            exit 51
        else
            echo "There are no Starbucks on that street"
            exit 52
        fi
        
        
    fi
elif [[ $input == 2 ]]; then
    echo "Areas are not available for search, sorry."
    exit 53
else
    echo "Sorry I couldn't help.  Goodbye."
    exit 54
fi

