#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${MONKEYTYPE_PORT:-5117}"
HOST="${MONKEYTYPE_HOST:-127.0.0.1}"
BACKEND_URL="${MONKEYTYPE_BACKEND_URL:-https://api.monkeytype.com}"
SERVER_ALLOWED_HOSTS="${MONKEYTYPE_SERVER_ALLOWED_HOSTS:-*}"
BASE_PATH="${MONKEYTYPE_BASE_PATH:-/apps/monkeytype/}"

cd "$ROOT_DIR"

if [ ! -d node_modules ]; then
  echo "[monkeytype] Installing dependencies with pnpm..."
  pnpm install --frozen-lockfile
fi

if [ ! -f packages/schemas/dist/configs.mjs ]; then
  echo "[monkeytype] Building workspace packages required by frontend..."
  pnpm run build-pkg
fi

echo "[monkeytype] Starting frontend on http://${HOST}:${PORT} (base=${BASE_PATH})"
cd frontend
exec env \
  SERVER_OPEN=false \
  BACKEND_URL="$BACKEND_URL" \
  SERVER_ALLOWED_HOSTS="$SERVER_ALLOWED_HOSTS" \
  BASE_PATH="$BASE_PATH" \
  pnpm exec vite dev --host "$HOST" --port "$PORT" --strictPort
