#include "esphome/core/log.h"
#include "esphome/core/hal.h"
#include "m5stack_display_backlight_output.h"

namespace esphome {
namespace m5stack_display_backlight_output {

static const char *TAG = "m5stack_display_backlight_output.output";
// see table 26 in datasheet https://web.archive.org/web/20240327023921/https://www.ti.com/lit/ds/symlink/lp5562.pdf
static const uint8_t REG_ENABLE  = 0x00;
static const uint8_t REG_CONFIG  = 0x08;
static const uint8_t REG_LED_MAP = 0x70;
static const uint8_t REG_PWM_W   = 0x0e;

void M5StackDisplayBacklightOutput::setup() {
  // see https://github.com/m5stack/M5GFX/blob/b2422cdb4735159209c2097d425c0756505b9a81/src/M5GFX.cpp#L566
  uint8_t c = 0x40;
  this->write_register(REG_ENABLE, &c, 1);
  delay(1);
  c = 0x01;
  this->write_register(REG_CONFIG, &c, 1);
  c = 0x00;
  this->write_register(REG_LED_MAP, &c, 1);
}

void M5StackDisplayBacklightOutput::write_state(float state) {
  uint8_t brightness = state * 255;

  ESP_LOGCONFIG(TAG, "Brightness: %d", brightness);
  this->write_register_(REG_PWM_W, brightness);
}

void M5StackDisplayBacklightOutput::dump_config() {
    ESP_LOGCONFIG(TAG, "Display Backlight Output");
    LOG_I2C_DEVICE(this);
}

bool M5StackDisplayBacklightOutput::write_register_(uint8_t reg, uint8_t value) {
  if (this->is_failed()) {
    ESP_LOGD(TAG, "Device marked failed");
    return false;
  }

  // using defaults for length (1) and stop (true)
  this->last_error_ = this->write_register(reg, &value, 1);
  if (this->last_error_ != i2c::ERROR_OK) {
    this->status_set_warning();
    ESP_LOGE(TAG, "write_register_(): I2C I/O error: Reg=0x%02X, Err=%d", reg, (int) this->last_error_);
    return false;
  }

  this->status_clear_warning();
  return true;
}

} //namespace m5stack_display_backlight_output
} //namespace esphome

