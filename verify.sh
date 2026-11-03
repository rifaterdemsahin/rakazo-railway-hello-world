#!/usr/bin/env bash
# 🔍 Verify a deployed hello world the way an outsider sees it.
# Usage: ./verify.sh [url] [expected-body]
set -uo pipefail

URL="${1:-https://hello-world-app-production-a689.up.railway.app}"
EXPECTED="${2:-Hello World from Railway}"

if ! command -v curl >/dev/null 2>&1; then
  echo "❌ curl is required" >&2
  exit 2
fi

echo "🌍 url     : $URL"
echo "💬 expected: $EXPECTED"

BODY_FILE="$(mktemp)"
STATUS="$(curl -fsS -o "$BODY_FILE" -w '%{http_code}' --max-time 20 "$URL" 2>/dev/null)"
CURL_RC=$?
BODY="$(tr -d '\n' < "$BODY_FILE")"
rm -f "$BODY_FILE"

if [ "$CURL_RC" -ne 0 ]; then
  echo "❌ request failed (curl exit $CURL_RC) — service down, DNS wrong, or no public domain"
  exit 1
fi

echo "📡 status  : $STATUS"
echo "📦 body    : $BODY"

if [ "$STATUS" != "200" ]; then
  echo "❌ expected HTTP 200"
  exit 1
fi

if [ "$BODY" != "$EXPECTED" ]; then
  echo "❌ body mismatch — the app is up but not the one you meant to deploy"
  exit 1
fi

echo "✅ PASS — live, 200, and serving the intended body"
