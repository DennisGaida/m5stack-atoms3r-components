---
title: M5Stack AtomS3R
date-published: 2026-02-04
type: sensor
standard: global
board: esp32
difficulty: 2
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

## Advanced Configuration with BMI270 Sensor

The M5Stack AtomS3R includes a BMI270 6-axis IMU with BMM150 magnetometer. To use these sensors:

```yaml
# Add to the basic configuration above

# External component (until BMI270 is in ESPHome core)
external_components:
  - source: github://yourusername/m5stack-atoms3r-components
    components: [ bmi270 ]

sensor:
  - platform: bmi270
    address: 0x68
    update_interval: 60s
    acceleration_x:
      name: "Acceleration X"
    acceleration_y:
      name: "Acceleration Y"
    acceleration_z:
      name: "Acceleration Z"
    gyroscope_x:
      name: "Gyroscope X"
    gyroscope_y:
      name: "Gyroscope Y"
    gyroscope_z:
      name: "Gyroscope Z"
    field_strength_x:
      name: "Magnetic Field X"
    field_strength_y:
      name: "Magnetic Field Y"
    field_strength_z:
      name: "Magnetic Field Z"
    temperature:
      name: "IMU Temperature"
```

Note: The BMI270 component requires a large I2C buffer, which is why `build_flags: -DI2C_BUFFER_LENGTH=8193` is included in the configuration.

## Display Backlight Control

The display backlight is controlled by an LP5562 LED driver. A custom component is required for full control. Without the component, the backlight operates at full brightness by default.

## Use Cases

- **IMU applications**: Motion sensing, orientation detection
- **Status displays**: With Home Assistant integration, display sensor data or status information
- **Compact IoT projects**: Small form factor with built-in display and sensors
- **Presence indicators**: Display meeting status, door sensors, etc.

## Resources

- [M5Stack AtomS3R Documentation](https://docs.m5stack.com/en/core/AtomS3R)
- [ESP32-S3 Datasheet](https://www.espressif.com/sites/default/files/documentation/esp32-s3_datasheet_en.pdf)
- [BMI270 Datasheet](https://www.bosch-sensortec.com/products/motion-sensors/imus/bmi270/)
