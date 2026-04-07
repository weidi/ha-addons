# Changelog

## 0.2.0

- implemented useful heater states as 0x09 is not really helpful and flipping states so need more reverse engineering.
- currently working is, turning light on/off, starting and stopping sauna session!

## 0.1.5

- add `debug_protocol` as a Home Assistant option
- pass `DEBUG_PROTOCOL` through to the upstream runtime environment

## 0.1.4

- switch to own fork of huum-controller for now

## 0.1.2

- Patch the cloned upstream `src/main.ts` during image build to remove a broken import of a missing `src/homeassistant/forwarder.ts` file
- Restore successful add-on startup on current upstream `kpalang/huum-controller` HEAD

## 0.1.1

- Switched the add-on back to Home Assistant's default Alpine base image
- Removed the Debian base image override and rely on Bun's Alpine musl binary during build

## 0.1.0

- Initial `huum-controller` add-on release
- Packaged the upstream `kpalang/huum-controller` project as a Home Assistant add-on
- Exposed the fixed heater TCP listener on `6969`
- Exposed the upstream HTTP service on `8080`
- Enabled Home Assistant Ingress for the upstream HTTP service
- Added minimal `update_frequency` configuration mapped to the upstream runtime
