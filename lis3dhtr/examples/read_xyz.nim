import board
import board / [times, serial, progmem, i2c]
import std / strformat
import lis3dhtr

Serial.init(9600.Hz)
Led.output()
I2cBus.init()

# TODO: test this as an imported library, then test it with the new code

const
  LIS3DHTR_ADDR: uint8 = 0x19 # slave address of the accelerometer
  sensor = LIS3DHTRDevice(bus: I2cBus, address: LIS3DHTR_ADDR shl 1)

# enable polling, set sample rate to 10 Hz
sensor.start()

var
  ax: int16
  ay: int16
  az: int16

while true:
  Led.high()
  sensor.readRaw(ax, ay, az)
  Serial.send &"x: {ax}, y: {ay}, z: {az}\p"
  delayMs(1000)

  Led.low()
  delayMs(1000)