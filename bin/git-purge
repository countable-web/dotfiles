#!/bin/bash

# remove a file from all revisions of a repository

git filter-branch -f --index-filter 'git rm -r --cached --ignore-unmatch $1'   --prune-empty --tag-name-filter cat -- --all
git gc

