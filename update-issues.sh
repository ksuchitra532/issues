#!/bin/bash

set -ex

GITHUB_TOKEN=$INPUT_GITHUBTOKEN
GITHUB_REF=$INPUT_REF
GITHUB_REPOSITORY=$INPUT_REPO


git clone --branch "$GITHUB_REF" "https://ksuchitra532:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

# Checkout the branch from GITHUB_REF
BRANCH_NAME=$(echo $GITHUB_REF | sed 's/refs\/heads\///')
git checkout $BRANCH_NAME

# Get commit information from the checked-out branch
COMMIT_MESSAGE=$(git log --format=%B -n 1 $GITHUB_SHA)

echo $COMMIT_MESSAGE

# Find closed issues related to the branch
ISSUES=$(curl -s -X GET -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues?state=closed" | jq -r ".[] | select(.title | test(\"$BRANCH_NAME\")) | .number")

echo $ISSUES

# Loop through the closed issues
for issue in $ISSUES; do
  # Find the release associated with the closed issue
  RELEASE_NAME=$(curl -s -X GET -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/$issue" | jq -r '.milestone.title')

  if [ "$RELEASE_NAME" != "null" ]; then
    # If a release is associated, update the issue
    UPDATE_COMMENT="This issue was resolved in the release: $RELEASE_NAME."
    UPDATE_FIELD="\"Release\":\"$RELEASE_NAME\""
    
    # Echo messages for better visibility
    echo "Updating issue $issue:"
    echo " - Comment: $UPDATE_COMMENT"
    echo " - Field update: $UPDATE_FIELD"
    
    curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$issue/comments" -d "{\"body\":\"$UPDATE_COMMENT\"}" > /dev/null
    curl -s -X PATCH -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$issue" -d "{\"fields\":{$UPDATE_FIELD}}" > /dev/null
  fi
done
