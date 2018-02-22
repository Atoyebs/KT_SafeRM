#!/bin/bash

argFirst="$( echo $@ | awk '{ print $1 }')"
argLast="$( echo $@ | awk '{ print $NF }' | xargs)"
subDirectoryNameOptions="$( echo $@ | awk '{$1=""; print $0}' | awk '{$NF=""; print $0}' )"

#create a specific file structure
createFileStructure(){

  parentLevelDir="$argFirst"

  #3 number of iterations
  iteration=$1

  #create an array of possible names that can be used for subdirectories
  arrayOfNameOptions=($subDirectoryNameOptions)
  arrayOfNameOptionsLength=${#arrayOfNameOptions[@]}
  arrayOfNameOptionsLength=$(($arrayOfNameOptionsLength - 2))
  immidiateChildOfParentDirFileCount=5

  randOneToTwelve=$(( ($RANDOM % 10) + 2 ))
  randOneToThree=$(( ($RANDOM % 3) + 1 ))

  parentLevelFilename=$parentLevelDir$iteration

  #create parent level directory
  mkdir $parentLevelFilename

  for ((i=0; i <= randOneToTwelve; i++))
  do
    # echo "$parentLevelFilename/""$parentLevelDir""_file_$i.txt"
    touch "$parentLevelFilename/""$parentLevelDir""_file_$i.txt"
  done

  for ((y=0; y <= randOneToThree; y++))
  do

    randWithinArrayLength=$(echo $(($RANDOM % $arrayOfNameOptionsLength)))
    randomArrayItem=$(echo ${arrayOfNameOptions[$randWithinArrayLength]})
    dirToCreate="$parentLevelFilename""/$randomArrayItem""_$y"
    mkdir "$dirToCreate"

    for ((x=0; x <= randOneToTwelve; x++))
    do
      touch "$dirToCreate""/""$randomArrayItem""_$x"".txt"
    done

  done

}

for i in `seq $argLast`
do
  createFileStructure $i
done

# while getopts ":fda" opt; do
#   case $opt in
#     f)
#       echo "-f was triggered!" >&2
#       ;;
#     d)
#       echo "-d was triggered!" >&2
#       ;;
#     a)
#       echo "-i was triggered!" >&2
#       ;;
#     \?)
#       echo "Invalid option: -$OPTARG" >&2
#       ;;
#   esac
# done
#
# shift "$(($OPTIND -1))"
