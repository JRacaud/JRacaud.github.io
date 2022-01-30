#! /bin/sh

ROOT=$PWD
PUBLIC_FOLDER=$ROOT/public
DEPLOY_FOLDER=.deploy

read -p "Commit message: " message

git submodule update

rm -rf $PUBLIC_FOLDER
hugo --minify

if [[ $? -ne 0 ]]; then
    echo "[ERROR]: Cannot generate website. Aborting..."
    read -p "Press enter to exit..."
    exit 1
fi

mkdir $DEPLOY_FOLDER
cd $DEPLOY_FOLDER
git clone -b gh-pages git@github.com:JRacaud/JRacaud.github.io.git gh-pages

cd gh-pages
rm -rf *

cp -r $PUBLIC_FOLDER/* .

if [[ $? -ne 0 ]]; then
    echo "[ERROR]: Cannot copy website. Aborting..."
    read -p "Press enter to exit..."
    exit 1
fi

git add .
git commit -am $message
git push

cd $ROOT
rm -rf $PUBLIC_FOLDER
rm -rf $DEPLOY_FOLDER