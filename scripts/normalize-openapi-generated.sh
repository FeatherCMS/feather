#!/usr/bin/env bash

set -euo pipefail

OPENAPI_DIRECTORY="${1:?Usage: normalize-openapi-generated.sh <openapi-directory>}"

if [[ ! -d "${OPENAPI_DIRECTORY}" ]]; then
    printf 'OpenAPI directory does not exist: %s\n' "${OPENAPI_DIRECTORY}" >&2
    exit 1
fi

find "${OPENAPI_DIRECTORY}" -type f -name '*.swift' -exec perl -pi -e '
    s/^\@_spi\(Generated\) public import OpenAPIRuntime$/\@_spi(Generated) import OpenAPIRuntime/;
    s/^\@preconcurrency public import struct Foundation\.(URL|Data|Date)$/\@preconcurrency \@unsafe import struct Foundation.$1/;
    s/^\@preconcurrency import struct Foundation\.(URL|Data|Date)$/\@preconcurrency \@unsafe import struct Foundation.$1/;
    s/^public import struct Foundation\.(URL|Data|Date)$/import struct Foundation.$1/;
' {} +
