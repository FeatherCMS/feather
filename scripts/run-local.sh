#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CMS_ROOT="$(cd "$ROOT_DIR/.." && pwd)"
APPLICATION_DIR="$ROOT_DIR/application"
FEATHER_APPLICATION_DIR="$CMS_ROOT/feather/application"
AVA_APPLICATION_DIR="$CMS_ROOT/ava/application"
COMPOSE=(docker compose --project-directory "$ROOT_DIR" -f "$ROOT_DIR/docker-compose.yaml")
MODE="${1:-all}"
CERT_VOLUME="feather-cms-certificates"
CERT_DIR="$ROOT_DIR/.docker/certs"

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
}

stop_existing_local_instances() {
    local app_dir process_name pid executable attempt line state
    local -a pids=()

    echo "Stopping existing local application processes..."
    while IFS= read -r line; do
        read -r pid executable _ <<< "$line"
        [[ -n "$pid" && -n "$executable" ]] || continue
        for app_dir in "$FEATHER_APPLICATION_DIR" "$AVA_APPLICATION_DIR"; do
            case "$executable" in
                "$app_dir"/.build/*) ;;
                *) continue ;;
            esac
            process_name="${executable##*/}"
            case "$process_name" in
                WebApp|WebStatic|Static|Server|Worker)
                    echo "Stopping existing $process_name instance (PID $pid)..."
                    kill -TERM "$pid" 2>/dev/null || true
                    pids+=("$pid")
                    break
                    ;;
            esac
        done
    done < <(ps -axo pid=,command=)

    for attempt in {1..50}; do
        local running=0
        for pid in "${pids[@]}"; do
            state="$(ps -p "$pid" -o stat= 2>/dev/null | tr -d ' ' || true)"
            if [[ -n "$state" && "$state" != Z* ]]; then
                running=1
                break
            fi
        done
        (( running == 0 )) && break
        sleep 0.1
    done

    for pid in "${pids[@]}"; do
        state="$(ps -p "$pid" -o stat= 2>/dev/null | tr -d ' ' || true)"
        if [[ -n "$state" && "$state" != Z* ]]; then
            echo "Force-stopping unresponsive local process (PID $pid)..."
            kill -KILL "$pid" 2>/dev/null || true
        fi
    done
}

check_port_available() {
    local port="$1"
    local service="$2"
    local pids

    command -v lsof >/dev/null || return 0
    pids="$(lsof -nP -t -iTCP:"$port" -sTCP:LISTEN 2>/dev/null | sort -u || true)"
    [[ -z "$pids" ]] && return 0

    echo "Cannot start local $service: TCP port $port is already in use." >&2
    lsof -nP -iTCP:"$port" -sTCP:LISTEN >&2 || true
    echo "Docker services were left running. Stop or reconfigure the service using this port, then retry." >&2
    return 1
}

ensure_compose_service_running() {
    local service="$1"

    if [[ -n "$("${COMPOSE[@]}" ps --status running -q "$service")" ]]; then
        echo "$service is already running; keeping it as-is."
        return
    fi

    echo "Starting $service..."
    "${COMPOSE[@]}" up -d "$service"
}

trap cleanup EXIT INT TERM

command -v docker >/dev/null || { echo "docker is required" >&2; exit 1; }
command -v swift >/dev/null || { echo "swift is required" >&2; exit 1; }

stop_existing_local_instances

mkdir -p "$CERT_DIR"

if [[ -f "$ROOT_DIR/.env" ]]; then
    set -a
    # shellcheck disable=SC1091
    source "$ROOT_DIR/.env"
    set +a
fi

if [[ -s "$CERT_DIR/ca.pem" ]]; then
    echo "PostgreSQL CA certificate is already available; skipping certificate generation."
else
    echo "Generating PostgreSQL certificates in Docker..."
    "${COMPOSE[@]}" up certificates
fi

POSTGRES_WAS_RUNNING=0
if [[ -n "$("${COMPOSE[@]}" ps --status running -q postgres)" ]]; then
    POSTGRES_WAS_RUNNING=1
fi

ensure_compose_service_running postgres
ensure_compose_service_running minio

if [[ "$POSTGRES_WAS_RUNNING" == 1 && -s "$CERT_DIR/ca.pem" ]]; then
    echo "PostgreSQL CA certificate is already exported; skipping copy."
else
    echo "Exporting PostgreSQL CA certificate..."
    docker run --rm \
        -v "$CERT_VOLUME:/from:ro" \
        -v "$CERT_DIR:/to" \
        alpine sh -c 'cp /from/ca.pem /to/ca.pem'
fi

echo "Waiting for PostgreSQL..."
until "${COMPOSE[@]}" exec -T postgres pg_isready -U postgres -d postgres >/dev/null 2>&1; do
    sleep 1
done

echo "Waiting for MinIO..."
until "${COMPOSE[@]}" exec -T minio mc ready local >/dev/null 2>&1; do
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
export STORAGE_S3_ACCESS_KEY_ID="${STORAGE_S3_ACCESS_KEY_ID:-feather-local}"
export STORAGE_S3_SECRET_ACCESS_KEY="${STORAGE_S3_SECRET_ACCESS_KEY:-feather-local-secret-key}"
export STORAGE_S3_REGION="${STORAGE_S3_REGION:-us-east-1}"
export STORAGE_S3_ENDPOINT="${STORAGE_S3_ENDPOINT:-http://127.0.0.1:9000}"
export STORAGE_S3_BUCKET="${STORAGE_S3_BUCKET:-feather-cms-app}"
export STORAGE_OBJECT_KEY_DEPTH="${STORAGE_OBJECT_KEY_DEPTH:-2}"
export STORAGE_OBJECT_KEY_SEGMENT_LENGTH="${STORAGE_OBJECT_KEY_SEGMENT_LENGTH:-2}"
export MEDIA_MAX_CONCURRENT_PROCESSING="${MEDIA_MAX_CONCURRENT_PROCESSING:-1}"
export SERVER_HTTP_HOST="${SERVER_HTTP_HOST:-127.0.0.1}"
export SERVER_HTTP_PORT="${SERVER_HTTP_PORT:-8080}"
export SERVER_QUEUE_NAME="${SERVER_QUEUE_NAME:-feather-cms-worker}"
export WORKER_QUEUE_NAME="${WORKER_QUEUE_NAME:-feather-cms-worker}"
export API_BASE_URL="${API_BASE_URL:-http://127.0.0.1:8080}"
export WEB_PUBLIC_BASE_URL="${WEB_PUBLIC_BASE_URL:-http://127.0.0.1:3456}"
export STATIC_PUBLIC_BASE_URL="${STATIC_PUBLIC_BASE_URL:-http://127.0.0.1:4567}"
export MEDIA_PUBLIC_BASE_URL="${MEDIA_PUBLIC_BASE_URL:-http://127.0.0.1:9000/$STORAGE_S3_BUCKET}"

check_port_available "$SERVER_HTTP_PORT" "Server"
if [[ "$MODE" == "all" ]]; then
    check_port_available 3456 "WebApp"
    check_port_available 4567 "Static"
fi

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

echo "Press Ctrl-C to stop local processes. Docker services will keep running."

wait "$SERVER_PID" "$WORKER_PID" "$WEB_APP_PID" "$STATIC_PID"
