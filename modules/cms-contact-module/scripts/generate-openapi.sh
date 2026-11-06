#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORKSPACE_DIR="$(cd "${MODULE_DIR}/../.." && pwd)"
SWIFT_OPENAPI_GENERATOR_VERSION="${SWIFT_OPENAPI_GENERATOR_VERSION:-1.14.3}"
SWIFT_OPENAPI_GENERATOR_BIN="${SWIFT_OPENAPI_GENERATOR_BIN:-}"
OPENAPI_GENERATOR_CONFIG_PATH="${OPENAPI_GENERATOR_CONFIG_PATH:-${SCRIPT_DIR}/openapi-generator-config.yml}"

GENERATOR_TARGETS=("ContactAppOpenAPIGenerator" "ContactAdminOpenAPIGenerator")
SPECIFICATIONS=("contact-app.yaml" "contact-admin.yaml")
OUTPUT_DIRECTORIES=("Sources/APIs/App" "Sources/APIs/Admin")

ensure_swift_openapi_generator_bin() {
    if [[ -n "${SWIFT_OPENAPI_GENERATOR_BIN}" ]]; then
        if ! command -v "${SWIFT_OPENAPI_GENERATOR_BIN}" >/dev/null 2>&1; then
            printf 'swift-openapi-generator binary not found: %s\n' \
                "${SWIFT_OPENAPI_GENERATOR_BIN}" >&2
            exit 1
        fi
    elif ! command -v mint >/dev/null 2>&1; then
        printf 'Mint is required to run swift-openapi-generator %s\n' \
            "${SWIFT_OPENAPI_GENERATOR_VERSION}" >&2
        exit 1
    fi
}

run_swift_openapi_generator() {
    if [[ -n "${SWIFT_OPENAPI_GENERATOR_BIN}" ]]; then
        "${SWIFT_OPENAPI_GENERATOR_BIN}" "$@"
    else
        mint run "apple/swift-openapi-generator@${SWIFT_OPENAPI_GENERATOR_VERSION}" \
            swift-openapi-generator "$@"
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
        run_swift_openapi_generator generate \
            --config "${OPENAPI_GENERATOR_CONFIG_PATH}" \
            --output-directory "${MODULE_DIR}/${OUTPUT_DIRECTORIES[${index}]}" \
            "${MODULE_DIR}/openapi/${SPECIFICATIONS[${index}]}"
    done

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
