#!/bin/bash
git filter-branch -f --index-filter 'git rm -r --cached --ignore-unmatch $1'   --prune-empty --tag-name-filter cat -- --all

