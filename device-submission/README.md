# M5Stack AtomS3R Device Submission

This directory contains files for submitting the M5Stack AtomS3R device configuration to the ESPHome Devices repository.

## Status

**Repository:** https://github.com/esphome/devices.esphome.io (renamed from `esphome/esphome-devices` - old links redirect)
**Location:** This directory (`device-submission/m5stack-atoms3r/`)
**Status:** 📝 Needs photos, otherwise ready

This device needs no custom ESPHome components. The IMU (accel/gyro/temp +
BMM150 magnetometer) and display backlight are both covered by upstream
platforms, currently pending merge as:

- [esphome/esphome#18436](https://github.com/esphome/esphome/pull/18436) - BMM150 magnetometer support for the `bmi270` motion platform
- [esphome/esphome#18453](https://github.com/esphome/esphome/pull/18453) - the `lp5562` output component

`index.md`'s Advanced Configuration section pulls both in via
`external_components: - source: github://pr#...` until they're merged into
an ESPHome release - update that block to remove the `external_components:`
override once they land.

## Device Submission Checklist

### Required Files

- [x] `index.md` - Device documentation with front matter
- [ ] Device photos (add to this directory):
  - [ ] `m5stack-atoms3r-front.jpg` - Front view showing display
  - [ ] `m5stack-atoms3r-back.jpg` - Back view showing connectors
  - [ ] `m5stack-atoms3r-display.jpg` - Display in action (optional)

### Front Matter (Already Set)

```yaml
title: M5Stack AtomS3R
date-published: 2026-02-04
type: sensor
standard: global
board: esp32
difficulty: 2
```

### Content Sections (Already Included)

- [x] Product Description
- [x] GPIO Pinout
- [x] I2C Devices
- [x] Basic Configuration (working YAML)
- [x] Advanced Configuration (IMU + magnetometer + backlight)
- [x] Use Cases
- [x] Resources

## Adding Photos

1. Take photos of your M5Stack AtomS3R device
2. Save them in this directory (`device-submission/m5stack-atoms3r/`)
3. Reference them in `index.md` using markdown:

```markdown
![M5Stack AtomS3R Front](m5stack-atoms3r-front.jpg "Front view")
![M5Stack AtomS3R Back](m5stack-atoms3r-back.jpg "Back view")
```

**Photo Guidelines:**
- Use clear, well-lit photos
- Show the device from multiple angles
- Include photos of the display in operation if possible
- Keep file sizes reasonable (< 1MB each)

## Submission Process

### Prerequisites

**No component PRs need to merge first.** The device submission can go ahead
now - `index.md` already documents the `external_components: source:
github://pr#...` bridge needed until #18436/#18453 land in a release.

1. **Fork the devices.esphome.io repository**
   ```bash
   git clone https://github.com/esphome/devices.esphome.io.git
   cd devices.esphome.io
   git checkout main
   git checkout -b m5stack-atoms3r
   ```

2. **Install dependencies** (Astro/Starlight site, needs Node 20+)
   ```bash
   npm install
   ```

### Steps

1. **Copy your device folder**
   ```bash
   # From your project root
   cp -r device-submission/m5stack-atoms3r \
         devices.esphome.io/src/docs/devices/
   ```

2. **Preview locally**
   ```bash
   cd devices.esphome.io
   npm run dev
   # Opens http://localhost:4321/
   ```

3. **Verify your device page**
   - Check all content displays correctly
   - Verify images load properly
   - Test the YAML configuration formatting

4. **Commit and push**
   ```bash
   git add src/docs/devices/m5stack-atoms3r
   git commit -m "Add M5Stack AtomS3R device"
   git push origin m5stack-atoms3r
   ```

5. **Create Pull Request**
   - Go to https://github.com/esphome/devices.esphome.io
   - Create PR from your branch
   - Netlify will automatically create a preview
   - Wait for community review

## Resources

- [ESPHome Devices - Adding Devices Guide](https://devices.esphome.io/adding-devices)
- [ESPHome Devices Repository](https://github.com/esphome/devices.esphome.io)
- [M5Stack AtomS3R Official Docs](https://docs.m5stack.com/en/core/AtomS3R)

## Questions?

Check the ESPHome Discord or GitHub discussions for help with device submissions.
