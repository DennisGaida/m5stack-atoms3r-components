# Project Structure

This document describes the organization of the M5Stack AtomS3R ESPHome project.

## Root Directory

```
.
├── LICENSE                      # Project license
├── README.md                    # Main project documentation
├── PROJECT_STRUCTURE.md         # This file
├── .defaults.yaml              # Common ESPHome settings (wifi, api, ota)
├── m5stack-atom-s3r.yaml       # Main device configuration
├── requirements.txt             # Python dependencies for ESPHome
├── secrets.yaml                 # WiFi/API secrets (gitignored)
├── .gitignore                  # Git ignore rules
├── .vscode/                     # VS Code configuration
├── docs/                        # Documentation assets
├── scripts/                     # Setup utilities
└── device-submission/           # Files for ESPHome Devices repository
```

There is no `components/` directory. This device needs no custom ESPHome
components: the IMU (accel/gyro/temp + BMM150 magnetometer) is driven by the
official `motion`/`bmi270` platform, and the display backlight by the
official `lp5562` platform.

## Pending upstream PRs

Both of the platforms this device relies on for its I2C peripherals are
currently open pull requests against `esphome/esphome`, not yet in a release:

- [esphome/esphome#18436](https://github.com/esphome/esphome/pull/18436) - adds optional BMM150 magnetometer support to the `bmi270` motion platform
- [esphome/esphome#18453](https://github.com/esphome/esphome/pull/18453) - adds the `lp5562` output component (used here for the display backlight)

Until they're merged, `m5stack-atom-s3r.yaml` pulls both in directly via
`external_components: - source: github://pr#18436` / `github://pr#18453`.
**Once merged into an ESPHome release, delete that `external_components:`
block** - the platforms will already ship with the `esphome` pip package.

## Scripts Directory

Development environment setup scripts:

```
scripts/
├── setup.bat                    # Windows environment setup
└── setup.sh                     # Linux/macOS environment setup
```

**Usage:**
- Windows: `scripts\setup.bat`
- Linux/Mac: `scripts/setup.sh`

These scripts:
1. Create Python virtual environment (`.venv/`)
2. Install ESPHome and dependencies
3. Provide instructions for next steps

## Documentation Directory

Documentation assets and design files:

```
docs/
├── README.md                    # Documentation guide
├── images/                      # Photos and screenshots
│   └── .gitkeep                # Placeholder (add your images here)
└── design/                      # Design source files
    └── display-mockup.psd      # Display layout mockup
```

**Add your device photos here:**
- Device photos showing hardware
- Screenshots of display in different states
- Reference these in main README.md

## Device Submission Directory

Files prepared for submitting the M5Stack AtomS3R to ESPHome Devices:

```
device-submission/
└── m5stack-atoms3r/
    ├── index.md                 # Device documentation (markdown)
    ├── README.md                # Submission instructions
    └── (add photos here)        # Device images for documentation
```

**What goes here:**
- Device documentation with front matter
- Photos of the physical device
- Complete working configuration
- Pin mappings and technical details

## Build Artifacts (gitignored)

These directories are created during build and not committed to git:

```
.esphome/                        # ESPHome build cache and data
├── build/                       # Compiled firmware
├── storage/                     # Device state storage
├── font/                        # Downloaded fonts
└── image/                       # Processed images

.pio/                            # PlatformIO build directory

.venv/                           # Python virtual environment
```

## VS Code Integration

```
.vscode/
├── tasks.json                   # Pre-configured ESPHome tasks
└── settings.json               # Workspace settings
```

**Available tasks** (Ctrl+Shift+P → "Tasks: Run Task"):
- Config - Validate configuration
- Compile - Build firmware
- Upload - Upload to device
- Logs - View device logs
- Run (OTA) - Over-the-air update

## Configuration Files

### Main Device Configuration

- **m5stack-atom-s3r.yaml** - Complete configuration for M5Stack AtomS3R
  - Includes `.defaults.yaml` for common settings
  - Hardware-specific pin assignments
  - `motion`/`bmi270` + `lp5562` platforms (via the pending PRs above)
  - Display configuration with Teams presence logic

### Shared Configuration

- **.defaults.yaml** - Common ESPHome settings
  - WiFi configuration
  - Home Assistant API
  - OTA updates
  - Logger settings
  - Uses `secrets.yaml` for sensitive data

### Secrets

- **secrets.yaml** - Sensitive configuration (gitignored)
  - WiFi credentials
  - API keys
  - OTA passwords
  - Create from template in README.md

## Device Submission (esphome/devices.esphome.io)

The M5Stack AtomS3R device configuration is prepared for the ESPHome Devices
repository:

**Location:** `device-submission/m5stack-atoms3r/`
**Repository:** https://github.com/esphome/devices.esphome.io (renamed from `esphome/esphome-devices`)
**What:** Complete device configuration and documentation

**Files for submission:**
- index.md (device documentation with front matter)
- Device photos (add your own)
- README.md (submission instructions)

## Development Workflow

1. **Setup:** Run `scripts/setup.bat` or `scripts/setup.sh`
2. **Edit:** Modify `m5stack-atom-s3r.yaml`
3. **Validate:** `esphome config m5stack-atom-s3r.yaml`
4. **Build:** `esphome compile m5stack-atom-s3r.yaml`
5. **Upload:** `esphome upload m5stack-atom-s3r.yaml`
6. **Monitor:** `esphome logs m5stack-atom-s3r.yaml`

**Don't commit:**
- `secrets.yaml` (contains sensitive data)
- `.esphome/` (build artifacts)
- `.pio/` (build directory)
- `.venv/` (virtual environment)

## External Dependencies

- **ESPHome** - Framework for ESP32 devices
- **PlatformIO** - Build system
- **Home Assistant** - Smart home integration

---

**Last Updated:** 2026-08-17
**Project:** M5Stack AtomS3R ESPHome Components
