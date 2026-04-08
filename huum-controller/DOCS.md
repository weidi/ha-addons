# Huum Controller

`Huum Controller` packages the upstream [`kpalang/huum-controller`](https://github.com/kpalang/huum-controller) project as a Home Assistant add-on.

It provides a local controller endpoint for Huum sauna heaters without relying on the vendor cloud.

This add-on is a long-running service:

- it listens for the heater controller on TCP port `6969`
- it exposes the upstream HTTP service on port `8080`
- it can be opened through Home Assistant Ingress

## Configuration

```yaml
update_frequency: 60
debug_protocol: false
```

### Option: `update_frequency`

How often the controller should ask the heater for status updates, in seconds.

- valid range: `0` to `255`
- default: `60`

This value is passed to the upstream app through the `UPDATE_FREQUENCY` environment variable.

### Option: `debug_protocol`

Enable verbose protocol-level debugging for the upstream Huum controller runtime.

- valid values: `1` or `0`
- default: `0s`

This value is passed to the upstream app through the `DEBUG_PROTOCOL` environment variable.

## Ports

### Port `6969/tcp`

The fixed TCP listener used by the Huum heater controller.
- this is required by the upstream project

### Port `8080/tcp`

The upstream HTTP API and the target used by Home Assistant Ingress.

- the internal container port stays `8080`
- Home Assistant Ingress proxies to this port

## Ingress Usage

1. Install the add-on.
2. Configure `update_frequency` and `debug_protocol` if needed.
3. Start the add-on.

Ingress is intended to expose the upstream HTTP service inside Home Assistant. The upstream project currently documents HTTP endpoints rather than a full browser UI.

## HTTP API

The upstream project exposes the following endpoints on port `8080`.

### `GET /status`

Returns the current measured temperature as plain text.

Example:

```bash
curl http://homeassistant.local:8080/status
```

### `POST /start`

Starts heating with a target temperature and duration.

Request body:

```json
{
  "targetTemperature": 75,
  "durationHours": 2
}
```

Example:

```bash
curl -X POST http://homeassistant.local:8080/start \
  -H "Content-Type: application/json" \
  -d '{"targetTemperature":75,"durationHours":2}'
```

### `POST /stop`

Stops heating.

Request body:

```json
{
  "targetTemperature": 75
}
```

Example:

```bash
curl -X POST http://homeassistant.local:8080/stop \
  -H "Content-Type: application/json" \
  -d '{"targetTemperature":75}'
```

## Home Assistant Integration Readiness

This repository does not ship a separate Home Assistant integration for the sauna controller.

Instead, this add-on is prepared for future integration work by exposing:

- a stable internal HTTP service on port `8080`
- an Ingress-backed Home Assistant entry point
- a documented API contract for `status`, `start`, and `stop`

Any future Home Assistant integration can target the add-on's HTTP API rather than talking directly to the heater protocol.

## Notes

- No privileged flags, host networking, or Home Assistant API access are enabled.
- Only the required TCP and HTTP ports are exposed.
- The internal ports are fixed by design even if you remap the published host-side ports.
- The upstream project source is fetched during Docker image build instead of being committed into this repository.
- The current upstream repository head is patched during image build to remove a broken import of a missing Home Assistant forwarder file.
