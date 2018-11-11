#!/bin/bash
set -euo pipefail # Unofficial bash strict mode
IFS=$'\n\t'

#######################################
#
# findreplace.sh
#
# Handy script for quick find/replace
# functions on Jekyll articles
#
# Author: Matt Oswalt
#
#######################################

function frametwitter () {
    echo $1
}

function framegist () {
    echo $1
}

function frameyoutube () {
    newYTURL=$(echo $1 | sed 's^watch?v=^embed/^g')
    echo '<div style="text-align: center"><iframe width="560" height="315" src="'$newYTURL'" frameborder="0" allowfullscreen></iframe></div>'
}

# Fetch a list of blog articles that have embedded youtube videos 
# while excluding those that LINK to the videos (indicated by parentheses)
# grep -r "www.youtube.com/watch?v=" _posts | grep -v '('  | grep -v iframe | sed 's/.markdown:/.markdown;/g' |  while read -r line ; do

#     filename=$(echo $line | cut -f1 -d';')
#     URL=$(echo $line | cut -f2 -d';')

#     changedURL=$(frameyoutube $URL)

#     echo "Changing $filename to $changedURL"

#     sed -i .bak  "s^$URL^$changedURL^g" $filename

# done

# Fetch a list of blog articles that have embedded tweets 
# grep -r "twitter.com" _posts | grep -v '(' | sed 's/.markdown:/.markdown;/g' |  while read -r line ; do

#     filename=$(echo $line | cut -f1 -d';')
#     URL=$(echo $line | cut -f2 -d';')

#     changedURL=$(frametwitter $URL)

#     # Never got around to writing the Twitter integration. This script will identify
#     # where things need to be changed, but I ended up doing it manually, as there were
#     # only a few posts with embedded tweets.

#     echo "Please change $changedURL in $filename"
# done

# Fetch a list of blog articles that have embedded gists 
# grep -r "gist.github.com" _posts | grep -v '(' |  while read -r line ; do

#     filename=$(echo $line | cut -f1 -d';')
#     URL=$(echo $line | cut -f2 -d';')

#     changedURL=$(framegist $URL)

#     echo "Please change $changedURL in $filename"
# done

grep -r "wp-content" _posts |  while read -r line ; do

    filename=$(echo $line | cut -f1 -d';')
    URL=$(echo $line | cut -f2 -d';')

    changedURL=$(framegist $URL)

    echo "Please change $changedURL in $filename"
done

rm -f _posts/*.bak

# Create array containing repository names
# declare -a REPOS=(
#     ansible-role-dnsmasq
#     ansible-role-quagga
#     ansible-role-iscdhcp
#     ansible-role-router
# )

# # Create roles dir if needed, and delete all existing roles
# echo "Resetting 'roles' dir..."
# mkdir roles/ && rm -rf roles/*

# # Create function to download repo
# function dlrepo {
#     if [ -d "$1" ]; then
#         rm -rf $1
#     fi

#     git clone -q git@github.com:Mierdin/$1 tmpworkspace/$1

#     # Copy all subdirectories
#     cp -r tmpworkspace/$1/roles/* roles/
# }

# # Need to create a temp working dir if needed here
# echo "Creating temporary workspace..."
# if [ -d "tmpworkspace" ]; then
#     rm -rf tmpworkspace
# fi
# mkdir tmpworkspace

# # Loop through the array, cloning into working directory
# echo "Cloning repositories..."
# for i in "${REPOS[@]}"
# do
#     dlrepo $i
# done

# # Clean up temporary workspace
# echo "Cleaning up..."
# rm -rf tmpworkspace
