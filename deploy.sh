#!/bin/sh

git ls-remote --exit-code -q github > /dev/null 2>&1
if test $? != 0; then
    printf "Adding github remote\n"
    git remote add github https://github.com/rjw245/rjw245.github.io.git
fi
git push github public:master
