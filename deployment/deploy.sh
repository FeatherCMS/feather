#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
BUILD_SCRIPT="${SCRIPT_DIR}/dist.sh"
INSTALL_DIR="/opt/feather"
ENV_DIR="/etc/feather"
ENV_FILE="${ENV_DIR}/feather.env"

APPLICATION_SERVICES=(
    feather-server.service
    feather-worker.service
    feather-web-app.service
    feather-web-static.service
)
ALL_SERVICES=(
    feather-migrator.service
    "${APPLICATION_SERVICES[@]}"
)

usage() {
    cat <<'EOF'
Usage:
    deployment/deploy.sh [--release|--debug] [--no-build]

Stops the Feather services, optionally rebuilds the native distribution,
installs the binaries, bundles, public files, environment, and
systemd units, then enables and starts every Feather service except
Migrator.

Options:
    --release   Build release products (the default).
    --debug     Build debug products.
    --shared-swift-runtime
                Build without static Swift runtime linking and deploy the
                shared Swift libraries with the applications.
    --no-build  Deploy the existing ./dist without rebuilding it.
    -h, --help  Show this help.

Migrator is intentionally never started by this script. Run it manually after
deploying when database migrations are required.
EOF
}

BUILD_CONFIGURATION="release"
SWIFT_RUNTIME_MODE="static"
BUILD_DISTRIBUTION="true"
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
        --no-build)
            BUILD_DISTRIBUTION="false"
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

if [[ "${EUID}" -eq 0 ]]; then
    SUDO=()
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "error: sudo is required when deploy.sh is not run as root" >&2
        exit 1
    fi
    SUDO=(sudo)
fi

TEMP_ENV_DIR=""
cleanup() {
    if [[ -n "${TEMP_ENV_DIR}" && -d "${TEMP_ENV_DIR}" ]]; then
        rm -rf -- "${TEMP_ENV_DIR}"
    fi
}
trap cleanup EXIT

stop_services() {
    echo "Stopping Feather services..."
    for service in "${ALL_SERVICES[@]}"; do
        "${SUDO[@]}" systemctl stop "${service}" >/dev/null 2>&1 || true
    done
}

require_distribution_file() {
    local relative_path="$1"
    local absolute_path="${DIST_DIR}/${relative_path}"
    if [[ ! -e "${absolute_path}" ]]; then
        echo "error: missing distribution file: ${absolute_path}" >&2
        exit 1
    fi
}

preserve_environment() {
    local source_environment=""
    if [[ -f "${ENV_FILE}" ]]; then
        source_environment="${ENV_FILE}"
    elif [[ -f "${DIST_DIR}/feather.env" ]]; then
        source_environment="${DIST_DIR}/feather.env"
    fi

    if [[ -n "${source_environment}" ]]; then
        TEMP_ENV_DIR="$(mktemp -d "${TMPDIR:-/tmp}/feather-deploy.XXXXXX")"
        cp -a "${source_environment}" "${TEMP_ENV_DIR}/feather.env"
    fi
}

restore_environment() {
    if [[ -n "${TEMP_ENV_DIR}" && -f "${TEMP_ENV_DIR}/feather.env" ]]; then
        cp -a "${TEMP_ENV_DIR}/feather.env" "${DIST_DIR}/feather.env"
    fi
}

install_systemd_units() {
    local unit
    local installed_name
    for unit in "${SCRIPT_DIR}"/systemd/*.service.example; do
        installed_name="$(basename "${unit%.example}")"
        "${SUDO[@]}" install -o root -g root -m 0644 \
            "${unit}" \
            "/etc/systemd/system/${installed_name}"
    done
}

stop_services
preserve_environment

if [[ "${BUILD_DISTRIBUTION}" == "true" ]]; then
    echo "Building ${BUILD_CONFIGURATION} distribution..."
    BUILD_OPTIONS=("--${BUILD_CONFIGURATION}")
    if [[ "${SWIFT_RUNTIME_MODE}" == "shared" ]]; then
        BUILD_OPTIONS+=(--shared-swift-runtime)
    fi
    "${BUILD_SCRIPT}" "${BUILD_OPTIONS[@]}"
fi
restore_environment

require_distribution_file "feather.env"
for executable in \
    backend/Server \
    backend/Migrator \
    backend/Worker \
    web-app/WebApp \
    web-static/WebStatic
do
    require_distribution_file "${executable}"
done

echo "Installing distribution at ${INSTALL_DIR}..."
"${SUDO[@]}" install -d -o feather -g feather "${INSTALL_DIR}"
"${SUDO[@]}" cp -a "${DIST_DIR}/." "${INSTALL_DIR}/"
"${SUDO[@]}" chown -R feather:feather "${INSTALL_DIR}"
"${SUDO[@]}" chmod 0640 "${INSTALL_DIR}/feather.env"

"${SUDO[@]}" install -d -o root -g feather -m 0750 "${ENV_DIR}"
"${SUDO[@]}" install -o root -g feather -m 0640 \
    "${DIST_DIR}/feather.env" \
    "${ENV_FILE}"

install_systemd_units
"${SUDO[@]}" systemctl daemon-reload
"${SUDO[@]}" systemctl disable feather-migrator.service >/dev/null 2>&1 || true

echo "Starting Feather services (Migrator is intentionally excluded)..."
"${SUDO[@]}" systemctl enable "${APPLICATION_SERVICES[@]}"
"${SUDO[@]}" systemctl start "${APPLICATION_SERVICES[@]}"

echo "Deployment complete. Migrator can be run manually with:"
echo "  sudo systemctl start feather-migrator.service"
