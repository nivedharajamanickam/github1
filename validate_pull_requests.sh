#!/bin/bash

# === Configuration ===
REPO="yourusername/yourrepo"   # Replace with your actual GitHub repo (e.g., nivedha/myproject)
MIN_TITLE_LENGTH=5
VALID_BRANCH_PREFIX="feature/"

echo "🔍 Checking PRs for repository: $REPO"

# === Fetch open PRs ===
prs=$(gh pr list --repo "$REPO" --state open --json number,title,author,headRefName,assignees --jq '.[]')

if [ -z "$prs" ]; then
  echo "✅ No open pull requests found."
  exit 0
fi

# === Validate each PR ===
echo "$prs" | jq -c '.' | while read -r pr; do
  number=$(echo "$pr" | jq -r '.number')
  title=$(echo "$pr" | jq -r '.title')
  author=$(echo "$pr" | jq -r '.author.login')
  branch=$(echo "$pr" | jq -r '.headRefName')
  assignee_count=$(echo "$pr" | jq '.assignees | length')

  echo "🔧 Validating PR #$number by @$author"

  # --- Title Check ---
  if [ ${#title} -lt $MIN_TITLE_LENGTH ]; then
    echo "⚠️  PR #$number has a short title: \"$title\""
  fi

  # --- Branch Name Check ---
  if [[ "$branch" != "$VALID_BRANCH_PREFIX"* ]]; then
    echo "⚠️  PR #$number uses non-standard branch name: \"$branch\""
  fi

  # --- Reviewer Check ---
  if [ "$assignee_count" -eq 0 ]; then
    echo "⚠️  PR #$number has no reviewers assigned."
  fi

  echo "✅ Done checking PR #$number"
  echo "----------------------------------"

done

echo "🎉 All PRs validated."

