#!/usr/bin/with-contenv bashio
set -euo pipefail

CONFIG_PATH="/data/options.json"
STDIN_WAIT_SECONDS="${STDIN_WAIT_SECONDS:-10}"
export PLAYWRIGHT_BROWSERS_PATH="${PLAYWRIGHT_BROWSERS_PATH:-/opt/playwright}"
export PATH="/opt/shot-scraper/bin:${PATH}"

python3 - <<'PY'
import json
import os
import pathlib
import select
import shlex
import subprocess
import sys


CONFIG_PATH = "/data/options.json"
STDIN_WAIT_SECONDS = float(os.environ.get("STDIN_WAIT_SECONDS", "10"))


def load_json_file(path):
    try:
        with open(path, "r", encoding="utf-8") as handle:
            data = json.load(handle)
    except FileNotFoundError:
        return {}
    except json.JSONDecodeError as err:
        print(f"ERROR: Invalid JSON in {path}: {err}", file=sys.stderr)
        sys.exit(1)
    if not isinstance(data, dict):
        print(f"ERROR: Expected an object in {path}", file=sys.stderr)
        sys.exit(1)
    return data


def load_stdin_payload():
    try:
        ready, _, _ = select.select([sys.stdin], [], [], STDIN_WAIT_SECONDS)
    except (OSError, ValueError):
        return {}
    if not ready:
        return {}

    raw = sys.stdin.read()
    if not raw.strip():
        return {}
    try:
        data = json.loads(raw)
    except json.JSONDecodeError as err:
        print(f"ERROR: Invalid JSON received on STDIN: {err}", file=sys.stderr)
        sys.exit(1)
    if not isinstance(data, dict):
        print("ERROR: STDIN payload must be a JSON object", file=sys.stderr)
        sys.exit(1)
    return data


def merged_config():
    config = load_json_file(CONFIG_PATH)
    config.update(load_stdin_payload())
    return config


def normalize_output(raw_output):
    output = (raw_output or "").strip()
    if not output:
        output = "shot-scraper/output.png"

    output_path = pathlib.Path(output)
    if not output_path.is_absolute():
        output_path = pathlib.Path("/share") / output_path
    return output_path


def chromium_env():
    candidates = (
        "/usr/bin/chromium-browser",
        "/usr/bin/chromium",
    )
    for candidate in candidates:
        if os.path.exists(candidate):
            os.environ.setdefault("PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH", candidate)
            break


config = merged_config()
url = str(config.get("url", "")).strip()
if not url:
    print("ERROR: The 'url' option is required.", file=sys.stderr)
    sys.exit(1)

output_path = normalize_output(config.get("output", ""))
output_path.parent.mkdir(parents=True, exist_ok=True)

extra_args = shlex.split(str(config.get("args", "")).strip())
chromium_env()

command = ["shot-scraper", url, "-o", str(output_path), *extra_args]
print("Executing:", " ".join(shlex.quote(part) for part in command), flush=True)
subprocess.run(command, check=True)
PY
