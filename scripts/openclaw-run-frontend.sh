#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${MONKEYTYPE_PORT:-5117}"
HOST="${MONKEYTYPE_HOST:-127.0.0.1}"
BACKEND_URL="${MONKEYTYPE_BACKEND_URL:-https://api.monkeytype.com}"

cd "$ROOT_DIR"

if [ ! -d node_modules ]; then
  echo "[monkeytype] Installing dependencies with pnpm..."
  pnpm install --frozen-lockfile
fi

echo "[monkeytype] Starting frontend on http://${HOST}:${PORT}"
cd frontend
exec env SERVER_OPEN=false BACKEND_URL="$BACKEND_URL" pnpm exec vite dev --host "$HOST" --port "$PORT" --strictPort
