#!/bin/sh
# Developed for Hardcore WoW by STM3256 aka cheappurplesuit#9458
# Requirements: You need 7zip installed. It is free here: https://www.7-zip.org/
# Run this at the root of the project in the branch of code you want to release
# Expected output: A folder one level up from where it is run that contains a single zip named "Hardcore.zip" which when extracted has one folder named "Hardcore"
# Enter the input flag when running this. 
# Use -v to specify the version of the hardcore addon
# Example useage in terminal while sitting at root of project:$ Release/prepareforupload.sh -v 0.11.7
# After uploading the artifact, any folders beginning with "releasehardcore_" can safely be deleted
while getopts v: flag
do
    case "${flag}" in
        v) hardcore_version=${OPTARG};;
    esac
done

# Ensure a version is entered
if [ -z $hardcore_version ]
then
	echo "Hardcore Version required for script. Use [-v <ARGUMENT>]";
	echo "Example Use: $ Release/prepareforupload.sh -v 0.11.7 ";
	exit 1
else
	echo "Hardcore Version: $hardcore_version";
fi

# Check we are running at the root of the project
if [ -f "Hardcore.toc" ]
then
	echo "Release script is running at the root of project, continuing..."
else
	echo "Release script is not running at the root of the project"
	echo "Change directories to where you cloned it"
	echo "Execute it like this in terminal that can run shell: $ Release/prepareforupload.sh -v 0.11.7"
	exit 1
fi

DATETIME="$(date +%F_%H-%M-%S)"
TEMPFOLDERNAME="temprelease_$hardcore_version-$DATETIME"
ZIPFOLDERNAME="Hardcore"
FILENAME="Hardcore.zip"
RELEASEFOLDERNAME="releasehardcore_$hardcore_version-$DATETIME"
mkdir "../$TEMPFOLDERNAME"
mkdir "../$TEMPFOLDERNAME/$ZIPFOLDERNAME"
mkdir "../$RELEASEFOLDERNAME"
cp -r . "../$TEMPFOLDERNAME/$ZIPFOLDERNAME"
rm -rf "../$TEMPFOLDERNAME/$ZIPFOLDERNAME/.git"
rm -rf "../$TEMPFOLDERNAME/$ZIPFOLDERNAME/.vscode"
rm -rf "../$TEMPFOLDERNAME/$ZIPFOLDERNAME/Release"
rm "../$TEMPFOLDERNAME/$ZIPFOLDERNAME/.gitignore"
7z a ../$RELEASEFOLDERNAME/$FILENAME "../$TEMPFOLDERNAME/$ZIPFOLDERNAME"
rm -rf "../$TEMPFOLDERNAME"
echo "Release $FILENAME created one level up in here: $RELEASEFOLDERNAME"