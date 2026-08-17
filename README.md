# m5stack-atoms3r-components

ESPHome device configuration for the M5Stack AtomS3R.

This device needs no custom ESPHome components - the IMU (BMI270 accel/gyro/temp
+ BMM150 magnetometer) and display backlight (LP5562) are both driven by
upstream ESPHome platforms, currently pending merge as
[esphome/esphome#18436](https://github.com/esphome/esphome/pull/18436) and
[esphome/esphome#18453](https://github.com/esphome/esphome/pull/18453).
Until those land in a release, `m5stack-atom-s3r.yaml` pulls them in directly
via `external_components: - source: github://pr#...` (see
[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for details).

## esphome Configuration
You will need to create a `secrets.yaml` file with the following content, to be able to use esphome CLI:
```
wifi_ssid:     <your wifi ssid>
wifi_password: <your wifi password>

wifi_ap_name:     <your ap name>
wifi_ap_password: <your ap password>

homeassistant_api_key: <HomeAssistant generated API key>

ota_password: <your OTA password>
```

## Development Setup

Run the setup script to create a Python virtual environment and install dependencies:

**Windows:**
```bash
scripts\setup.bat
```

**Linux/macOS:**
```bash
scripts/setup.sh
```

Afterwards you can either run `esphome` commands manually via Terminal/Shell, e.g. `esphome config m5stack-atom-s3r.yaml`, or you can make use of the pre-configured Visual Studio Code tasks (<kbd>CTRL</kbd>+<kbd>SHIFT</kbd>+<kbd>P</kbd>, Tasks: Run Task).

### Note on SVG / Cairo
`m5stack-atom-s3r.yaml` renders a few `mdi:` icons (camera, camera-off, calendar) on
the display via the `image:` block, which requires Cairo (`cairosvg`/`cairocffi` in
`requirements.txt`) to rasterize the SVGs. Cairo unfortunately is a bit finicky on
Windows, to get it to work you will need some additional steps:

1. Download GTK binaries via https://github.com/wingtk/gvsbuild > Release
2. Copy the cairo* files from `/bin` to the Python virtual environment (`.venv/Scripts/`)
