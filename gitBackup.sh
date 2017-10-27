#!/bin/bash

rm -f *~

git add -A
git commit -m "auto-commit"
git push origin master
