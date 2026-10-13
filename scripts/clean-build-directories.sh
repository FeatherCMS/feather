#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

remove_build_directory() {
    local package_dir="$1"
    local build_dir="${package_dir}/.build"

    if [[ -d "${build_dir}" ]]; then
        rm -rf -- "${build_dir}"
        printf 'Removed %s\n' "${build_dir}"
    fi
}

for module_dir in "${ROOT_DIR}/modules"/*; do
    if [[ -d "${module_dir}" ]]; then
        remove_build_directory "${module_dir}"
    fi
done

remove_build_directory "${ROOT_DIR}/feather-core"
remove_build_directory "${ROOT_DIR}/application"
