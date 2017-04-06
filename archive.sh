#!/bin/bash
# archive script, by Ashley Trowell
# Copies tagged commits from a git repository to named folders.
# Does not overwrite existing folders.
# To make executable, run: chmod 755 archive.sh

REPO_DIR=~/workspace/exampleRepo/
BACKUP_DIR=~/workspace/tagArchive/

echo;
echo Git Archive Script
echo;

# Find local directories, and store in DIRS array.
cd $BACKUP_DIR
echo Show Folders:
echo;
DIRS=(*/) # Store all directories into DIRS array.
for dir in "${DIRS[@]}";
do 
    echo "$dir";
done


# Find Git Tags, and store in TAGS array.
cd $REPO_DIR
i=0;
for tag in $(git tag)
do
    TAGS[$i]=$tag; # Create TAGS array.
    ((i++))
done



# Capture HASHES for TAGS into ARRAY (Don't have a reason yet)
echo
echo Capture and show TAGS HASHES
echo
i=0;
for tag in "${TAGS[@]}"
do
    HASHES[$i]=$(git rev-parse $tag)
    echo "$i $tag ${HASHES[$i]}"
    ((i++)) # Increment i
done


# Determine which TAGS are not in DIRS, and store in NEW_DIRS array.
echo
echo Capture and show NEW_DIRS
echo
cd $BACKUP_DIR
i=0;
for tag in "${TAGS[@]}"
do
    DIR_EXISTS=0; # Assume Tag Dir doesn't exist, until found.

    if [ -d "$tag" ]  # If "tag" folder exists...
    then
        echo "The folder $tag exists."
        DIR_EXISTS=1;
    fi
   
    # If Tag didn't match any existing Dir, add to NEW_DIRS array.
    if [ $DIR_EXISTS -eq "0" ]
    then
        echo "Adding $tag as directory in NEW_DIRS."
        NEW_DIRS[$i]=$tag
        ((i++)) # Increment i
    fi
done

echo;echo "Display all New Directories to be created:"
echo ${NEW_DIRS[@]}
echo;


# Create New Directories:
cd $BACKUP_DIR
for dir in ${NEW_DIRS[@]}
do
    echo "Creating Directory $dir"
    mkdir $dir
    cd $REPO_DIR
    git checkout $dir
    cd $BACKUP_DIR
    cp $REPO_DIR* $BACKUP_DIR$dir

    #cd $BACKUP_DIR
done


cd $REPO_DIR
git checkout master
