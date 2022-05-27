#!/bin/bash
debug=false
Table_Name="incedenceOfMalaria.csv" 

#-------Input Verification Checks---------

#Checks for argument
if [[ -z $1 ]] 
then
    1>&2 echo "Error: missing argument"
    exit 2
fi

#Enable debug mode if arguments are presented
#if [[ -z $2 ]] ; then
#  if [[ $2 == "d" ]]; then debug="true"; fi
#fi
#Not fully functional properly, need to do more reading into flags ***COME BACK TO IF TIME ALLOWS**

#Check for Table specified for program
if [[ !  -f $Table_Name ]]
then
  1>&2 echo "Error: missing table $Table_Name"
  exit 1
fi

#Variable for creating a cut down table e.g. without Header + 
# And other unecessary information
tail $Table_Name -n+2 | cut -d, -f1,3,4 > cutdown.txt
#Redefine Table_Name since we are working with this cut down versoem
Table_Name="cutdown.txt"

#-------------------PARSING DATA-----------------------
#grep command removes all lines which do not have the users input ( $1 in this case) in it
#command then sorts based on feild 3, numerically
#then removes all but last line, outputting to text file "processed"
#We then extract the various variables from Processed into the various variables to be put into the final output
grep $1 $Table_Name | sort -k 3,3 -t, -n | tail -n1 > Processed.txt 
country=$(cut -d, -f1 Processed.txt)
year=$(cut -d, -f2 Processed.txt)
incidence=$(cut -d, -f3 Processed.txt)
#origonally this code was only supposed to work for year, but due to the glory of grep, we can use the same commands
#for both outputs, and only need to use the if statments to figure out how to phrase the final answer

#------Year input---------------

if [[ "$1" =~ ^[0-9]+$ ]]
then
  if [ "$debug" = true ]; then echo "I detected Num. input"; fi
  
  #Final output
  echo "For the Year $year, the country with the highest incidence was $country, with rate of $incidence per 1,000"

#--------Country Input----------

else
  if [ "$debug" = true ]; then echo "I deteced a non-num. input"; fi
   
  #Code for when a country is inputted
  #Final Output
  echo "For the country $country, the year with the highest incidence was $year. with a rate of $incidence per 1,000"  

fi

#Clean up after program is run keep files if debug mode is enabled to allow for investiagetion of what happened to files
if [ "$debug" = true ]; then echo "Program Run Through to End!" ; else rm cutdown.txt && rm Processed.txt ; fi

