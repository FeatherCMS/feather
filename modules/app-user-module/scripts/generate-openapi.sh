#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORKSPACE_DIR="$(cd "${MODULE_DIR}/../.." && pwd)"
OPENAPI_PACKAGE_DIR="${OPENAPI_PACKAGE_DIR:-${WORKSPACE_DIR}/scripts}"
SWIFT_OPENAPI_GENERATOR_GIT_URL="${SWIFT_OPENAPI_GENERATOR_GIT_URL:-https://github.com/apple/swift-openapi-generator}"
SWIFT_OPENAPI_GENERATOR_GIT_TAG="${SWIFT_OPENAPI_GENERATOR_GIT_TAG:-1.10.4}"
SWIFT_OPENAPI_GENERATOR_CLONE_DIR="${SWIFT_OPENAPI_GENERATOR_CLONE_DIR:-${OPENAPI_PACKAGE_DIR}/.swift-openapi-generator}"
SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION="${SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION:-debug}"
SWIFT_OPENAPI_GENERATOR_BIN="${SWIFT_OPENAPI_GENERATOR_BIN:-${SWIFT_OPENAPI_GENERATOR_CLONE_DIR}/.build/${SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION}/swift-openapi-generator}"
OPENAPI_GENERATOR_CONFIG_PATH="${OPENAPI_GENERATOR_CONFIG_PATH:-${SCRIPT_DIR}/openapi-generator-config.yml}"

GENERATOR_TARGETS=("UserAppOpenAPIGenerator" "UserAdminOpenAPIGenerator")
SPECIFICATIONS=("user-app.yaml" "user-admin.yaml")
OUTPUT_DIRECTORIES=("Sources/APIs/App" "Sources/APIs/Admin")

ensure_swift_openapi_generator_bin() {
    if [[ ! -d "${SWIFT_OPENAPI_GENERATOR_CLONE_DIR}" ]]; then
        git \
            -c advice.detachedHead=false \
            clone \
            --branch "${SWIFT_OPENAPI_GENERATOR_GIT_TAG}" \
            --depth 1 \
            "${SWIFT_OPENAPI_GENERATOR_GIT_URL}" \
            "${SWIFT_OPENAPI_GENERATOR_CLONE_DIR}"
    fi
    if [[ ! -x "${SWIFT_OPENAPI_GENERATOR_BIN}" ]]; then
        swift \
            build \
            --package-path "${SWIFT_OPENAPI_GENERATOR_CLONE_DIR}" \
            --configuration "${SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION}" \
            --product swift-openapi-generator
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

