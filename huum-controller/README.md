# Home Assistant App: Huum Controller

Expose the upstream [`huum-controller`](https://github.com/kpalang/huum-controller) project as a Home Assistant add-on with Ingress and a stable local HTTP API.

Supported architectures:

- `amd64`
- `aarch64`

This add-on is a long-running service for Huum sauna heaters. It keeps the upstream fixed TCP listener on `6969`, exposes the HTTP API on `8080`, and makes that HTTP surface available through Home Assistant Ingress.

Current capabilities:

- Local Huum heater controller endpoint on TCP `6969`
- HTTP API on port `8080`
- Home Assistant Ingress access to the upstream HTTP service
- Minimal Home Assistant-facing configuration through `update_frequency`

The upstream HTTP surface is currently API-oriented rather than a full standalone dashboard, so the embedded Home Assistant view is mainly a convenient access path to that service.

The image builds on Home Assistant's default Alpine base and installs Bun's Alpine-compatible musl binary during build.
During image build, the add-on also patches the upstream `src/main.ts` entrypoint because the current upstream repository imports a missing `src/homeassistant/forwarder.ts` file.
