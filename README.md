# ratel-lis3dhtr
This is an implementation of the LIS3DHTR 3-axis accelerometer for [Ratel](https://ratel.peterme.net). This replicates the [Arduino library](https://github.com/Seeed-Studio/Seeed_Arduino_LIS3DHTR).

# Installation
`nimble install https://github.com/garrettkinman/ratel-lis3dhtr`

# Usage
```nim
import board
import board / [times, serial, i2c]
import std / strformat
import lis3dhtr
import lis3dhtr / constants

Serial.init(9600.Hz)
Led.output()
I2cBus.init()

# remember to shl 1, as the address is in the 7 MSbits
const sensor: LIS3DHTRDevice = LIS3DHTRDevice(bus: I2cBus, address: LIS3DHTR_ADDRESS_UPDATED shl 1)
sensor.begin()
delayMs(100)

# tiny func for displaying floats over Serial from MCUs
# that struggle with formatting strings with floats
# e.g., the arduino uno
func f2i(f: float32): int =
  return (f * 1000).toInt

var
  x: float32 = 0.0
  y: float32 = 0.0
  z: float32 = 0.0

while true:
  Led.high()
  sensor.getAcceleration(x, y, z)
  Serial.send &"x: {x.f2i()}, y: {y.f2i()}, z: {z.f2i()}\p"
  delayMs(1000)

  Led.low()
  delayMs(1000)
```
