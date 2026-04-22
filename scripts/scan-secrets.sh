#!/usr/bin/env bash
# scan-secrets.sh - Block obvious secrets from being committed.
#
# Greps tracked files (excluding this script, .planning/, README.md) for
# common secret patterns. Exits non-zero on any match so it can be wired
# into CI or a pre-commit hook.
#
# Usage:
#   ./scripts/scan-secrets.sh             # scan all tracked files
#   ./scripts/scan-secrets.sh path/...    # scan specific paths

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PATTERNS=(
  # Stripe
  'sk_live_[A-Za-z0-9]{20,}'
  'rk_live_[A-Za-z0-9]{20,}'
  # AWS
  'AKIA[0-9A-Z]{16}'
  'aws_secret_access_key[[:space:]]*=[[:space:]]*[A-Za-z0-9/+=]{40}'
  # GitHub
  'gh[pousr]_[A-Za-z0-9]{30,}'
  # Slack
  'xox[baprs]-[A-Za-z0-9-]{10,}'
  # Generic API key headers
  'api[-_]?key[[:space:]]*[:=][[:space:]]*"[A-Za-z0-9]{32,}"'
  # OpenAI
  'sk-[A-Za-z0-9]{48,}'
  # PEM headers
  '-----BEGIN (RSA|DSA|EC|OPENSSH|PGP) PRIVATE KEY-----'
  # Apple app-specific password (4-4-4-4 lowercase). Only flag when assigned to a known Fastlane var.
  'FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD[[:space:]]*=[[:space:]]*"[a-z]{4}-[a-z]{4}-[a-z]{4}-[a-z]{4}"'
  # P&P identity (matches the email and standalone domain only — not the literal phrase)
  '@pixelandprocess\.de'
  'pixelandprocess\.de[/[:space:]"'\''`]'
)

# Files to scan: tracked by git, minus excludes
EXCLUDE_PATHS=(
  ':!scripts/scan-secrets.sh'
  ':!.planning/**'
  ':!README.md'
  ':!CLAUDE.md'
  ':!.env.example'
)

if [ "$#" -gt 0 ]; then
  FILES=("$@")
else
  mapfile -t FILES < <(git ls-files -- . "${EXCLUDE_PATHS[@]}")
fi

found=0
for pattern in "${PATTERNS[@]}"; do
  if matches=$(grep -nE --color=never "$pattern" "${FILES[@]}" 2>/dev/null); then
    echo "✗ Pattern matched: $pattern"
    echo "$matches" | sed 's/^/    /'
    found=1
  fi
done

if [ "$found" -ne 0 ]; then
  echo ""
  echo "✗ Secret scan FAILED — review and remove the matches above."
  exit 1
fi

echo "✓ Secret scan passed (${#FILES[@]} files, ${#PATTERNS[@]} patterns)."
