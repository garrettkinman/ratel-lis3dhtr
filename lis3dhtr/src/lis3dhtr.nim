# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.

# LIS3DHTR 3-axis accelerometer

import board / [i2c, times]
import lis3dhtr / constants
export i2c

type
  Lis3dhtrDevice* = object
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
proc start*(sensor: static[Lis3dhtrDevice]) =
  ## TODO: update the docstrings
  sensor.bus.writeRegister(sensor.address, CTRL_REG1, 0b0010_0111)

# TODO: don't need this long-term; will just use the methods below
proc readRaw*(sensor: static[Lis3dhtrDevice], ax, ay, az: var int16) =
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

proc begin*(sensor: static[Lis3dhtrDevice]) =
  let config5: uint8 = LIS3DHTR_REG_TEMP_ADC_PD_ENABLED or LIS3DHTR_REG_TEMP_TEMP_EN_DISABLED
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_TEMP_CFG, config5)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

  let config1: uint8 = LIS3DHTR_REG_ACCEL_CTRL_REG1_LPEN_NORMAL or  # Normal Mode
                    LIS3DHTR_REG_ACCEL_CTRL_REG1_AZEN_ENABLE or     # Acceleration Z-Axis Enabled
                    LIS3DHTR_REG_ACCEL_CTRL_REG1_AYEN_ENABLE or     # Acceleration Y-Axis Enabled
                    LIS3DHTR_REG_ACCEL_CTRL_REG1_AXEN_ENABLE        # Acceleration X-Axis Enabled
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG1, config1)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

  let config4: uint8 = LIS3DHTR_REG_ACCEL_CTRL_REG4_BDU_NOTUPDATED or # Continuous Update
                    LIS3DHTR_REG_ACCEL_CTRL_REG4_BLE_LSB or           # Data LSB @ lower address
                    LIS3DHTR_REG_ACCEL_CTRL_REG4_HS_DISABLE or        # High Resolution Disable
                    LIS3DHTR_REG_ACCEL_CTRL_REG4_ST_NORMAL or         # Normal Mode
                    LIS3DHTR_REG_ACCEL_CTRL_REG4_SIM_4WIRE            # 4-Wire Interface
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG4, config4)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

  sensor.setFullScaleRange(range16G)
  sensor.setOutputDataRate(rate400Hz)

proc setPowerMode*(sensor: static[Lis3dhtrDevice], mode: PowerType) = 
  # TODO
  discard

proc setFullScaleRange*(sensor: static[Lis3dhtrDevice], scaleRange: ScaleType) =
  # TODO
  discard

proc setOutputDataRate*(sensor: static[Lis3dhtrDevice], odr: ODRType) =
  # TODO
  discard

proc setHighSolution*(sensor: static[Lis3dhtrDevice], enable: bool) =
  # TODO
  discard

proc available*(sensor: static[Lis3dhtrDevice]): bool =
  # TODO
  discard

proc getAcceleration*(sensor: static[Lis3dhtrDevice], x: var float32, y: var float32, z: var float32) =
  # TODO
  discard

proc getAccelerationX*(sensor: static[Lis3dhtrDevice]): float32 =
  # TODO
  discard

proc getAccelerationY*(sensor: static[Lis3dhtrDevice]): float32 =
  # TODO
  discard

proc getAccelerationZ*(sensor: static[Lis3dhtrDevice]): float32 =
  # TODO
  discard

proc click*(sensor: static[Lis3dhtrDevice], c: uint8, clickThresh: uint8, limit: uint8 = 10, latency: uint8 = 20, window: uint8 = 255) =
  # TODO
  discard

proc openTemp*(sensor: static[Lis3dhtrDevice]) =
  # TODO
  discard

proc closeTemp*(sensor: static[Lis3dhtrDevice]) =
  # TODO
  discard

proc readbitADC1*(sensor: static[Lis3dhtrDevice]): uint16 =
  # TODO
  discard

proc readbitADC2*(sensor: static[Lis3dhtrDevice]): uint16 =
  # TODO
  discard

proc readbitADC3*(sensor: static[Lis3dhtrDevice]): uint16 =
  # TODO
  discard

proc getTemperature*(sensor: static[Lis3dhtrDevice]): int16 =
  # TODO
  discard

proc getDeviceID*(sensor: static[Lis3dhtrDevice]): uint8 =
  # TODO
  discard

proc reset*(sensor: static[Lis3dhtrDevice]) =
  # TODO
  discard
