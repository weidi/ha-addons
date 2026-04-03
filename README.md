# weidi Home Assistant add-ons

This repository is a custom Home Assistant add-on repository.

It is intended to host small, focused add-ons that are built by Home Assistant during installation.

## Add-ons

### `shot-scraper`

The first add-on in this repository is `shot-scraper`.

It provides a one-shot worker that captures screenshots of web pages using [`shot-scraper`](https://shot-scraper.datasette.io/).

Current capabilities:

- Manual execution from the Home Assistant add-on UI
- Automation-triggered execution through Supervisor STDIN input
- Output written to Home Assistant shared storage

Supported architectures:

- `amd64`
- `aarch64`

### `huum-controller`

The repository also includes `huum-controller`.

It packages the upstream [`kpalang/huum-controller`](https://github.com/kpalang/huum-controller) project as a long-running add-on for Huum sauna heaters.

Current capabilities:

- Fixed heater controller listener on `6969/tcp`
- HTTP API on `8080/tcp`
- Home Assistant Ingress access to the upstream HTTP service
- Minimal configuration through `update_frequency`

Supported architectures:

- `amd64`
- `aarch64`

## Add This Repository To Home Assistant

In Home Assistant:

1. Open the add-on store.
2. Open the repository menu.
3. Add this repository URL:

```text
https://github.com/weidi/ha-addons
```

After adding the repository, install the `Shot Scraper` add-on from the store.
You can also install the `Huum Controller` add-on.

## Repository Layout

```text
.
├── repository.yaml
├── huum-controller/
│   ├── config.yaml
│   ├── Dockerfile
│   ├── DOCS.md
│   ├── CHANGELOG.md
│   ├── README.md
│   └── run.sh
└── shot-scraper/
    ├── build.yaml
    ├── config.yaml
    ├── Dockerfile
    ├── DOCS.md
    ├── CHANGELOG.md
    └── run.sh
```

## Notes

- The add-ons in this repository are built locally by Home Assistant from their included `Dockerfile`.
- The `shot-scraper` add-on uses a Debian-based Home Assistant image because Playwright requires a glibc-based environment.
- The `huum-controller` add-on uses Home Assistant's default Alpine base image and installs Bun's Alpine-compatible musl binary during the image build.
