# Timmkoo Offline OS Project

This repository is for modifying the operating system/firmware used by the Timmkoo music player so it becomes an offline-first, lighter, more efficient dedicated media device.

## Goal

Build a stripped-down firmware workflow that:

- Removes internet access completely.
- Keeps local music playback stable.
- Keeps USB/MTP file transfer working.
- Keeps SD card support working.
- Keeps Bluetooth audio only if it is needed.
- Removes or disables browser, Wi-Fi sharing, cloud, update, telemetry, app-store, and background network services.
- Reduces boot load, background processes, storage use, and battery drain.

## Current status

Initial repo setup. No firmware image has been committed yet.

Do **not** commit full factory firmware images unless you are sure redistribution is legal. Prefer local unpack/build folders ignored by Git.

## Expected workflow

1. Dump or download the stock firmware.
2. Identify CPU architecture, Android version, partition layout, and boot image format.
3. Unpack firmware locally.
4. Audit installed apps, services, init scripts, permissions, and network interfaces.
5. Disable networking at multiple layers:
   - remove user-facing apps,
   - remove network permissions from apps where possible,
   - disable Wi-Fi services,
   - block interfaces at boot,
   - remove OTA/update clients,
   - verify no process can reach the internet.
6. Remove nonessential apps and background services.
7. Repack and flash only after a verified backup/recovery path exists.

## Safety rule

Never flash a modified image until you have:

- a stock firmware backup,
- a known recovery mode path,
- a tested USB/ADB/fastboot or vendor flashing method,
- battery charged,
- matching firmware for the exact model.

A bad image can brick the player.

## Repository layout

```text
docs/                 Planning, firmware notes, and test checklists
scripts/              Local analysis and hardening helper scripts
overlays/             Files intended to be copied into an unpacked root filesystem
configs/              Build and deny-list configuration
firmware/             Local-only firmware workspace, ignored by Git
```

## First real task

Put the stock firmware or a full device dump in a local `firmware/stock/` folder, then run:

```bash
bash scripts/audit-rootfs.sh firmware/stock/rootfs
```

If the firmware does not unpack into a simple root filesystem, document the partition/image layout in `docs/DEVICE_NOTES.md` first.
