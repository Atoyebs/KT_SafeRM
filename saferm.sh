#!/bin/bash

pointOfExitArray=()
homeDir="$HOME"
trashSafermDirName=".Trash_saferm"
trashSafermPath="$homeDir/$trashSafermDirName"
srmTrue="0"
srmFalse="1"
rootDir=$1
currentDir="$rootDir"

#adding function for checking if directory exists at path

doesDirectoryExist(){

    if [ ! -d "$2/$1" ]; then
        mkdir "$2/$1"
        echo "Created Directory $2/$1 because it didn't previously exist"
    fi

}


createTrashSafeRMDir(){
    doesDirectoryExist $trashSafermDirName $homeDir
}

isResponseYes(){

#	response=$(echo "$1" | awk '{print substr($0,0,1)}')
	response="$1"

	#if the first letter of the response is upper or lower case Y
	if [[ ${response:0:1} == 'y' || ${response:0:1} == 'Y' ]]
	then
		true
	else2
		false
	fi

}


#returns a boolean value
shouldEnterDirectory(){

	if [[ -d "$1" && $# -ne 0 ]]
	then

		#ask them if they want to enter the directory (if it is a directory)
		read -p "do you want to enter the directory, $1? " response

		#if the first letter of the response is upper or lower case Y
		if [[ ${response:0:1} == 'y' || ${response:0:1} == 'Y' ]]
		then
			currentDir="$1"
			true
		else
			false
		fi

	else

		echo "usage: saferm [-drv] file ..."
		echo "	unlink file"
		false
	fi
}


#create a function to:
#	check whether the delete iteration you are on is the final file/directory in the directory: call function isFinalIteration
# if there are directories then it is the last directory
# if there are NO directories then it is the last file

#create a counter to increment the count


recursivelyDeleteContentsOfDirectory(){

    shouldEnterDirectory "$1"

	#if the user has chosen to enter the directory
	if [ $? -eq $srmTrue ]
	then

		#currentDir is whatever the first parameter is
		currentDir="$1"

		#count how many items are inside the directory

		#LIST of files within the current directory
		currentDirFileListing=$(ls -l "$currentDir" | grep -v '^d' | sed -n '1!p' | awk -F " " '{print $NF}')

		#COUNT of files within the current directory
		currentDirFileCount=$(ls -l "$currentDir" | grep -v '^d' | sed -n '1!p' | awk -F " " '{print $NF}'| wc -l | xargs)

		#LIST of directories within the current directory
		currentDirDirListing=$(ls -l "$currentDir" | grep '^d' | awk -F " " '{print $NF}')

		#COUNT of directories within the current directory
		currentDirDirListingCount=$(ls -l "$currentDir" | grep '^d' | awk -F " " '{print $NF}' | wc -l | xargs)

		#get the total number of files and directories (items) in this directory
		let totalListing=$currentDirFileCount+$currentDirDirListingCount

		#loop through every item asking if the user wants to delete it
		for item in $currentDirFileListing
		do

			#ask them if they want to enter the directory (if it is a directory)
			read -p "do you want to remove file $item? " response

			#is the user response yes or no
			isResponseYes $response

			#if their response is yes
			if [ $? -eq $srmTrue ]
			then
				let totalListing--
			fi

		done

		#loop through all directories
		for item in $currentDirDirListing
		do
			recursivelyDeleteContentsOfDirectory "$currentDir/$item"
			let totalListing--
		done


	fi


}


#code to Create the trash directory if it doesn't already exist
createTrashSafeRMDir



recursivelyDeleteContentsOfDirectory $1
