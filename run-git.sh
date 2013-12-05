#!/bin/sh

PATH=/usr/bin:node_modules/.bin

dir=../$1
branch=$2

if cd $dir; then
  git fetch origin $branch:refs/remotes/origin/$branch
  git reset --hard origin/$branch

  npm install

  [ -x node_modules/.bin/bower ] && bower i

fi
