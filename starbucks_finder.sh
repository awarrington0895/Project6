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
    if [[ $numberOfHits == 0 ]]; then
        echo "Starbucks couldn't be found in that city"
    else
        printf "There are $numberOfHits stores in $city\n"
        printf "Please enter a single word from the street name: "
        read street
        awk -F: --assign streetSearch=$street '$9 ~ streetSearch{printf "%2d:%-40s\n",NR,$9}' foundCities.tmp > foundStreet.tmp
        cat foundStreet.tmp
        echo "First field is record number"
        printf "Select a record number: "
        read recordNumber
        awk --assign record=$recordNumber -F: 'NR ~ record{printf "Store Number: %d\nAddress: %-40s\nCity, State: %-s, %2s\nPhone Number: %-12s\n", $1, $9,$12,$13,$8}' foundCities.tmp
        
        
    fi
fi
