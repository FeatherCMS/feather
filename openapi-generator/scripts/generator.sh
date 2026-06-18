#!/bin/bash

set -euo pipefail

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENAPI_GENERATOR_DIR="$(cd "${SCRIPTS_DIR}/.." && pwd)"
WORKSPACE_DIR="$(cd "${OPENAPI_GENERATOR_DIR}/.." && pwd)"
OPENAPI_PACKAGE_DIR="${OPENAPI_PACKAGE_DIR:-${WORKSPACE_DIR}/openapi}"

SWIFT_OPENAPI_GENERATOR_GIT_URL="${SWIFT_OPENAPI_GENERATOR_GIT_URL:-https://github.com/apple/swift-openapi-generator}"
SWIFT_OPENAPI_GENERATOR_GIT_TAG="${SWIFT_OPENAPI_GENERATOR_GIT_TAG:-1.10.4}"
SWIFT_OPENAPI_GENERATOR_CLONE_DIR="${SWIFT_OPENAPI_GENERATOR_CLONE_DIR:-${OPENAPI_PACKAGE_DIR}/.swift-openapi-generator}"
SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION="${SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION:-debug}"
SWIFT_OPENAPI_GENERATOR_BIN="${SWIFT_OPENAPI_GENERATOR_BIN:-${SWIFT_OPENAPI_GENERATOR_CLONE_DIR}/.build/${SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION}/swift-openapi-generator}"

OPENAPI_YAML_DIRECTORY="${OPENAPI_YAML_DIRECTORY:-${OPENAPI_PACKAGE_DIR}/openapi}"
OPENAPI_APP_YAML_PATH="${OPENAPI_APP_YAML_PATH:-${OPENAPI_YAML_DIRECTORY}/app.yaml}"
OPENAPI_ADMIN_YAML_PATH="${OPENAPI_ADMIN_YAML_PATH:-${OPENAPI_YAML_DIRECTORY}/admin.yaml}"
OPENAPI_GENERATOR_CONFIG_PATH="${OPENAPI_GENERATOR_CONFIG_PATH:-${OPENAPI_PACKAGE_DIR}/openapi-generator-config.yaml}"
APP_OUTPUT_DIRECTORY="${APP_OUTPUT_DIRECTORY:-${OPENAPI_PACKAGE_DIR}/Sources/AppOpenAPI}"
MANAGEMENT_OUTPUT_DIRECTORY="${MANAGEMENT_OUTPUT_DIRECTORY:-${OPENAPI_PACKAGE_DIR}/Sources/AdminOpenAPI}"

SWAGGER_UI_URL="${SWAGGER_UI_URL:-https://cdn.jsdelivr.net/npm/swagger-ui-dist}"
SWAGGER_UI_VERSION="${SWAGGER_UI_VERSION:-5.31.0}"
SWAGGER_UI_PATH="${SWAGGER_UI_PATH:-${OPENAPI_PACKAGE_DIR}/swagger-ui}"
SWAGGER_UI_JS_PATH="${SWAGGER_UI_JS_PATH:-${SWAGGER_UI_PATH}/bundle.min.js}"
SWAGGER_UI_CSS_PATH="${SWAGGER_UI_CSS_PATH:-${SWAGGER_UI_PATH}/min.css}"

ensure_directory() {
    mkdir -p "$1"
}

confirm_delete() {
    local path="$1"
    printf 'Delete %s? [y/N] ' "$path"
    read -r answer
    if [[ "${answer:-N}" != "y" ]]; then
        echo "Aborted"
        exit 1
    fi
}

ensure_swift_openapi_generator_checkout() {
    if [[ -d "${SWIFT_OPENAPI_GENERATOR_CLONE_DIR}" ]]; then
        return
    fi
    git \
        -c advice.detachedHead=false \
        clone \
        --branch "${SWIFT_OPENAPI_GENERATOR_GIT_TAG}" \
        --depth 1 \
        "${SWIFT_OPENAPI_GENERATOR_GIT_URL}" \
        "${SWIFT_OPENAPI_GENERATOR_CLONE_DIR}"
}

ensure_swift_openapi_generator_bin() {
    ensure_swift_openapi_generator_checkout
    if [[ -x "${SWIFT_OPENAPI_GENERATOR_BIN}" ]]; then
        return
    fi
    swift \
        build \
        --package-path "${SWIFT_OPENAPI_GENERATOR_CLONE_DIR}" \
        --configuration "${SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION}" \
        --product swift-openapi-generator
}

generate_app() {
    ensure_swift_openapi_generator_bin
    ensure_directory "${APP_OUTPUT_DIRECTORY}"
    "${SWIFT_OPENAPI_GENERATOR_BIN}" generate \
        --config "${OPENAPI_GENERATOR_CONFIG_PATH}" \
        --output-directory "${APP_OUTPUT_DIRECTORY}" \
        "${OPENAPI_APP_YAML_PATH}"
}

generate_management() {
    ensure_swift_openapi_generator_bin
    ensure_directory "${MANAGEMENT_OUTPUT_DIRECTORY}"
    "${SWIFT_OPENAPI_GENERATOR_BIN}" generate \
        --config "${OPENAPI_GENERATOR_CONFIG_PATH}" \
        --output-directory "${MANAGEMENT_OUTPUT_DIRECTORY}" \
        "${OPENAPI_ADMIN_YAML_PATH}"
}

generate_yaml() {
    ensure_directory "${OPENAPI_YAML_DIRECTORY}"
    (
        cd "${OPENAPI_GENERATOR_DIR}"
        swift run AppOpenAPIGenerator
        swift run AdminOpenAPIGenerator
    )
}

download_swagger_ui() {
    ensure_directory "${SWAGGER_UI_PATH}"
    if [[ ! -f "${SWAGGER_UI_JS_PATH}" ]]; then
        curl -fLs "${SWAGGER_UI_URL}@${SWAGGER_UI_VERSION}/swagger-ui-bundle.min.js" -o "${SWAGGER_UI_JS_PATH}"
    fi
    if [[ ! -f "${SWAGGER_UI_CSS_PATH}" ]]; then
        curl -fLs "${SWAGGER_UI_URL}@${SWAGGER_UI_VERSION}/swagger-ui.min.css" -o "${SWAGGER_UI_CSS_PATH}"
    fi
}

print_help() {
    cat <<EOF
Run ${SCRIPT_PATH} with one of the following targets:

  help                Display this help.
  run                 Run the generators to create YAML files and Swift sources.
  generate            Generate app and admin OpenAPI sources.
  generate-app        Generate app OpenAPI sources.
  generate-admin      Generate admin OpenAPI sources.
  yaml                Generate OpenAPI YAML files.
  swagger-ui          Download Swagger UI assets.
  build               Run swift build.
  release             Run swift build in release mode.
  clean               Delete generated Swift output directories.
  clean-all           Clean generated outputs, generator checkout, Swagger UI, and YAML files.
  dump                Dump all derived values used by the script.

The following environment variables can be overridden:

  SWIFT_OPENAPI_GENERATOR_GIT_URL
  SWIFT_OPENAPI_GENERATOR_GIT_TAG
  SWIFT_OPENAPI_GENERATOR_CLONE_DIR
  SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION
  SWIFT_OPENAPI_GENERATOR_BIN
  OPENAPI_PACKAGE_DIR
  OPENAPI_YAML_DIRECTORY
  OPENAPI_APP_YAML_PATH
  OPENAPI_MANAGEMENT_YAML_PATH
  OPENAPI_GENERATOR_CONFIG_PATH
  APP_OUTPUT_DIRECTORY
  MANAGEMENT_OUTPUT_DIRECTORY
  SWAGGER_UI_URL
  SWAGGER_UI_VERSION
  SWAGGER_UI_PATH
  SWAGGER_UI_JS_PATH
  SWAGGER_UI_CSS_PATH
EOF
}

dump_values() {
    cat <<EOF
SCRIPT_PATH = ${SCRIPT_PATH}
SCRIPTS_DIR = ${SCRIPTS_DIR}
OPENAPI_GENERATOR_DIR = ${OPENAPI_GENERATOR_DIR}
WORKSPACE_DIR = ${WORKSPACE_DIR}
OPENAPI_PACKAGE_DIR = ${OPENAPI_PACKAGE_DIR}
SWIFT_OPENAPI_GENERATOR_GIT_URL = ${SWIFT_OPENAPI_GENERATOR_GIT_URL}
SWIFT_OPENAPI_GENERATOR_GIT_TAG = ${SWIFT_OPENAPI_GENERATOR_GIT_TAG}
SWIFT_OPENAPI_GENERATOR_CLONE_DIR = ${SWIFT_OPENAPI_GENERATOR_CLONE_DIR}
SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION = ${SWIFT_OPENAPI_GENERATOR_BUILD_CONFIGURATION}
SWIFT_OPENAPI_GENERATOR_BIN = ${SWIFT_OPENAPI_GENERATOR_BIN}
OPENAPI_YAML_DIRECTORY = ${OPENAPI_YAML_DIRECTORY}
OPENAPI_APP_YAML_PATH = ${OPENAPI_APP_YAML_PATH}
OPENAPI_MANAGEMENT_YAML_PATH = ${OPENAPI_MANAGEMENT_YAML_PATH}
OPENAPI_GENERATOR_CONFIG_PATH = ${OPENAPI_GENERATOR_CONFIG_PATH}
APP_OUTPUT_DIRECTORY = ${APP_OUTPUT_DIRECTORY}
MANAGEMENT_OUTPUT_DIRECTORY = ${MANAGEMENT_OUTPUT_DIRECTORY}
SWAGGER_UI_URL = ${SWAGGER_UI_URL}
SWAGGER_UI_VERSION = ${SWAGGER_UI_VERSION}
SWAGGER_UI_PATH = ${SWAGGER_UI_PATH}
SWAGGER_UI_JS_PATH = ${SWAGGER_UI_JS_PATH}
SWAGGER_UI_CSS_PATH = ${SWAGGER_UI_CSS_PATH}
EOF
}

main() {
    local command="${1:-help}"
    case "${command}" in
        help)
            print_help
            ;;
        run)
            generate_yaml
            generate_app
            generate_management
            download_swagger_ui
            ;;
        generate)
            generate_app
            generate_management
            ;;
        generate-app)
            generate_app
            ;;
        generate-admin)
            generate_management
            ;;
        yaml)
            generate_yaml
            ;;
        swagger-ui)
            download_swagger_ui
            ;;
        build)
            (
                cd "${OPENAPI_GENERATOR_DIR}"
                swift build
            )
            ;;
        release)
            (
                cd "${OPENAPI_GENERATOR_DIR}"
                swift build -c release
            )
            ;;
        clean)
            confirm_delete "${APP_OUTPUT_DIRECTORY}"
            rm -rf "${APP_OUTPUT_DIRECTORY}"
            confirm_delete "${MANAGEMENT_OUTPUT_DIRECTORY}"
            rm -rf "${MANAGEMENT_OUTPUT_DIRECTORY}"
            ;;
        clean-all)
            confirm_delete "${APP_OUTPUT_DIRECTORY}"
            rm -rf "${APP_OUTPUT_DIRECTORY}"
            confirm_delete "${MANAGEMENT_OUTPUT_DIRECTORY}"
            rm -rf "${MANAGEMENT_OUTPUT_DIRECTORY}"
            confirm_delete "${SWIFT_OPENAPI_GENERATOR_CLONE_DIR}"
            rm -rf "${SWIFT_OPENAPI_GENERATOR_CLONE_DIR}"
            confirm_delete "${SWAGGER_UI_PATH}"
            rm -rf "${SWAGGER_UI_PATH}"
            confirm_delete "${OPENAPI_YAML_DIRECTORY}"
            rm -rf "${OPENAPI_YAML_DIRECTORY}"
            ;;
        dump)
            dump_values
            ;;
        *)
            echo "Unknown target: ${command}" >&2
            print_help >&2
            exit 1
            ;;
    esac
}

main "$@"
