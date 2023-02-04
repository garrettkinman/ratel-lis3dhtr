# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.

# LIS3DHTR 3-axis accelerometer

import board
import board / [i2c]
import ratel_LIS3DHTR / constants
export i2c

type
  LIS3DHTRDevice* = object
    bus*: I2c
    address*: uint8

  # power mode
  PowerType* = enum
    normal = LIS3DHTR_REG_ACCEL_CTRL_REG1_LPEN_NORMAL,
    lowPower = LIS3DHTR_REG_ACCEL_CTRL_REG1_LPEN_LOW
  
  # measurement range
  ScaleType* = enum
    range2G = LIS3DHTR_REG_ACCEL_CTRL_REG4_FS_2G,
    range4G = LIS3DHTR_REG_ACCEL_CTRL_REG4_FS_4G,
    range8G = LIS3DHTR_REG_ACCEL_CTRL_REG4_FS_8G,
    range16G = LIS3DHTR_REG_ACCEL_CTRL_REG4_FS_16G

  # output data rate
  ODRType* = enum
    powerDown = LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_PD,
    rate1Hz = LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_1,
    rate10Hz = LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_10,
    rate25Hz = LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_25,
    rate50Hz = LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_50,
    rate100Hz = LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_100,
    rate200Hz = LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_200,
    rate400Hz = LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_400,
    rate1600Hz = LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_1_6K,
    rate5kHz = LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_5K

# ~~~~~~~~~~~~~~~
# OLD STUFF BEGIN
# ~~~~~~~~~~~~~~~

# TODO: make these not global
const
  WHO_AM_I: uint8 = 0x0F # subaddress of the device ID register
  CTRL_REG1: uint8 = 0x20 # subaddress of the first control register
  OUT_X_L: uint8 = 0x28 # starting subaddress of the output registers

# TODO: change to begin(...), or is this even necessary? maybe just for some default config?
proc start*(sensor: static[LIS3DHTRDevice]) =
  ## TODO: update the docstrings
  sensor.bus.writeRegister(sensor.address, CTRL_REG1, 0b0010_0111)

# TODO: don't need this long-term; will just use the methods below
proc readRaw*(sensor: static[LIS3DHTRDevice], ax, ay, az: var int16) =
  ## Initiates the reading of raw sensor data, storing it in the given variables
  sensor.bus.start()
  sensor.bus.send(sensor.address)
  sensor.bus.send(OUT_X_L or 0x80) # set MSb of subaddress to 1 to read multiple
  sensor.bus.stop()

  sensor.bus.start()
  sensor.bus.send(sensor.address or 0x01)
  ax =
    (sensor.bus.recv(false).int16) or
    (sensor.bus.recv(false).int16 shl 8)
  ay = 
    (sensor.bus.recv(false).int16) or
    (sensor.bus.recv(false).int16 shl 8)
  az =
    (sensor.bus.recv(false).int16) or
    (sensor.bus.recv(true).int16 shl 8)
  sensor.bus.stop()

# ~~~~~~~~~~~~~
# OLD STUFF END
# ~~~~~~~~~~~~~

proc begin*(sensor: static[LIS3DHTRDevice]) =
  # TODO
  discard

proc setPowerMode*(sensor: static[LIS3DHTRDevice], mode: PowerType) = 
  # TODO
  discard

proc setFullScaleRange*(sensor: static[LIS3DHTRDevice], scaleRange: ScaleType) =
  # TODO
  discard

proc setOutputDataRate*(sensor: static[LIS3DHTRDevice], odr: ODRType) =
  # TODO
  discard

proc setHighSolution*(sensor: static[LIS3DHTRDevice], enable: bool) =
  # TODO
  discard

proc available*(sensor: static[LIS3DHTRDevice]): bool =
  # TODO
  discard

proc getAcceleration*(sensor: static[LIS3DHTRDevice], x: var float32, y: var float32, z: var float32) =
  # TODO
  discard

proc getAccelerationX*(sensor: static[LIS3DHTRDevice]): float32 =
  # TODO
  discard

proc getAccelerationY*(sensor: static[LIS3DHTRDevice]): float32 =
  # TODO
  discard

proc getAccelerationZ*(sensor: static[LIS3DHTRDevice]): float32 =
  # TODO
  discard

proc click*(sensor: static[LIS3DHTRDevice], c: uint8, clickThresh: uint8, limit: uint8 = 10, latency: uint8 = 20, window: uint8 = 255) =
  # TODO
  discard

proc openTemp*(sensor: static[LIS3DHTRDevice]) =
  # TODO
  discard

proc closeTemp*(sensor: static[LIS3DHTRDevice]) =
  # TODO
  discard

proc readbitADC1*(sensor: static[LIS3DHTRDevice]): uint16 =
  # TODO
  discard

proc readbitADC2*(sensor: static[LIS3DHTRDevice]): uint16 =
  # TODO
  discard

proc readbitADC3*(sensor: static[LIS3DHTRDevice]): uint16 =
  # TODO
  discard

proc getTemperature*(sensor: static[LIS3DHTRDevice]): int16 =
  # TODO
  discard

proc getDeviceID*(sensor: static[LIS3DHTRDevice]): uint8 =
  # TODO
  discard

proc reset*(sensor: static[LIS3DHTRDevice]) =
  # TODO
  discard
