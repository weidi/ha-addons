# New Add-on Checklist

Use this checklist before considering a new add-on ready for review or merge.

## Structure

- Add-on directory created with the standard file set:
  - `Dockerfile`
  - `config.yaml`
  - `run.sh`
  - `DOCS.md`
  - `README.md`
  - `CHANGELOG.md`
- Root repository metadata is still accurate.
- Root `README.md` is updated if the public add-on list changed.

## Home Assistant Configuration

- `config.yaml` is valid YAML.
- Required fields are present: `name`, `version`, `slug`, `description`, `arch`.
- `startup` matches the real runtime behavior.
- `boot` behavior is intentional.
- `options` and `schema` are aligned.
- Every non-trivial option is documented in `DOCS.md`.
- `stdin`, `ports`, `ingress`, `map`, and API flags are enabled only when the add-on actually uses them.
- Supported architectures match the real image and dependencies.

## Runtime And Security

- Base image choice is intentional.
- Alpine was used by default, or Debian usage is explicitly justified.
- Installed packages and runtime dependencies are minimal for the add-on purpose.
- Privileged flags, host access, device access, API access, and writable mappings were reviewed for least privilege.
- Any exception to the standard is recorded in the add-on docs or PR description.

## Documentation And Consistency

- `DOCS.md` explains what the add-on does, how to configure it, and how to operate it.
- `README.md` gives a short, repository-friendly summary.
- `CHANGELOG.md` includes the initial or updated release entry.
- Naming, slug, description style, and docs structure follow the repository standard.
- Examples use realistic Home Assistant paths, actions, and payloads.

## Verification

- The add-on shape is clearly one of: worker, service, or ingress/web UI.
- The chosen shape follows the matching variant guidance in `docs/addon-standard.md`.
- Config examples match the real `schema` and runtime behavior.
- Known limitations or operational caveats are documented.
- The add-on can be explained in one sentence without needing repo-specific tribal knowledge.
