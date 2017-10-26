#!/bin/bash

cleanup

git add -A
git commit -m "auto-commit"
pit push origin master
