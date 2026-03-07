#!/bin/bash
# ============================================================
# Script Name:  http-check.sh
# Description:  Fires a request to a URL and shows status
#               code, response time, headers, and a body
#               preview. No Proxyman or Charles needed for
#               quick checks.
#               Replaces: Proxyman, RapidAPI, Paw (basic use)
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/http-check.sh
# Usage:        http-check.sh <url> [GET|POST|HEAD] [body]
# ============================================================

URL=$1
METHOD=${2:-GET}
BODY=$3

if [ -z "$URL" ]; then
  echo "Usage: http-check.sh <url> [method] [body]"
  exit 1
fi

echo "🌐 $METHOD $URL"
echo ""

if [ "$METHOD" = "POST" ] && [ -n "$BODY" ]; then
  RESPONSE=$(curl -s -o /tmp/clyde_http_body \
    -w "%{http_code}|%{time_total}|%{size_download}|%{content_type}" \
    -X POST -d "$BODY" \
    -H "Content-Type: application/json" \
    -D /tmp/clyde_http_headers \
    "$URL")
else
  RESPONSE=$(curl -s -o /tmp/clyde_http_body \
    -w "%{http_code}|%{time_total}|%{size_download}|%{content_type}" \
    -X "$METHOD" \
    -D /tmp/clyde_http_headers \
    "$URL")
fi

STATUS=$(echo "$RESPONSE" | cut -d'|' -f1)
TIME=$(echo "$RESPONSE" | cut -d'|' -f2)
SIZE=$(echo "$RESPONSE" | cut -d'|' -f3)
CTYPE=$(echo "$RESPONSE" | cut -d'|' -f4)

# Color status code
if [[ "$STATUS" -ge 200 && "$STATUS" -lt 300 ]]; then
  STATUS_LABEL="✅ $STATUS"
elif [[ "$STATUS" -ge 300 && "$STATUS" -lt 400 ]]; then
  STATUS_LABEL="↪️  $STATUS"
else
  STATUS_LABEL="❌ $STATUS"
fi

echo "Status:        $STATUS_LABEL"
echo "Response time: ${TIME}s"
echo "Size:          ${SIZE} bytes"
echo "Content-Type:  $CTYPE"
echo ""
echo "--- Headers ---"
cat /tmp/clyde_http_headers
echo ""
echo "--- Body Preview ---"
cat /tmp/clyde_http_body | head -c 500
echo ""
