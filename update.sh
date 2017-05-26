#!/bin/bash

git add -A
git commit -m 'update'
git push origin master
mkdocs gh-deploy
