#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:8080}"
EMAIL="${EMAIL:-user@example.com}"
PASSWORD="${PASSWORD:-user}"

echo "POST ${BASE_URL}/v1/app/user/auth/login"
login_response="$(
  curl -sS -i -X POST \
    "${BASE_URL}/v1/app/user/auth/login" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"${EMAIL}\",\"password\":\"${PASSWORD}\",\"isPersistent\":true}"
)"

login_headers="$(printf "%s" "$login_response" | sed '/^\r\{0,1\}$/q')"
login_body="$(printf "%s" "$login_response" | sed '1,/^\r\{0,1\}$/d')"

echo "$login_headers"
echo
printf "%s\n" "$login_body" | jq .

session_cookie="$(
  printf "%s\n" "$login_response" \
    | tr -d '\r' \
    | awk -F': ' 'tolower($1) == "set-cookie" { print $2 }' \
    | sed -E 's/%3[Bb].*$//' \
    | sed 's/;.*$//' \
    | sed -E 's/%3[Dd]/=/g' \
    | head -n 1
)"

if [[ -z "${session_cookie}" ]]; then
  echo "Could not find a session cookie in login response." >&2
  exit 1
fi

echo
echo "GET ${BASE_URL}/v1/app/user/accounts/me"
me_response="$(
  curl -sS -i -X GET \
  "${BASE_URL}/v1/app/user/accounts/me" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "Cookie: ${session_cookie}"
)"

me_headers="$(printf "%s" "$me_response" | sed '/^\r\{0,1\}$/q')"
me_body="$(printf "%s" "$me_response" | sed '1,/^\r\{0,1\}$/d')"

echo "$me_headers"
echo
printf "%s\n" "$me_body" | jq .
