# Shot Scraper

`Shot Scraper` is a small Home Assistant add-on that runs [`shot-scraper`](https://shot-scraper.datasette.io/) to capture a screenshot of a website and save it to shared storage.

The add-on is intentionally simple:

- It runs once and exits.
- It does not expose a web UI.
- It can be started manually or from an automation.
- It uses Home Assistant's Debian base image so Playwright can run on a glibc-based system.

## Configuration

```yaml
url: "https://www.home-assistant.io/"
output: "shot-scraper/home-assistant.png"
args: "--width 1440 --height 1200"
```

### Option: `url`

The target URL to capture. This value is required.

### Option: `output`

The output filename for the screenshot.

- Absolute paths are used as-is.
- Relative paths are resolved under `/share`.

Example:

```yaml
output: "shot-scraper/example.png"
```

will write to:

```text
/share/shot-scraper/example.png
```

### Option: `args`

Optional extra command-line arguments passed directly to `shot-scraper`.

Examples:

```yaml
args: "--width 1280 --height 1600"
```

```yaml
args: "--selector .main-content"
```

## Manual Usage

1. Install the add-on from this repository.
2. Configure `url`, `output`, and any optional `args`.
3. Start the add-on.
4. Retrieve the image from the shared folder.

## Automation Usage

Home Assistant's current documentation uses the Supervisor action `hassio.app_stdin` for sending JSON payloads to an add-on over STDIN. Older examples may still refer to `hassio.addon_stdin`.

Example automation action:

```yaml
action:
  - action: hassio.app_stdin
    data:
      addon: local_shot_scraper
      input:
        url: "https://www.home-assistant.io/"
        output: "shot-scraper/automation.png"
        args: "--width 1440 --height 1200"
```

The payload keys match the add-on configuration keys:

- `url`
- `output`
- `args`

When a JSON payload is sent over STDIN:

- values from STDIN override the stored add-on options for that run
- omitted values fall back to the add-on configuration

## Notes

- The add-on does not expose ports or ingress.
- The add-on does not stay running after the screenshot has completed.
- Invalid or missing `url` values cause the run to fail with a clear log message.
