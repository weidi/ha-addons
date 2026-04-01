# Home Assistant App: Shot Scraper

Take website screenshots from Home Assistant using [`shot-scraper`](https://shot-scraper.datasette.io/).

Supported architectures:

- `amd64`
- `aarch64`

This add-on is designed as a one-shot worker. Start it manually or trigger it from an automation using Home Assistant's Supervisor STDIN action.

## Automation Example

Use the following actions in a Home Assistant automation to trigger the add-on and generate a screenshot:

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
        args: "--width 1440 --height 1200"
```

Notes:

- `app: local_shot_scraper` matches the local add-on slug generated from `shot_scraper`
- `hassio.app_stdin` writes to stdin, so the add-on should be started first
- this add-on is a one-shot worker and exits after each run, so each automation run should start it again
- `output` is relative to `/share` unless you provide an absolute path
- `args` is optional
