# AGENTS.md

This file defines how work should be performed in this repository.

## Mission

Build small, high-quality Home Assistant add-ons that feel consistent across this repository, follow current Home Assistant developer guidance, and default to least-privilege design.

This repository should stay intentionally small and focused. Prefer add-ons with a narrow purpose, clear operational behavior, and straightforward configuration over generic multi-purpose containers.

## Source Of Truth

When creating or changing add-ons, use the current Home Assistant developer documentation as the source of truth, especially:

- the app tutorial for required baseline files and local development flow
- the app configuration reference for valid `config.yaml` options
- the app security guidance for privilege and API exposure decisions

Repository-specific conventions in this file and the docs below narrow those choices for consistency:

- `docs/addon-standard.md`
- `docs/new-addon-checklist.md`

## Default Build Philosophy

- Prefer Alpine-based Home Assistant base images by default.
- Use Debian-based images only when there is a concrete compatibility reason that should be documented in the add-on docs or PR description.
- Prefer simple `bashio`-based startup scripts unless the add-on clearly benefits from a heavier runtime.
- Prefer one focused process per add-on.
- Keep dependencies minimal and pinned only when reproducibility or compatibility requires it.

## Standard Add-on Output

Each add-on directory should normally contain:

- `Dockerfile`
- `config.yaml`
- `run.sh`
- `DOCS.md`
- `README.md`
- `CHANGELOG.md`

Also update repository-level metadata when needed:

- `repository.yaml` if repository metadata changes
- root `README.md` if the public add-on list or install guidance changes

## Consistency Rules

- Keep naming predictable: title case display name, lowercase underscore slug, concise one-line description.
- Keep folder layout uniform across add-ons.
- Use the same docs structure and heading style unless there is a strong reason to differ.
- Declare supported architectures explicitly.
- Choose the narrowest valid Home Assistant configuration options instead of enabling convenience flags by default.
- Record exceptions when deviating from the repository standard.

## Add-on Shapes

This repository supports three common shapes with one shared baseline:

- One-shot worker add-ons
- Long-running service add-ons
- Ingress or web UI add-ons

Do not invent a bespoke structure when one of the standard shapes applies. Start from the baseline in `docs/addon-standard.md` and only add shape-specific configuration that is actually required.

## Security Rules

- Default to least privilege.
- Do not enable `host_network`, `hassio_api`, `homeassistant_api`, `docker_api`, `full_access`, `privileged`, `devices`, `usb`, `uart`, `gpio`, or writable host mappings unless the add-on cannot function without them.
- If one of those options is required, document:
  - why it is needed
  - why a lower-privilege alternative is not sufficient
  - any user-visible consequences
- Prefer read-only mappings where possible.
- Expose ports, ingress, and APIs only for add-ons that actually serve them.

## Versioning And Releases

- Bump the add-on `version` whenever behavior, packaging, runtime, or configuration changes in a way users may need to reinstall or update.
- Keep `CHANGELOG.md` current and user-facing.
- Keep `DOCS.md` aligned with `config.yaml` options and real runtime behavior.

## Existing Exception

`shot-scraper` is a valid example of a documented exception to the Alpine-first default. It uses a Debian-based Home Assistant image because Playwright requires a glibc-based environment. Treat that as a compatibility-driven deviation, not the baseline for new add-ons.

## Working Agreement For Future Changes

When adding a new add-on or making a substantial add-on change:

1. Follow `docs/addon-standard.md`.
2. Run through `docs/new-addon-checklist.md`.
3. Document any deviation from the standard in the add-on docs or PR description.

If there is a conflict between convenience and consistency, favor consistency unless the Home Assistant docs or the add-on's runtime requirements clearly require otherwise.
