# get directory of this script
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_DIR="$ROOT_DIR/workflow-repos"


echo $SSH_PRIVATE_KEY
echo $WORKFLOW_REPOS
# save the private key to a file if not already present
if [ ! -f ~/.ssh/id_ed25519 ]; then
    # replace spaces with newlines
    SSH_PRIVATE_KEY=$(echo $SSH_PRIVATE_KEY | tr " " "\n")
    echo $SSH_PRIVATE_KEY > ~/.ssh/id_ed25519
    chmod 600 ~/.ssh/id_ed25519
fi

# Set name and mail for git
git config --global user.name "${GITHUB_USER}"
git config --global user.email "${GITHUB_EMAIL}"

# add the private key to the ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519


# clone all repositories specified in the WORKFLOW_REPOS
# env variable into the workflow-repos directory
IFS=';' read -r -a REPOS <<< "$WORKFLOW_REPOS"
for REPO in "${REPOS[@]}"
do
    echo "Cloning $REPO"
    REPO_NAME=$(basename $REPO)
    REPO_NAME="${REPO_NAME/.git/}"
    if [ ! -d "$WORKFLOW_DIR/$REPO_NAME" ]; then
        git clone $REPO $WORKFLOW_DIR/$REPO_NAME
    fi
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
