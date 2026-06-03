#!/usr/bin/env bash
set -euo pipefail
REPO_NAME="${1:-afrizone-dashboard}"

if command -v gh >/dev/null 2>&1; then
  GH_BIN="$(command -v gh)"
elif [ -x /opt/data/bin/gh ]; then
  GH_BIN="/opt/data/bin/gh"
else
  echo "gh CLI is required. Expected on PATH or at /opt/data/bin/gh" >&2
  exit 1
fi

if ! "$GH_BIN" auth status >/dev/null 2>&1; then
  echo "gh is not authenticated. Run: $GH_BIN auth login" >&2
  exit 1
fi

cd "$(dirname "$0")"
if [ ! -d .git ]; then
  git init
  git checkout -b main
fi

git add index.html README.md
if ! git diff --cached --quiet; then
  git commit -m "Publish Afrizone dashboard"
fi

if ! "$GH_BIN" repo view "$REPO_NAME" >/dev/null 2>&1; then
  "$GH_BIN" repo create "$REPO_NAME" --public --source . --remote origin --push
else
  if ! git remote get-url origin >/dev/null 2>&1; then
    USERNAME=$("$GH_BIN" api user --jq .login)
    git remote add origin "https://github.com/$USERNAME/$REPO_NAME.git"
  fi
  git push -u origin main
fi

USERNAME=$("$GH_BIN" api user --jq .login)
set +e
"$GH_BIN" api -X POST "repos/$USERNAME/$REPO_NAME/pages" -f source[branch]=main -f source[path]=/
RC=$?
set -e
if [ $RC -ne 0 ]; then
  echo "Pages may already be enabled; continuing."
fi

echo "Site URL: https://$USERNAME.github.io/$REPO_NAME/"
