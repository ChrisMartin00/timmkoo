# Device Notes

Use this file to record facts about the exact Timmkoo player before making firmware changes.

## Hardware

- Model:
- Storage size:
- RAM:
- CPU/SoC:
- Screen resolution:
- Android version / build ID:
- Kernel version:
- Bootloader/recovery access method:
- Flashing tool:

## Known features to preserve

- Local music playback
- USB file transfer / MTP
- SD card access
- Headphone output
- Speaker output, if present
- Bluetooth audio, if required
- Settings needed for volume, display, storage, battery, and language

## Features targeted for removal or disablement

- Wi-Fi internet access
- Browser
- WebView-dependent apps unless required by system UI
- OTA/updater apps
- App store / APK installer helpers, unless needed for maintenance builds
- Cloud sync
- Online music services
- Analytics, telemetry, ads, push notification clients
- Email, chat, social, and general-purpose internet apps

## Firmware dump notes

Record the dump source, date, hashes, and partition names here.

```text
source:
date:
sha256:
partitions:
```

## Recovery notes

Before flashing anything, fill this in.

```text
stock backup location:
recovery mode steps:
flash command/tool:
rollback tested: no
```
