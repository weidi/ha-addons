#!/usr/bin/with-contenv bashio
set -euo pipefail

export UPDATE_FREQUENCY="$(bashio::config 'update_frequency')"
export TCP_HOSTNAME="0.0.0.0"
export HTTP_HOSTNAME="0.0.0.0"
export HTTP_PORT="8080"

cd /opt/huum-controller

exec bun run src/main.ts
