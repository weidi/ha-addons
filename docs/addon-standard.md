# Add-on Standard

This document defines the standard structure and authoring rules for Home Assistant add-ons in this repository.

## Baseline Layout

Each add-on should live in its own directory and normally include:

- `Dockerfile`: build and runtime image definition
- `config.yaml`: Home Assistant add-on metadata and options
- `run.sh`: container entrypoint
- `DOCS.md`: canonical user documentation
- `README.md`: short repository-facing summary and usage entrypoint
- `CHANGELOG.md`: user-visible version history

Keep file names and directory structure consistent unless Home Assistant tooling requires otherwise.

## Baseline Configuration

Every add-on should define, at minimum:

- `name`
- `version`
- `slug`
- `description`
- `arch`

Choose other `config.yaml` keys based on actual behavior, not template habit.

Repository defaults:

- Prefer `init: false` when the add-on uses the standard `#!/usr/bin/with-contenv bashio` entrypoint pattern expected by current Home Assistant guidance for add-ons in this repo.
- Use `startup`, `boot`, `stdin`, `ports`, `ingress`, `map`, `environment`, and API access flags only when the add-on behavior requires them.
- Keep `options` and `schema` aligned. If an option exists, document it in `DOCS.md`.
- Keep descriptions concise and practical.

## Runtime And Base Image Rules

- Prefer Home Assistant Alpine base images by default.
- Switch to Debian only for concrete compatibility needs such as glibc-bound tooling, browser/runtime dependencies, or packages that are significantly harder or riskier to support on Alpine.
- When Debian is used, record the reason in `DOCS.md` or the PR description.
- Keep the image small and purpose-built. Avoid installing broad toolchains unless the add-on truly needs them at runtime.

## Documentation Standard

`DOCS.md` is the primary user documentation and should normally include:

- a short overview of what the add-on does
- configuration section with every option explained
- manual usage or installation notes
- automation or integration usage when relevant
- operational notes, limitations, and security-sensitive behavior

`README.md` should stay shorter than `DOCS.md` and help a repository reader quickly understand the add-on.

`CHANGELOG.md` should record meaningful user-visible changes only.

## Variant Rules

### One-shot worker add-ons

- Prefer `startup: once`.
- Prefer `boot: manual_only` unless there is a clear reason to auto-run.
- Avoid ports and ingress.
- Use `stdin: true` only when runtime input from Home Assistant automation is part of the design.
- Keep persistent output paths and writable mappings narrow and explicit.

### Long-running service add-ons

- Use a long-running `startup` mode that matches the service lifecycle.
- Expose only the ports the service actually needs.
- Add `ports_description` when exposed ports are not self-explanatory.
- Prefer a single clearly owned network surface instead of multiple optional listeners.
- Document expected runtime behavior, health expectations, and stored data.

### Ingress or web UI add-ons

- Enable ingress only when a real Home Assistant-embedded UI is part of the add-on value.
- Use `ingress`, `ingress_port`, and panel metadata intentionally rather than by default.
- Prefer ingress over direct port exposure when the UI is meant to be used inside Home Assistant.
- Document authentication assumptions, session behavior, and any external network exposure.

## Permissions And Access

These settings require explicit justification when used:

- `host_network`
- `host_ipc`
- `host_dbus`
- `host_pid`
- `hassio_api`
- `homeassistant_api`
- `docker_api`
- `privileged`
- `full_access`
- `devices`
- `usb`
- `uart`
- `gpio`
- writable host mappings in `map`

For each justified exception, record:

- what feature requires it
- why a lower-privilege alternative does not work
- what user-visible or security tradeoff it introduces

## Repository Conventions

- Display names should be human-readable and stable.
- Slugs should be lowercase with underscores.
- Descriptions should fit naturally in the Home Assistant UI and avoid marketing language.
- Architectures should be declared explicitly and only when supported.
- Keep examples realistic and consistent across docs.
- Prefer similar section order and wording across add-ons so the repository feels cohesive.

## Release Hygiene

- Update `version` when shipping meaningful changes.
- Update `CHANGELOG.md` in the same change.
- Keep `DOCS.md`, `README.md`, and `config.yaml` synchronized.
- If an add-on changes its options, update both `options` and `schema`, plus the documentation and examples.
