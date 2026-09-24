#!/usr/bin/env bash

set -euo pipefail

OPENAPI_DIRECTORY="${1:?Usage: normalize-openapi-generated.sh <openapi-directory>}"
MODULE_DIRECTORY="$(cd "${OPENAPI_DIRECTORY}/../.." && pwd)"
MODULE_NAME="$(basename "${MODULE_DIRECTORY}")"
MODULE_NAME="${MODULE_NAME%-module}"
MODULE_NAME="$(printf '%s' "${MODULE_NAME}" | awk -F- '{ for (i = 1; i <= NF; i++) printf "%s%s", toupper(substr($i, 1, 1)), substr($i, 2) }')"
DUMMY_FUNCTION_NAME="unsafeOpenAPIGenerationHotfixFor${MODULE_NAME}Module"

if [[ ! -d "${OPENAPI_DIRECTORY}" ]]; then
    printf 'OpenAPI directory does not exist: %s\n' "${OPENAPI_DIRECTORY}" >&2
    exit 1
fi

find "${OPENAPI_DIRECTORY}" -type f -name '*.swift' -exec perl -pi -e '
    s/^\@preconcurrency public import struct Foundation\.(URL|Data|Date)$/\@preconcurrency \@unsafe public import struct Foundation.$1/;
    s/^\@preconcurrency import struct Foundation\.(URL|Data|Date)$/\@preconcurrency \@unsafe import struct Foundation.$1/;
' {} +

while IFS= read -r -d '' swift_file; do
    relative_file="${swift_file#${OPENAPI_DIRECTORY}/}"
    file_name="$(printf '%s' "${relative_file%.swift}" | awk -F'[/+_-]' '{ for (i = 1; i <= NF; i++) printf "%s%s", toupper(substr($i, 1, 1)), substr($i, 2) }')"
    dummy_function_name="unsafeOpenAPIGenerationHotfixFor${MODULE_NAME}Module${file_name}"

    DUMMY_FUNCTION_NAME="${dummy_function_name}" perl -0pi -e '
        s/\n\/\/ swift-openapi-generator dummy public import compatibility\npublic func unsafeOpenAPIGenerationHotfixFor[A-Za-z0-9_]+\(\n    _ url: Foundation\.URL,\n    _ data: Foundation\.Data,\n    _ date: Foundation\.Date,\n    _ runtimeConfiguration: OpenAPIRuntime\.Configuration\n\) \{\n    fatalError\(\)\n\}\n?//g;
        $_ .= "\n// swift-openapi-generator dummy public import compatibility\n" .
            "public func $ENV{DUMMY_FUNCTION_NAME}(\n" .
            "    _ url: Foundation.URL,\n" .
            "    _ data: Foundation.Data,\n" .
            "    _ date: Foundation.Date,\n" .
            "    _ runtimeConfiguration: OpenAPIRuntime.Configuration\n" .
            ") {\n" .
            "    fatalError()\n" .
            "}\n";
    ' "${swift_file}"
done < <(find "${OPENAPI_DIRECTORY}" -type f -name '*.swift' ! -name 'Placeholder.swift' -print0)
