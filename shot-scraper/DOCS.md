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
auth_file: "shot-scraper/home-assistant-auth.json"
retries: 2
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

### Option: `auth_file`

Optional path to a Playwright authentication context JSON file for sites that require login.

- Relative paths are resolved under `/share`
- Absolute paths are used as-is

Example:

```yaml
auth_file: "shot-scraper/home-assistant-auth.json"
```

This should be a JSON file created by `shot-scraper auth ...` on another machine and then copied into Home Assistant shared storage.

### Option: `retries`

How many extra attempts to make when `shot-scraper` hits a transient navigation failure.

Example:

```yaml
retries: 2
```

This is mainly useful for intermittent browser/network errors such as `ERR_NETWORK_CHANGED`.

## Manual Usage

1. Install the add-on from this repository.
2. Configure `url`, `output`, and any optional `args`.
3. Start the add-on.
4. Retrieve the image from the shared folder.

## Automation Usage

Home Assistant's current documentation uses the Supervisor action `hassio.app_stdin` for sending JSON payloads to an add-on over STDIN. Because this add-on is a one-shot worker, start it first and then send the payload.

Example automation action:

```yaml
action:
  - action: hassio.app_start
    data:
      app: local_shot_scraper

  - action: hassio.app_stdin
    data:
      app: local_shot_scraper
      input:
        url: "https://www.home-assistant.io/"
        output: "shot-scraper/automation.png"
        auth_file: "shot-scraper/home-assistant-auth.json"
        retries: 2
        args: "--width 1440 --height 1200"
```

The payload keys match the add-on configuration keys:

- `url`
- `output`
- `auth_file`
- `retries`
- `args`

When a JSON payload is sent over STDIN:

- values from STDIN override the stored add-on options for that run
- omitted values fall back to the add-on configuration

## Notes

- The add-on does not expose ports or ingress.
- The add-on does not stay running after the screenshot has completed.
- Invalid or missing `url` values cause the run to fail with a clear log message.
- Authentication for protected sites is supported through a Playwright auth context file passed via `auth_file`.
- Transient navigation failures are retried automatically based on the `retries` setting.
