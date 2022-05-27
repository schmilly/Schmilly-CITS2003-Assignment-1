#!/bin/bash

#BY WILLIAM VAN DEN WALL BAKE; 23086983

#KNOWN ISSUES:
#THROWS UP ERROR WHENEVE RUN< MOSTLY DUE TO FILE NAMES WITH SPACES, if only files without spaces program runs fine
#Will throw up interesting behaviour if word shows up twice, or is part of largewr word, didn't have time to develop multi-line varaible
#Probably terrible coding tbh, just straight up do not have the time to go through and optimsie tbh
#Variable names are probably terrible and definetly should be redone tbh
#First program was way better tbh sorry for putting you throught the pain of viewing this code


#Used to check if modifier boolean is used

wordrank=1
#Rank of occourance of word, by default 1

cwordbool=0
#Boolean Variable of wether or not a specific word is used or count

common_word="n/a"
#specific common word

usage="script usage: common_words [-w word | -nth N] <directory of text files>"

file=$1

#_-------------------ERROR CHECKING------------------------
if [[ -z $1 ]] 
	then
	1>&2 echo "Error: missing argument"
	echo $usage
	exit 2
fi

if [[ "$1" = "-*" ]]; then
	echo $usage
	exit 1
fi
	
if [ "$1" = "-nth" ] || [ "$1" = "-w" ]; then
	#Test there are enought arguments
	if [ -z $2 ] || [ -z $3 ]; then
		1>&2 echo "Error: missing argument" 
		echo $usage
		exit 2
	#Test if file or directory exists
	elif [ ! -f $3 ] && [ ! -d $3 ]; then
		1>&2 echo "Error: can't find file or directory" 
		echo $usage
		exit 2
	fi
	
#Allocate location of file or directory
file=$3

#---------------------Variable Setup-------------------------
if [ "$1" = "-nth" ]; then
    wordrank=$2

elif [ "$1" = "-w" ]; then
    common_word=$2
    cworldbool=1
fi
fi
filecount=$(ls -1q $file | wc -l)

#Mass ranking files 
for FILE in $file*.txt; do
	FILENAME=$(ls $FILE | xargs -n 1 basename)
	#Extract just name of file
	sed -e  's/[^A-Za-z]/ /g' $FILE | tr ' ' '\n' | grep -v '^$'| sort | uniq -c | sort -rn  > "$FILENAME.temp"
	#Create ranking of words in each file also mass outputs files in .temp format
done

if [ $cwordbool=1 ]; then
	FILENAME="NULL"
	LineNum=99999999
	#Set ranking of word at lowest possible value
	for FILE in *.temp; do
		if grep -q  $common_word $FILE; then
			#Checking existance of word in files
			TempLine=$(grep -n " $common_word" $FILE | cut -d: -f1 ) 
			#Parsing Ranking
			if (( $TempLine < $LineNum )); then 
				LineNum=$TempLine
				FILENAME=$(echo $FILE | cut -d'.' -f1,2)	
				#IF new Templine (ranking) is greater than previous set new ranking
				#And note down file name
			fi
		fi
	done
	#If no change detected in File Name, then the word must not exist in any specified files
	if [[ "$FILENAME" = "NULL" ]]; then echo "Could not find speicfied word anywhere in files" 
	else
		echo "The most significant rank for the word '$common_word' is $LineNum in file $FILENAME"
	fi

else
	#Combines all files, and finds ranking  word across all files
	cat $file* | grep -oE '[[:alpha:]]+' | sort | uniq -c | sort -nr > rank.txt.temp
	#Finding most popular word
	word=$(head -$wordrank rank.txt.temp | tail -1 | xargs | cut -d' ' -f2)
	#Find what files this ranking word is in and isn't, and change filecount value
	filecount=$(grep $word *.temp -lR | wc -l)
	echo "The $wordrank th most common word is '$word' across $filecount files"
	#OUTPUT Working, finally
fi

#Doing some clean up
for FILE in *.temp; do rm $FILE; done
