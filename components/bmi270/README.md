# BMI270 IMU Sensor

The `bmi270` sensor platform allows you to use the Bosch BMI270 6-axis IMU sensor ([datasheet](https://www.bosch-sensortec.com/products/motion-sensors/imus/bmi270/)) with ESPHome. This sensor provides:

- 3-axis accelerometer (±2g to ±16g range)
- 3-axis gyroscope (±125°/s to ±2000°/s range)
- Internal temperature sensor
- Optional 3-axis BMM150 magnetometer via auxiliary I2C interface

The BMI270 communicates via I2C (address 0x68 by default) and requires uploading a configuration blob during initialization. The optional BMM150 magnetometer is accessed through the BMI270's auxiliary I2C master interface, not directly on the main I2C bus.

## Hardware Setup

**I2C Connection:**
- BMI270 default address: `0x68` (alternative: `0x69`)
- BMM150 auxiliary address: `0x10` (fixed, accessed via BMI270)

**Important:** The BMI270 initialization requires uploading an 8KB configuration blob. You **must** configure your build with a large I2C buffer:

```yaml
esphome:
  platformio_options:
    build_flags: -DI2C_BUFFER_LENGTH=8193
```

Without this flag, initialization will fail.

## Configuration

### Full Example (with magnetometer)

```yaml
# Example configuration with all sensors enabled
esphome:
  platformio_options:
    build_flags: -DI2C_BUFFER_LENGTH=8193

i2c:
  sda: 21
  scl: 22
  scan: true

sensor:
  - platform: bmi270
    address: 0x68
    update_interval: 60s
    acceleration_x:
      name: "BMI270 Acceleration X"
      filters:
        - sliding_window_moving_average:
            window_size: 5
            send_every: 5
    acceleration_y:
      name: "BMI270 Acceleration Y"
    acceleration_z:
      name: "BMI270 Acceleration Z"
    gyroscope_x:
      name: "BMI270 Gyroscope X"
    gyroscope_y:
      name: "BMI270 Gyroscope Y"
    gyroscope_z:
      name: "BMI270 Gyroscope Z"
    field_strength_x:
      name: "BMI270 Magnetic Field X"
    field_strength_y:
      name: "BMI270 Magnetic Field Y"
    field_strength_z:
      name: "BMI270 Magnetic Field Z"
    temperature:
      name: "BMI270 Temperature"
```

### Minimal Example (accelerometer only)

```yaml
esphome:
  platformio_options:
    build_flags: -DI2C_BUFFER_LENGTH=8193

i2c:
  sda: 21
  scl: 22

sensor:
  - platform: bmi270
    acceleration_x:
      name: "Accel X"
    acceleration_y:
      name: "Accel Y"
    acceleration_z:
      name: "Accel Z"
```

## Configuration Variables

**Base Configuration:**
- **address** (*Optional*, int): I2C address of the sensor. Defaults to `0x68`.
- **update_interval** (*Optional*, Time): The interval to check the sensor. Defaults to `60s`.

**Sensor Options:**

All sensor options support standard ESPHome sensor configuration (name, filters, etc.):

- **acceleration_x** (*Optional*): Acceleration on the X-axis in m/s².
- **acceleration_y** (*Optional*): Acceleration on the Y-axis in m/s².
- **acceleration_z** (*Optional*): Acceleration on the Z-axis in m/s².
- **gyroscope_x** (*Optional*): Angular velocity on the X-axis in °/s.
- **gyroscope_y** (*Optional*): Angular velocity on the Y-axis in °/s.
- **gyroscope_z** (*Optional*): Angular velocity on the Z-axis in °/s.
- **field_strength_x** (*Optional*): Magnetic field strength on the X-axis in µT. Requires BMM150 magnetometer.
- **field_strength_y** (*Optional*): Magnetic field strength on the Y-axis in µT. Requires BMM150 magnetometer.
- **field_strength_z** (*Optional*): Magnetic field strength on the Z-axis in µT. Requires BMM150 magnetometer.
- **temperature** (*Optional*): Temperature in °C from the BMI270 internal sensor.

## Sensor Details

### Accelerometer
- **Range:** Currently fixed at ±8g
- **Resolution:** ~0.00024 g per LSB
- **Unit:** m/s²

### Gyroscope
- **Range:** Currently fixed at ±2000°/s
- **Resolution:** ~0.061°/s per LSB
- **Unit:** °/s

### Magnetometer (BMM150)
- **Range:** ±1300µT (X/Y axes), ±2500µT (Z axis)
- **Resolution:** ~0.3µT per LSB
- **Unit:** µT (microtesla)
- **Access method:** Via BMI270 auxiliary I2C interface
- **Address:** 0x10 (not visible on main I2C scan)

### Temperature
- **Range:** -40°C to +85°C
- **Resolution:** ~0.002°C per LSB
- **Offset:** 23°C
- **Unit:** °C

## Limitations

This component provides basic functionality with the following limitations:

1. **Fixed sensor ranges:** Accelerometer and gyroscope ranges are hardcoded (±8g, ±2000°/s). Configuration of different ranges is not currently supported.

2. **No calibration support:** The component does not support offset calibration or compensation. Raw sensor data is converted using fixed scale factors. For improved accuracy, use ESPHome filters like `calibrate_linear` or `sliding_window_moving_average`.

3. **Magnetometer auto-detection:** The BMM150 magnetometer is automatically detected and initialized if present on the auxiliary interface. There is no configuration to disable it.

4. **Fixed auxiliary address:** The BMM150 auxiliary address is hardcoded to 0x10 (standard for BMM150).

5. **Basic filtering only:** Advanced features of the BMI270 (step counter, significant motion detection, etc.) are not currently supported. Use ESPHome's built-in sensor filters for data processing.

## Hardware Notes

### Tested Hardware
- **M5Stack AtomS3R:** Verified working configuration with BMI270 + BMM150

### I2C Configuration
The component has been tested with:
- I2C frequency: 400kHz
- I2C scan: Can be disabled (`scan: false`) to speed up boot time since addresses are fixed

### Known Issues
- **Large I2C buffer required:** The BMI270 configuration blob is approximately 8KB and must be uploaded during initialization. Ensure `-DI2C_BUFFER_LENGTH=8193` is set in `platformio_options`.
- **Initialization time:** First boot may take several seconds due to configuration upload and sensor initialization.

## Technical Details

### Initialization Sequence

The BMI270 requires a specific initialization sequence:

1. **Soft reset:** Reset the sensor to default state
2. **Configuration upload:** Upload 8KB configuration blob to sensor
3. **Power configuration:** Enable accelerometer and gyroscope
4. **Auxiliary setup** (if BMM150 present):
   - Enable auxiliary I2C interface
   - Configure BMI270 as I2C master
   - Initialize BMM150 magnetometer
   - Configure data passthrough to main data registers

### Data Register Layout

Sensor data is read from a 20-byte block starting at register 0x04:

- Bytes 0-5: Magnetometer X, Y, Z (if enabled)
- Bytes 6-11: Accelerometer X, Y, Z
- Bytes 12-17: Gyroscope X, Y, Z

An interrupt status register (0x1D) indicates which sensors have new data ready.

### Auxiliary I2C Interface

The BMI270 includes an auxiliary I2C master interface that allows it to communicate with a secondary sensor (BMM150 magnetometer). The BMI270:
- Acts as I2C master to the BMM150
- Automatically reads BMM150 data at configured intervals
- Passes magnetometer data to the main data registers
- Presents all data (accel, gyro, mag) in a single 20-byte read

This means the BMM150 does **not** appear on the main I2C bus and cannot be accessed directly.

## Example: M5Stack AtomS3R

Complete configuration for M5Stack AtomS3R with BMI270/BMM150:

```yaml
esphome:
  name: m5stack-atoms3r
  platformio_options:
    build_flags: -DI2C_BUFFER_LENGTH=8193

esp32:
  board: esp32-s3-devkitc-1
  framework:
    type: arduino

i2c:
  sda: 45
  scl: 0
  scan: false
  frequency: 400kHz

sensor:
  - platform: bmi270
    update_interval: 5s
    acceleration_x:
      name: "IMU Accel X"
    acceleration_y:
      name: "IMU Accel Y"
    acceleration_z:
      name: "IMU Accel Z"
    gyroscope_x:
      name: "IMU Gyro X"
    gyroscope_y:
      name: "IMU Gyro Y"
    gyroscope_z:
      name: "IMU Gyro Z"
    field_strength_x:
      name: "IMU Mag X"
    field_strength_y:
      name: "IMU Mag Y"
    field_strength_z:
      name: "IMU Mag Z"
    temperature:
      name: "IMU Temperature"
```

## References

- [BMI270 Datasheet](https://www.bosch-sensortec.com/products/motion-sensors/imus/bmi270/)
- [BMM150 Datasheet](https://www.bosch-sensortec.com/products/motion-sensors/magnetometers/bmm150/)
- [Bosch BMI270 Sensor API](https://github.com/BoschSensortec/BMI270-Sensor-API)
- [M5Unified Implementation](https://github.com/m5stack/M5Unified/tree/master/src/utility/imu)

## See Also

- [ESPHome Sensor Core](https://esphome.io/components/sensor/index.html)
- [ESPHome I2C Bus](https://esphome.io/components/i2c.html)
- [ESPHome Sensor Filters](https://esphome.io/components/sensor/index.html#sensor-filters)
