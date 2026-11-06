#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
APPLICATION_DIR="${ROOT_DIR}/application"
DIST_DIR="${ROOT_DIR}/dist"
ENV_EXAMPLE="${ROOT_DIR}/deployment/.env.example"

EXECUTABLES=(Server Migrator Worker WebApp WebStatic)

usage() {
    cat <<'EOF'
Usage:
    deployment/dist.sh

Builds the five application executables in release mode and stages a
deployable distribution under ./dist.

Options:
    --release   Build release products (the default).
    --debug     Build debug products.
    --shared-swift-runtime
                Do not statically link Swift's standard library. Stage the
                Swift shared libraries under ./dist/swift-runtime.
    -h, --help  Show this help.

Requires Swift and produces artifacts for the current platform.
EOF
}

BUILD_CONFIGURATION="release"
SWIFT_RUNTIME_MODE="static"
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --release)
            BUILD_CONFIGURATION="release"
            shift
            ;;
        --debug)
            BUILD_CONFIGURATION="debug"
            shift
            ;;
        --shared-swift-runtime)
            SWIFT_RUNTIME_MODE="shared"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "error: unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

require_command() {
    local command_name="$1"
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "error: ${command_name} is required" >&2
        exit 1
    fi
}

stage_environment_example() {
    if [[ ! -f "${ENV_EXAMPLE}" ]]; then
        echo "error: missing ${ENV_EXAMPLE}" >&2
        exit 1
    fi

    cp -a "${ENV_EXAMPLE}" "${DIST_DIR}/feather.env"
}

stage_shared_swift_runtime() {
    local runtime_path
    runtime_path="$(swiftc -print-target-info | sed -n '/"runtimeLibraryPaths"/,/]/p' | sed -n 's/.*"\(\/[^"\\]*\)".*/\1/p' | head -n 1)"

    if [[ -z "${runtime_path}" || ! -d "${runtime_path}" ]]; then
        echo "error: could not locate Swift shared runtime libraries" >&2
        echo "       swiftc -print-target-info did not provide a runtime path" >&2
        exit 1
    fi

    mkdir -p "${DIST_DIR}/swift-runtime"
    while IFS= read -r -d '' runtime_library; do
        cp -a "${runtime_library}" "${DIST_DIR}/swift-runtime/"
    done < <(
        find "${runtime_path}" -maxdepth 1 \
            \( -type f -o -type l \) \
            \( -name '*.so' -o -name '*.so.*' \) \
            -print0
    )

    local first_runtime_library
    first_runtime_library="$(find "${DIST_DIR}/swift-runtime" -maxdepth 1 \
        \( -name '*.so' -o -name '*.so.*' \) -print -quit)"
    if [[ -z "${first_runtime_library}" ]]; then
        echo "error: no Swift shared runtime libraries found in ${runtime_path}" >&2
        exit 1
    fi

    echo "Swift shared runtime: ${DIST_DIR}/swift-runtime"
}

stage_distribution() {
    require_command swift

    echo "Building Swift ${BUILD_CONFIGURATION} products..."
    local swift_build_options=(
        --package-path "${APPLICATION_DIR}"
        --configuration "${BUILD_CONFIGURATION}"
        --disable-automatic-resolution
        --manifest-cache local
    )
    if [[ "${SWIFT_RUNTIME_MODE}" == "static" ]]; then
        swift_build_options+=(--static-swift-stdlib)
    fi

    swift build "${swift_build_options[@]}"

    local bin_path
    bin_path="$(swift build \
        --package-path "${APPLICATION_DIR}" \
        --configuration "${BUILD_CONFIGURATION}" \
        --show-bin-path \
        --disable-automatic-resolution \
        --manifest-cache local)"

    mkdir -p "${DIST_DIR}/backend" "${DIST_DIR}/web-app" "${DIST_DIR}/web-static/public"

    local destination
    for executable in "${EXECUTABLES[@]}"; do
        if [[ ! -x "${bin_path}/${executable}" ]]; then
            echo "error: ${BUILD_CONFIGURATION} executable was not produced: ${bin_path}/${executable}" >&2
            exit 1
        fi

        case "${executable}" in
            Server|Migrator|Worker)
                destination="${DIST_DIR}/backend"
                ;;
            WebApp)
                destination="${DIST_DIR}/web-app"
                ;;
            WebStatic)
                destination="${DIST_DIR}/web-static"
                ;;
        esac
        cp -a "${bin_path}/${executable}" "${destination}/"
    done

    local bundle
    while IFS= read -r -d '' bundle; do
        cp -a "${bundle}" "${DIST_DIR}/web-app/"
    done < <(
        find "${bin_path}" -maxdepth 1 \
            \( -name '*.resources' -o -name '*.bundle' \) \
            -print0
    )

    mkdir -p "${DIST_DIR}/web-app/application_WebApp.resources"
    cp -a \
        "${APPLICATION_DIR}/Sources/WebApp/Resources/Templates/." \
        "${DIST_DIR}/web-app/application_WebApp.resources/"

    cp -a "${APPLICATION_DIR}/public/." "${DIST_DIR}/web-static/public/"

    if [[ "${SWIFT_RUNTIME_MODE}" == "shared" ]]; then
        stage_shared_swift_runtime
    fi
}

rm -rf -- "${DIST_DIR}"
mkdir -p "${DIST_DIR}"

stage_distribution

stage_environment_example

echo "Distribution written to ${DIST_DIR}"
echo "Backend executables: ${DIST_DIR}/backend"
echo "Web application: ${DIST_DIR}/web-app"
echo "Static server and public files: ${DIST_DIR}/web-static"
echo "Environment file: ${DIST_DIR}/feather.env"
