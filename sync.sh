# get directory of this script
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_DIR="$ROOT_DIR/workflow-repos"


echo $GIT_TOKEN
echo $WORKFLOW_REPOS
apt update -y
apt install -y gh
echo $GIT_TOKEN | gh auth login --with-token


# Set name and mail for git
git config --global user.name "${GITHUB_USER}"
git config --global user.email "${GITHUB_EMAIL}"

# clone all repositories specified in the WORKFLOW_REPOS
# env variable into the workflow-repos directory
IFS=';' read -r -a REPOS <<< "$WORKFLOW_REPOS"
for REPO in "${REPOS[@]}"
do
    cd $WORKFLOW_DIR
    gh repo clone $REPO
done

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

