---
title: M5Stack AtomS3R
date-published: 2026-02-04
type: sensor
standard: global
board: esp32
---

<!-- TODO: Add device photos here
![M5Stack AtomS3R Front](m5stack-atoms3r-front.jpg "Front view with display")
![M5Stack AtomS3R Back](m5stack-atoms3r-back.jpg "Back view with connectors")
-->

## Product Description

The M5Stack AtomS3R is a compact ESP32-S3 development board featuring:

- ESP32-S3 microcontroller (Xtensa dual-core 32-bit LX7)
- 128x128 ILI9341 LCD display
- BMI270 6-axis IMU + BMM150 magnetometer
- LP5562 LED driver for display backlight
- USB-C connector
- Grove connector for expansion
- Single programmable button

## GPIO Pinout

| Pin | Function |
|-----|----------|
| GPIO 0 | I2C SCL |
| GPIO 14 | Display CS |
| GPIO 15 | SPI CLK |
| GPIO 21 | SPI MOSI |
| GPIO 41 | Button |
| GPIO 42 | Display DC |
| GPIO 45 | I2C SDA |
| GPIO 48 | Display Reset |

## I2C Devices

| Address | Device |
|---------|--------|
| 0x30 | LP5562 (Display Backlight) |
| 0x68 | BMI270 (IMU) |

Note: BMM150 magnetometer at 0x10 is accessed via BMI270's auxiliary I2C interface.

## Basic Configuration

```yaml
# Basic configuration for M5Stack AtomS3R
esphome:
  name: m5stack-atoms3r
  platformio_options:
    # Required for BMI270 sensor
    build_flags: -DI2C_BUFFER_LENGTH=8193

esp32:
  board: esp32-s3-devkitc-1
  framework:
    type: arduino

# Enable logging
logger:

# Enable Home Assistant API
api:

ota:

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  # Enable fallback hotspot
  ap:
    ssid: "AtomS3R Fallback"
    password: "12345678"

captive_portal:

# I2C Bus
i2c:
  sda: 45
  scl: 0
  scan: false
  frequency: 400kHz

# SPI Bus for Display
spi:
  clk_pin: 15
  mosi_pin: 21

# Display
display:
  - platform: ili9xxx
    model: st7789v
    dimensions:
      height: 128
      width: 128
      offset_height: 1
      offset_width: 2
    cs_pin: 14
    dc_pin: 42
    reset_pin: 48
    invert_colors: true
    rotation: 0
    lambda: |-
      it.print(64, 64, id(my_font), TextAlign::CENTER, "Hello World!");

# Button
binary_sensor:
  - platform: gpio
    name: "Button"
    pin:
      number: 41
      inverted: true
      mode:
        input: true
        pullup: true
    filters:
      - delayed_off: 10ms

# Font for display
font:
  - file: "gfonts://Roboto"
    id: my_font
    size: 20
```

## Advanced Configuration: IMU + Magnetometer + Backlight

The M5Stack AtomS3R includes a BMI270 6-axis IMU with a BMM150 magnetometer
wired through the BMI270's auxiliary I2C interface, plus an LP5562 LED
driver for the display backlight. Both are fully supported by upstream
ESPHome platforms - no custom components needed:

```yaml
# TODO: remove once esphome/esphome#18436 and #18453 are merged into a
# release - until then, both platforms need to be pulled in from the PRs.
external_components:
  - source: github://pr#18436
    components: [ bmi270 ]
  - source: github://pr#18453
    components: [ lp5562 ]

motion:
  - platform: bmi270
    id: bmi270_motion
    accelerometer_range: 8G
    gyroscope_range: 2000DPS
    aux_device: BMM150

sensor:
  - platform: motion
    motion_id: bmi270_motion
    type: acceleration_x
    name: "IMU Accel X"
  # ...acceleration_y/z, gyroscope_x/y/z follow the same pattern
  - platform: bmi270
    type: temperature
    name: "IMU Temperature"
  - platform: bmi270
    type: magnetic_field_x
    name: "IMU Mag X"
  # ...magnetic_field_y/z follow the same pattern

lp5562:
  - id: lp5562_1
    address: 0x30

output:
  - platform: lp5562
    id: displaybacklightoutput
    lp5562_id: lp5562_1
    channel: white

light:
  - platform: monochromatic
    output: displaybacklightoutput
    name: "Display Backlight"
```

See the [BMI270 motion platform docs](https://esphome.io/components/motion/bmi270/)
for the full set of accelerometer/gyroscope options. Note: BMI270 requires a
large I2C buffer, which is why `build_flags: -DI2C_BUFFER_LENGTH=8193` is
included in the Basic Configuration above.

## Use Cases

- **IMU applications**: Motion sensing, orientation detection
- **Status displays**: With Home Assistant integration, display sensor data or status information
- **Compact IoT projects**: Small form factor with built-in display and sensors
- **Presence indicators**: Display meeting status, door sensors, etc.

## Resources

- [M5Stack AtomS3R Documentation](https://docs.m5stack.com/en/core/AtomS3R)
- [ESP32-S3 Datasheet](https://www.espressif.com/sites/default/files/documentation/esp32-s3_datasheet_en.pdf)
- [BMI270 Datasheet](https://www.bosch-sensortec.com/products/motion-sensors/imus/bmi270/)
