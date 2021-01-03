if [ "$1" != "" ]; then
    echo "Commit text is $1" 
    git add .
    git commit -m "$1"
    git rebase origin/master
    git push origin master
else
    echo "Commit text is empty"
fi