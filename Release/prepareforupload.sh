#!/bin/sh
# Developed for Hardcore WoW by STM3256
# Requirements: You need 7zip installed. It is free here: https://www.7-zip.org/
# Run this at the root of the project in master branch
# Enter the inputs when running this. 
# Use -v to specify the version of the hardcore addon
# Example useage in terminal while sitting at root of project:$ Release/prepareforupload.sh -v 0.11.7
while getopts v:a:f: flag
do
    case "${flag}" in
        v) hardcore_version=${OPTARG};;
    esac
done

if [ -z $hardcore_version ]
then
	echo "Hardcore Version required for script. Use [-v <ARGUMENT>]";
	exit 1
else
	echo "Hardcore Version: $hardcore_version";
fi

if [ -f "Hardcore.zip" ]
then
	echo "Hardcore zip already exists";
	exit 1
else
	echo "Hardcore Version: $hardcore_version";
fi

CURRENT_MILLIS="$(($(date +%s%N)/1000000))"
TEMPFOLDERNAME="temprelease_$hardcore_version-$CURRENT_MILLIS"
RELEASEFOLDERNAME="releasehardcore_$hardcore_version-$CURRENT_MILLIS"
echo $TEMPFOLDERNAME
mkdir "../$TEMPFOLDERNAME"
mkdir "../$RELEASEFOLDERNAME"
cp -r . "../$TEMPFOLDERNAME"
rm -rf .git
rm -rf .vscode
rm .gitignore
rm -rf Release
7z a ../$RELEASEFOLDERNAME/Hardcore.zip "../$TEMPFOLDERNAME"