# get directory of this script
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_DIR="$ROOT_DIR/workflow-repos"

while true; do
    # iterate over all directories in workflow-repos
    for d in $WORKFLOW_DIR/* ; do
        # get the name of the repository
        REPO_NAME=$(basename $d)
        echo ""
        echo "Syncing $REPO_NAME"
        # check if directory is a git repository
        if [ -d "$d/.git" ]; then
            cd $WORKFLOW_DIR/$REPO_NAME
            git pull

            # check if there are changes
            if [ -n "$(git status --porcelain)" ]; then
                git add .
                # commit with the current date formatted as YYYY.MM.DD HH:mm:SS
                git commit -m "autosynced - $(date +'%F %H:%M:%S')"
                git push
            fi
        fi
        echo ""
        echo "=================================================================================="
        echo ""
    done
    echo "##################################################################################"
    echo "##################################################################################"
    echo ""
  sleep 15
done
