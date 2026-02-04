# M5Stack AtomS3R Device Submission

This directory contains files for submitting the M5Stack AtomS3R device configuration to the ESPHome Devices repository.

## Two Separate Submissions

Your project involves **two different repositories**:

### 1. Component Submission → esphome/esphome
**What:** BMI270 sensor component (generic, reusable)
**Repository:** https://github.com/esphome/esphome
**Location:** `components/bmi270/`
**Status:** ✅ Ready for submission

### 2. Device Submission → esphome/esphome-devices
**What:** M5Stack AtomS3R device configuration
**Repository:** https://github.com/esphome/esphome-devices
**Location:** This directory (`device-submission/M5Stack-AtomS3R/`)
**Status:** 📝 Needs photos and review

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
- [x] Advanced Configuration (with BMI270)
- [x] Use Cases
- [x] Resources

## Adding Photos

1. Take photos of your M5Stack AtomS3R device
2. Save them in this directory (`device-submission/M5Stack-AtomS3R/`)
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

1. **BMI270 component should be submitted first** (or note it's pending)
   - Either reference the PR number in your device config
   - Or use `external_components:` pointing to your GitHub repo

2. **Fork the esphome-devices repository**
   ```bash
   git clone https://github.com/esphome/esphome-devices.git
   cd esphome-devices
   git checkout main
   git checkout -b m5stack-atoms3r
   ```

3. **Install dependencies**
   ```bash
   pnpm install
   ```

### Steps

1. **Copy your device folder**
   ```bash
   # From your project root
   cp -r device-submission/M5Stack-AtomS3R \
         esphome-devices/src/docs/devices/
   ```

2. **Preview locally**
   ```bash
   cd esphome-devices
   pnpm start
   # Opens http://localhost:3000/
   ```

3. **Verify your device page**
   - Check all content displays correctly
   - Verify images load properly
   - Test the YAML configuration formatting

4. **Commit and push**
   ```bash
   git add src/docs/devices/M5Stack-AtomS3R
   git commit -m "Add M5Stack AtomS3R device"
   git push origin m5stack-atoms3r
   ```

5. **Create Pull Request**
   - Go to https://github.com/esphome/esphome-devices
   - Create PR from your branch
   - Netlify will automatically create a preview
   - Wait for community review

## Configuration Notes

### BMI270 Component Reference

The device configuration includes two options:

**Option 1: After BMI270 is merged into ESPHome**
```yaml
sensor:
  - platform: bmi270
    # ... configuration
```

**Option 2: Before BMI270 is merged (using external component)**
```yaml
external_components:
  - source: github://yourusername/m5stack-atoms3r-components
    components: [ bmi270 ]

sensor:
  - platform: bmi270
    # ... configuration
```

Update the `index.md` based on the BMI270 component status at submission time.

### Display Backlight

The LP5562 backlight controller is mentioned but requires a custom component. Since this component is specific to M5Stack devices and not as universally applicable, you might consider:

1. Keeping it as an external component
2. Submitting it as a separate PR to ESPHome
3. Noting in the device docs that backlight control requires a custom component

## Timing

**Recommended order:**

1. ✅ **First:** Submit BMI270 component to esphome/esphome
   - Wait for review and merge (could take weeks)

2. **Then:** Submit M5Stack AtomS3R device to esphome/esphome-devices
   - Can reference the merged component
   - Or use `external_components:` if still pending

Alternatively, you can submit both simultaneously and update the device config once the component is merged.

## Resources

- [ESPHome Devices - Adding Devices Guide](https://devices.esphome.io/adding-devices)
- [ESPHome Devices Repository](https://github.com/esphome/esphome-devices)
- [M5Stack AtomS3R Official Docs](https://docs.m5stack.com/en/core/AtomS3R)

## Questions?

Check the ESPHome Discord or GitHub discussions for help with device submissions.
