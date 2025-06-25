#!/bin/bash

# -------- Configuration --------
GITHUB_OWNER="your-username-or-org"
GITHUB_REPO="your-repo-name"
GITHUB_TOKEN="your-github-token"  # classic token with repo access
PR_API="https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/pulls"

# -------- Fetch PRs --------
echo "📥 Validating PRs for repository: $GITHUB_OWNER/$GITHUB_REPO"
response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$PR_API")
pr_count=$(echo "$response" | jq length)

if [[ "$pr_count" -eq 0 ]]; then
    echo "✅ No open pull requests found."
    exit 0
fi

# -------- Loop through PRs --------
for (( i=0; i<pr_count; i++ )); do
    echo "-----------------------------------------"

    pr_number=$(echo "$response" | jq -r ".[$i].number")
    pr_title=$(echo "$response" | jq -r ".[$i].title")
    pr_body=$(echo "$response" | jq -r ".[$i].body")
    pr_user=$(echo "$response" | jq -r ".[$i].user.login")
    pr_draft=$(echo "$response" | jq -r ".[$i].draft")
    pr_labels=$(echo "$response" | jq -r ".[$i].labels | length")
    pr_url=$(echo "$response" | jq -r ".[$i].html_url")

    echo "🔎 PR #$pr_number by @$pr_user"
    echo "🔗 $pr_url"
    echo "📝 Title: $pr_title"

    # --- Title Check ---
    if [[ "$pr_title" =~ ^[A-Z] ]]; then
        echo "✅ Title starts with a capital letter."
    else
        echo "❌ Title should start with a capital letter."
    fi

    # --- Description Check ---
    if [[ -n "$pr_body" && "${#pr_body}" -ge 20 ]]; then
        echo "✅ PR has a valid description."
    else
        echo "❌ PR description is missing or too short."
    fi

    # --- Label Check ---
    if [[ "$pr_labels" -ge 1 ]]; then
        echo "✅ Labels present."
    else
        echo "❌ No labels found."
    fi

    # --- Draft Check ---
    if [[ "$pr_draft" == "true" ]]; then
        echo "❌ PR is still a draft."
    else
        echo "✅ PR is ready for review."
    fi

done

echo "-----------------------------------------"
echo "📬 PR Validation complete."

