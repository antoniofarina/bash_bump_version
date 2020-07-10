
# Antonio Farina
# ant.farina@gmail.com
# Created on Fri Jul 10 2020 4:52:56 PM
#
#
# The MIT License (MIT)
# Copyright (c) 2020 Antonio Farina
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
#

#!/bin/bash

FILE="../.version"

function increase_version (){
    current_version=$1
    mode=$2
    regex="([0-9]+).([0-9]+).([0-9]+)"
    if [[ $current_version =~ $regex ]]; then
      major="${BASH_REMATCH[1]}"
      minor="${BASH_REMATCH[2]}"
      patch="${BASH_REMATCH[3]}"

      if [[ "$mode" == "major" ]]; then
        major=$((major+1))
        minor=0
        patch=0
      elif [[ "$2" == "minor" ]]; then
        minor=$((minor+1))
        patch=0
      elif [[ "$2" == "patch" ]]; then
        patch=$((patch+1))
      fi
      
      echo "${major}.${minor}.${patch}"
     
    else
      >&2 echo "wrong version number $current_version. "
      >&2 echo "major.minor.patch (e.g. 1.0.56) expected"
      exit 0
    fi
}

    
if [ -f $FILE ]; then
   echo "$FILE exists."
else
   echo "File $FILE does not exist."
   #if the file does not exist, will create and assign a very first version number"
   echo "0.0.1" > $FILE
fi

CURRENT_VERSION=$(cat $FILE)
echo "current version is $CURRENT_VERSION , $1"

case $1 in
     -h|--help)
       echo "Generate a new version in the same way of npx version"
       echo "Write the new version in the .version file and "
       echo "push the new version on the git repo, generating a tag"
       echo "Usage: "
       echo "$0 -m|--minor"
       echo "$0 -p|--patch"
       echo "$0 -M|--major"
       exit 0
       ;;
     -m|--minor) 
      mode=minor
      ;;
     -p|--patch)
      mode=patch
      ;;
     -M|--major)
      mode=major
      ;;
      *)
      echo "Invalid mode $1. Allowed values are "
      echo "-m|--minor"
      echo "-p|--patch"
      echo "-M|--major"
      exit 0
      ;;
esac
echo "mode is $mode"
NEW_VERSION=$(increase_version "$CURRENT_VERSION" "$mode")
echo "New version is $NEW_VERSION"

#update the version on the file 
echo "$NEW_VERSION" > $FILE
[[ $VAR =~ .*Linux.* ]]
if [[ $NEW_VERSION != $CURRENT_VERSION ]]; then
    git add $FILE
fi
git commit -m"$NEW_VERSION" && git tag "$NEW_VERSION" && git push origin --follow-tags

