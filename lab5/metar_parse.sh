#!/bin/bash

#from directions
curl -s "https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" > aviation.json

#pull out the receiptTime value from aviation.json (loop through array []), follow this with a command to print out the first 6 values
jq -r '.[].receiptTime' aviation.json | head -n 6


#grab all temp values using same notation as before, temps is a BASH array, by placing our command in () and using $, we store command results
#as opposed to just running it like above
temps=($(jq -r '.[].temp' aviation.json))

#initialize variables for for loop to keep track of temp data
sum=0
count=0

#for loop to access each item in the temps array.  sum stores temperature sum as we go through the array, use count to keep track of iterations.
#for the sum, we store the command data like we did with temps
for temp in "${temps[@]}"; do
    sum=$(echo "$sum + $temp")
    ((count++))
done

#calculate and store average.  we have to add the additional bc command to actually compute the average, otherwise it will just show everything
#as a math process and not the actual average.  i had to download bc to use it after looking it up
#sudo apt install bc
avg=$(echo "$sum / $count" | bc)

echo "Average Temperature: $avg"

#store the cloud information from the cloud array using some format as before
clouds=($(jq -r '.[].clouds' aviation.json))

#cloud count
cloud_c=0
#total count
total_c=0

#counts the amount of cloud reports that were not clear.  For each iteration of the for loop, we check if the cloud value did not equal
#"CLR", and if so, we add it to our count.  We also keep track of the amount of iterations using total
for cloud in ${clouds[@]}; do
    if [[ "$cloud" != "CLR" ]]; then
        ((cloud_c++))
    fi
    ((total_c++))
done


#check if the majority of cloud reports were cloudy or not, and output true if they were and false otherwise.  -gt checks for greater than
#from the total reports / 2
if [ $cloud_c -gt $((total_c/2)) ]; then
    echo "Mostly Cloudy: true"
else
    echo "Mostly Cloudy: false"
fi
