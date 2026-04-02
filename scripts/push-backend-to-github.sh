#!/usr/bin/env bash
# Push expriy-deals-backend/ to expirydeals7/Expirydealsbackend on branch sync/from-monorepo.
# Open the printed PR link, review, merge to main, then deploy the server from backend main.
#
# Usage:
#   ./scripts/push-backend-to-github.sh           # split from local main
#   ./scripts/push-backend-to-github.sh main      # explicit ref (branch or commit)
#
# Env overrides:
#   BACKEND_REMOTE_NAME   default: expirydealsbackend
#   BACKEND_SYNC_BRANCH   default: sync/from-monorepo

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

REMOTE="${BACKEND_REMOTE_NAME:-expirydealsbackend}"
SYNC_BRANCH="${BACKEND_SYNC_BRANCH:-sync/from-monorepo}"
PREFIX="expriy-deals-backend"
SOURCE_REF="${1:-main}"

if ! git remote get-url "$REMOTE" &>/dev/null; then
  echo "Remote '$REMOTE' is missing. Add it with:"
  echo "  git remote add $REMOTE https://github.com/expirydeals7/Expirydealsbackend.git"
  exit 1
fi

if ! git rev-parse --verify "$SOURCE_REF" &>/dev/null; then
  echo "Unknown ref: $SOURCE_REF"
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Note: You have uncommitted changes. The subtree split only includes commits already in history (ref: $SOURCE_REF)."
fi

echo "Splitting subtree '$PREFIX' from '$SOURCE_REF' (may take a minute)..."
SPLIT="$(git subtree split --prefix="$PREFIX" "$SOURCE_REF")"

echo "Updating $REMOTE/$SYNC_BRANCH (force: this branch is only for monorepo → backend sync)..."
git push "$REMOTE" "$SPLIT:refs/heads/$SYNC_BRANCH" --force

OWNER_REPO="expirydeals7/Expirydealsbackend"
echo ""
echo "Next: open a PR into main, merge when ready, then pull on the server:"
echo "  https://github.com/${OWNER_REPO}/pull/new/${SYNC_BRANCH}"
echo ""
echo "One-time GitHub setup: protect main on ${OWNER_REPO} (require PR, no direct pushes)."
