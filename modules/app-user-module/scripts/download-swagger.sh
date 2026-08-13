#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/../docker/openapi/www/swagger-ui"
SWAGGER_UI_VERSION="${SWAGGER_UI_VERSION:-5.31.0}"
BASE_URL="https://unpkg.com/swagger-ui-dist@${SWAGGER_UI_VERSION}"

mkdir -p "${OUTPUT_DIR}"
curl -fsSL "${BASE_URL}/swagger-ui-bundle.js" -o "${OUTPUT_DIR}/swagger-ui-bundle.js"
curl -fsSL "${BASE_URL}/swagger-ui-standalone-preset.js" -o "${OUTPUT_DIR}/swagger-ui-standalone-preset.js"
curl -fsSL "${BASE_URL}/swagger-ui.css" -o "${OUTPUT_DIR}/swagger-ui.css"

