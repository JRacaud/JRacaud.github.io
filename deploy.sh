#! /bin/sh

read -p "Commit message: " message

# Remove the previous version of the website
rm -rf ./public

# Generate the website
hugo --minify

if [[ $? -ne 0 ]]; then
    echo "[ERROR]: Cannot generate website. Aborting..."
    read -s "Press enter to exit..."
    exit 1
fi

# Copy the files into a temp directory
mkdir .deployed
cp -r ./public/* .deployed/

if [[ $? -ne 0 ]]; then
    echo "[ERROR]: Cannot backup website. Aborting..."
    read -s "Press enter to exit..."
    exit 1
fi

# Checkout gh-pages branch and update everything
git checkout gh-pages
rm -rf *

cp -r ./deployed/* .

if [[ $? -ne 0 ]]; then
    echo "[ERROR]: Cannot copy website. Aborting..."
    read -s "Press enter to exit..."
    exit 1
fi

git commit -am $message
git push

# We can now go back to the main branch and delete the temp folder
git checkout main
rm -rf .deployed