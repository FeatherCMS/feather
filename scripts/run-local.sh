#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPLICATION_DIR="$ROOT_DIR/application"
COMPOSE=(docker compose --project-directory "$ROOT_DIR" -f "$ROOT_DIR/docker-compose.yaml")
MODE="${1:-all}"
CERT_VOLUME="feather-cms-certificates"
CERT_DIR="$ROOT_DIR/.docker/certs"
MEDIA_DIR="$ROOT_DIR/.docker/media"

SERVER_PID=""
WORKER_PID=""
WEB_APP_PID=""
STATIC_PID=""

case "$MODE" in
    all|backend) ;;
    *)
        echo "Usage: $0 [all|backend]" >&2
        exit 2
        ;;
esac

cleanup() {
    trap - EXIT INT TERM
    for pid in "$SERVER_PID" "$WORKER_PID" "$WEB_APP_PID" "$STATIC_PID"; do
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null || true
        fi
    done
    wait 2>/dev/null || true
    "${COMPOSE[@]}" stop postgres >/dev/null 2>&1 || true
}

trap cleanup EXIT INT TERM

command -v docker >/dev/null || { echo "docker is required" >&2; exit 1; }
command -v swift >/dev/null || { echo "swift is required" >&2; exit 1; }

mkdir -p "$CERT_DIR" "$MEDIA_DIR"

if [[ -f "$ROOT_DIR/.env" ]]; then
    set -a
    # shellcheck disable=SC1091
    source "$ROOT_DIR/.env"
    set +a
fi

echo "Starting PostgreSQL in Docker..."
"${COMPOSE[@]}" up certificates
"${COMPOSE[@]}" up -d postgres

echo "Exporting PostgreSQL CA certificate..."
docker run --rm \
    -v "$CERT_VOLUME:/from:ro" \
    -v "$CERT_DIR:/to" \
    alpine sh -c 'cp /from/ca.pem /to/ca.pem'

echo "Waiting for PostgreSQL..."
until "${COMPOSE[@]}" exec -T postgres pg_isready -U postgres -d postgres >/dev/null 2>&1; do
    sleep 1
done

echo "Building local application executables..."
swift build --package-path "$APPLICATION_DIR"
BIN_PATH="$(swift build --package-path "$APPLICATION_DIR" --show-bin-path)"

export POSTGRES_HOST="${POSTGRES_HOST:-127.0.0.1}"
export POSTGRES_PORT="${POSTGRES_PORT:-5432}"
export POSTGRES_USER="${POSTGRES_USER:-postgres}"
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-postgres}"
export POSTGRES_DATABASE="${POSTGRES_DATABASE:-postgres}"
export POSTGRES_ROOT_CA_PATH="${POSTGRES_ROOT_CA_PATH:-$CERT_DIR/ca.pem}"
export MEDIA_STORAGE_ROOT_PATH="${MEDIA_STORAGE_ROOT_PATH:-$MEDIA_DIR}"
export SERVER_HTTP_HOST="${SERVER_HTTP_HOST:-127.0.0.1}"
export SERVER_HTTP_PORT="${SERVER_HTTP_PORT:-8080}"
export SERVER_QUEUE_NAME="${SERVER_QUEUE_NAME:-feather-cms-worker}"
export WORKER_QUEUE_NAME="${WORKER_QUEUE_NAME:-feather-cms-worker}"
export API_BASE_URL="${API_BASE_URL:-http://127.0.0.1:8080}"
export WEB_PUBLIC_BASE_URL="${WEB_PUBLIC_BASE_URL:-http://127.0.0.1:3456}"
export STATIC_PUBLIC_BASE_URL="${STATIC_PUBLIC_BASE_URL:-http://127.0.0.1:4567}"
export MEDIA_PUBLIC_BASE_URL="${MEDIA_PUBLIC_BASE_URL:-http://127.0.0.1:8080}"

echo "Running database migrations..."
(
    cd "$APPLICATION_DIR"
    "$BIN_PATH/Migrator"
)

echo "Starting Server and Worker..."
(
    cd "$APPLICATION_DIR"
    exec "$BIN_PATH/Server"
) & SERVER_PID=$!
(
    cd "$APPLICATION_DIR"
    exec "$BIN_PATH/Worker"
) & WORKER_PID=$!

echo "Backend: http://127.0.0.1:8080"

if [[ "$MODE" == "all" ]]; then
    (
        cd "$APPLICATION_DIR"
        exec "$BIN_PATH/WebApp"
    ) & WEB_APP_PID=$!
    (
        cd "$APPLICATION_DIR"
        exec "$BIN_PATH/Static"
    ) & STATIC_PID=$!
    echo "Web app: http://127.0.0.1:3456"
    echo "Static assets: http://127.0.0.1:4567"
fi

echo "Press Ctrl-C to stop local processes and PostgreSQL."

wait "$SERVER_PID" "$WORKER_PID" "$WEB_APP_PID" "$STATIC_PID"
