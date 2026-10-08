---
title: "IdentityCommand.SCA Release 0.2"
date: 2026-10-08 00:00:00
version: 0.2.17
tags:
  - Release Notes
---

## [0.2.17]

### Changed

- Moved to the pspete.Build GitHub Actions pipeline; AppVeyor is retired.
- Requires IdentityCommand 0.7.159 or later.
- Argument completer registrations run from the module psm1, after IdentityCommand's helpers are copied in.

## [0.2.16]

### Changed

- The module loader copies `IdentityCommand`'s private helper functions from the loaded module's session state instead of dot-sourcing its `Private` folder, so it works with both the current `IdentityCommand` layout and the combined single-file layout of future releases. Each copied helper runs in this module's scope and uses its session.
