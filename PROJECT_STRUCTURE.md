# Project Structure

This document describes the organization of the M5Stack AtomS3R ESPHome components project.

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
├── tmp_*.md                     # Temporary reference documents
├── .gitignore                  # Git ignore rules
├── .vscode/                     # VS Code configuration
├── components/                  # ESPHome custom components
├── docs/                        # Documentation assets
├── scripts/                     # Setup utilities
└── device-submission/           # Files for ESPHome Devices repository
```

## Components Directory

Custom ESPHome components for the M5Stack AtomS3R hardware:

```
components/
├── bmi270/                      # BMI270 IMU sensor (ready for ESPHome submission)
│   ├── __init__.py             # Python package marker
│   ├── sensor.py               # ESPHome configuration schema
│   ├── bmi270.h                # C++ header
│   ├── bmi270.cpp              # C++ implementation
│   ├── README.md               # Component documentation
│   ├── examples/               # Example configurations
│   │   ├── minimal.yaml       # Basic example
│   │   ├── full.yaml          # Full featured example
│   │   └── m5stack-atoms3r.yaml
│   ├── test/                   # Component tests
│   │   └── test.bmi270.yaml
│   └── tmp_*.md                # Temporary reference docs
│
├── m5stack_button_sensor/       # Button state sensor
├── m5stack_button_text_sensor/  # Button text representation
├── m5stack_button_compound_sensor/ # Combined button sensor
├── m5stack_display_backlight_output/ # Display backlight control (LP5562)
└── m5stack_imu_sensor/          # Alternative IMU using M5Unified
```

### Component Organization

Each component follows the ESPHome external component pattern:

```
component_name/
├── __init__.py                  # Empty Python package file
├── <platform>.py               # ESPHome config (sensor.py, output.py, etc.)
├── <component_name>.h          # C++ header file
├── <component_name>.cpp        # C++ implementation
└── README.md                    # Component documentation
```

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
└── M5Stack-AtomS3R/
    ├── index.md                 # Device documentation (markdown)
    ├── README.md                # Submission instructions
    └── (add photos here)        # Device images for documentation
```

**What goes here:**
- Device documentation with front matter
- Photos of the physical device
- Complete working configuration
- Pin mappings and technical details

**This is separate from the component submission!**

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
  - Display configuration with Teams presence logic
  - References custom components from `components/`

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

## Submissions to ESPHome

This project has **two separate submissions** to different ESPHome repositories:

### 1. Component Submission (esphome/esphome)

The `bmi270` component is prepared for the main ESPHome repository:

**Location:** `components/bmi270/`
**Repository:** https://github.com/esphome/esphome
**What:** Generic BMI270 sensor component (hardware-agnostic)

**Essential files for submission:**
- Core component files (`.py`, `.h`, `.cpp`)
- README.md (user documentation)
- examples/ (working configurations)
- test/ (component tests)

**Temporary reference files** (prefixed with `tmp_`):
- tmp_PR_SUBMISSION_GUIDE.md
- tmp_IMPLEMENTATION_SUMMARY.md
- tmp_PR_CHECKLIST.md

### 2. Device Submission (esphome/esphome-devices)

The M5Stack AtomS3R device configuration is prepared for the ESPHome Devices repository:

**Location:** `device-submission/M5Stack-AtomS3R/`
**Repository:** https://github.com/esphome/esphome-devices
**What:** Complete device configuration and documentation

**Files for submission:**
- index.md (device documentation with front matter)
- Device photos (add your own)
- README.md (submission instructions)

## Best Practices

### Adding New Components

1. Create directory in `components/`
2. Follow ESPHome component structure
3. Add README.md with examples
4. Test with example configuration
5. Document in main README.md

### Adding Documentation

1. Device photos → `docs/images/`
2. Design files → `docs/design/`
3. Reference in README.md with relative paths

### Development Workflow

1. **Setup:** Run `scripts/setup.bat` or `scripts/setup.sh`
2. **Edit:** Modify YAML or component files
3. **Validate:** `esphome config m5stack-atom-s3r.yaml`
4. **Build:** `esphome compile m5stack-atom-s3r.yaml`
5. **Upload:** `esphome upload m5stack-atom-s3r.yaml`
6. **Monitor:** `esphome logs m5stack-atom-s3r.yaml`

### Version Control

**Commit:**
- Source code and configurations
- Documentation (markdown, examples)
- Component files
- Requirements and setup scripts

**Don't commit:**
- `secrets.yaml` (contains sensitive data)
- `.esphome/` (build artifacts)
- `.pio/` (build directory)
- `.venv/` (virtual environment)
- Temporary files (`tmp_*.md` - optional)

## File Naming Conventions

- **UPPERCASE.md** - Important documentation (README, LICENSE)
- **lowercase.yaml** - Configuration files
- **snake_case/** - Component and directory names
- **tmp_*.md** - Temporary reference documents
- **.dotfiles** - Configuration and hidden files

## External Dependencies

- **ESPHome** - Framework for ESP32 devices
- **PlatformIO** - Build system
- **Home Assistant** - Smart home integration
- **M5Unified** - M5Stack hardware library (for some components)

## Support and Contributing

For component-specific questions:
- See component README.md files
- Check example configurations

For BMI270 component submission:
- See `components/bmi270/tmp_PR_SUBMISSION_GUIDE.md`
- All files are ready for ESPHome PR

---

**Last Updated:** 2026-02-04
**Project:** M5Stack AtomS3R ESPHome Components
