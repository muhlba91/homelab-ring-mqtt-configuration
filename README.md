# Homelab: Ring MQTT - Configuration

[![](https://img.shields.io/github/license/muhlba91/homelab-ring-mqtt-configuration?style=for-the-badge)](LICENSE.md)
[![](https://img.shields.io/github/actions/workflow/status/muhlba91/homelab-ring-mqtt-configuration/verify.yml?style=for-the-badge)](https://github.com/muhlba91/homelab-ring-mqtt-configuration/actions/workflows/verify.yml)
[![](https://api.scorecard.dev/projects/github.com/muhlba91/homelab-ring-mqtt-configuration/badge?style=for-the-badge)](https://scorecard.dev/viewer/?uri=github.com/muhlba91/homelab-ring-mqtt-configuration)

This repository contains [Ring MQTT](https://github.com/tsightler/ring-mqtt) configuration, and lifecycle scripts.

---

## Configuration

The main configuration is located in [`configuration/config.json`](configuration/config.json), and encrypted with [sops](https://github.com/mozilla/sops) and [Google Cloud KMS](https://cloud.google.com/security-key-management).

## Lifecycle Scripts

The directory [`lifecycle`](lifecycle/) contains all lifecycle scripts:

- `prepare.sh`: installs all custom and www components defined in [`components/custom_components.txt`](components/custom_components.txt) and [`components/www_components.txt`](components/www_components.txt)
- `sops.sh`: encrypts or decrypts all necessary files (pass `e` for encryption, and `d` for decryption)
- `backup_restore.sh`: checks if data exists and either backups or restores the configuration
