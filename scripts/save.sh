if [ "$1" != "" ]; then
    echo "Commit text is $1" 
    git add .
    git commit -m "$1"
    git rebase origin/main
    git push origin main
else
    echo "Commit text is empty"
fi