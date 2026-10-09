#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORKSPACE_DIR="$(cd "${MODULE_DIR}/../.." && pwd)"
SWIFT_OPENAPI_GENERATOR_BIN="${SWIFT_OPENAPI_GENERATOR_BIN:-swift-openapi-generator}"
OPENAPI_GENERATOR_CONFIG_PATH="${OPENAPI_GENERATOR_CONFIG_PATH:-${SCRIPT_DIR}/openapi-generator-config.yml}"

GENERATOR_TARGETS=("BlogAppOpenAPIGenerator" "BlogAdminOpenAPIGenerator")
SPECIFICATIONS=("blog-app.yaml" "blog-admin.yaml")
OUTPUT_DIRECTORIES=("Sources/APIs/App" "Sources/APIs/Admin")

ensure_swift_openapi_generator_bin() {
    if ! command -v "${SWIFT_OPENAPI_GENERATOR_BIN}" >/dev/null 2>&1; then
        printf 'swift-openapi-generator is required on PATH\n' >&2
        exit 1
    fi
}

generate_yaml() {
    local target
    for target in "${GENERATOR_TARGETS[@]}"; do
        (
            cd "${WORKSPACE_DIR}"
            OPENAPI_WORKSPACE_DIR="${MODULE_DIR}" swift run \
                --package-path "${MODULE_DIR}" \
                "${target}"
        )
    done

}

generate_types() {
    local index
    ensure_swift_openapi_generator_bin
    for index in "${!SPECIFICATIONS[@]}"; do
        mkdir -p "${MODULE_DIR}/${OUTPUT_DIRECTORIES[${index}]}"
        "${SWIFT_OPENAPI_GENERATOR_BIN}" generate \
            --config "${OPENAPI_GENERATOR_CONFIG_PATH}" \
            --output-directory "${MODULE_DIR}/${OUTPUT_DIRECTORIES[${index}]}" \
            "${MODULE_DIR}/openapi/${SPECIFICATIONS[${index}]}"
    done

    "${WORKSPACE_DIR}/scripts/normalize-openapi-generated.sh" \
        "${MODULE_DIR}/Sources/APIs"
}

case "${1:-run}" in
    yaml)
        generate_yaml
        ;;
    openapi|generate)
        generate_types
        ;;
    run)
        generate_yaml
        generate_types
        ;;
    help)
        printf '%s\n' 'Usage: scripts/generate-openapi.sh [yaml|openapi|run]'
        ;;
    *)
        printf 'Unknown command: %s\n' "$1" >&2
        exit 1
        ;;
esac
