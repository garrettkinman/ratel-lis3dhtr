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
    accRange: int16

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
proc start*(sensor: Lis3dhtrDevice) =
  ## TODO: update the docstrings
  sensor.bus.writeRegister(sensor.address, CTRL_REG1, 0b0010_0111)

# TODO: don't need this long-term; will just use the methods below
proc readRaw*(sensor: Lis3dhtrDevice, ax, ay, az: var int16) =
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

proc begin*(sensor: Lis3dhtrDevice) =
  ## Begins the device with a set of default settings
  ## and enables the x, y, and z axes
  let config5: uint8 =
                    (LIS3DHTR_REG_TEMP_ADC_PD_ENABLED) or
                    (LIS3DHTR_REG_TEMP_TEMP_EN_DISABLED)
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_TEMP_CFG, config5)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

  let config1: uint8 =
                    (LIS3DHTR_REG_ACCEL_CTRL_REG1_LPEN_NORMAL) or     # Normal Mode
                    (LIS3DHTR_REG_ACCEL_CTRL_REG1_AZEN_ENABLE) or     # Acceleration Z-Axis Enabled
                    (LIS3DHTR_REG_ACCEL_CTRL_REG1_AYEN_ENABLE) or     # Acceleration Y-Axis Enabled
                    (LIS3DHTR_REG_ACCEL_CTRL_REG1_AXEN_ENABLE)        # Acceleration X-Axis Enabled
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG1, config1)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

  let config4: uint8 =
                    (LIS3DHTR_REG_ACCEL_CTRL_REG4_BDU_NOTUPDATED) or  # Continuous Update
                    (LIS3DHTR_REG_ACCEL_CTRL_REG4_BLE_LSB) or         # Data LSB @ lower address
                    (LIS3DHTR_REG_ACCEL_CTRL_REG4_HS_DISABLE) or      # High Resolution Disable
                    (LIS3DHTR_REG_ACCEL_CTRL_REG4_ST_NORMAL) or       # Normal Mode
                    (LIS3DHTR_REG_ACCEL_CTRL_REG4_SIM_4WIRE)          # 4-Wire Interface
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG4, config4)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

  sensor.setFullScaleRange(range16G)
  sensor.setOutputDataRate(rate400Hz)

proc setPowerMode*(sensor: Lis3dhtrDevice, mode: PowerType) = 
  ## TODO: docstring
  let data: uint8 =
                (sensor.bus.readRegister(LIS3DHTR_REG_ACCEL_CTRL_REG1)) and
                (not LIS3DHTR_REG_ACCEL_CTRL_REG1_LPEN_MASK) or
                (mode.ord())
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG1, data)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

proc setFullScaleRange*(sensor: Lis3dhtrDevice, scaleRange: ScaleType) =
  ## TODO: docstring
  let data: uint8 =
                (sensor.bus.readRegister(LIS3DHTR_REG_ACCEL_CTRL_REG4)) and
                (not LIS3DHTR_REG_ACCEL_CTRL_REG4_FS_MASK) or
                (scaleRange.ord())
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG4, data)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

  sensor.accRange = case scaleRange:
    of range16G:
      1280
    of range8G:
      3968
    of range4G:
      7282
    of range2G:
      16000
    else:
      0 # should never happen

proc setOutputDataRate*(sensor: Lis3dhtrDevice, odr: ODRType) =
  ## TODO: docstring
  let data: uint8 =
                (sensor.bus.readRegister(LIS3DHTR_REG_ACCEL_CTRL_REG1)) and
                (not LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_MASK) or
                (odr.ord())
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG1, data)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

proc setHighSolution*(sensor: Lis3dhtrDevice, enable: bool) =
  ## TODO: docstring
  var data: uint8 = sensor.bus.readRegister(LIS3DHTR_REG_ACCEL_CTRL_REG4)
  uint8_t data = 0;
  data = readRegister(LIS3DHTR_REG_ACCEL_CTRL_REG4);

  if enable:
    data =
        (data) or
        (LIS3DHTR_REG_ACCEL_CTRL_REG4_HS_ENABLE)
  else:
    data =
        (data) and
        (not LIS3DHTR_REG_ACCEL_CTRL_REG4_HS_ENABLE)
  
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG4, data);

proc available*(sensor: Lis3dhtrDevice): bool =
  ## TODO: docstring
  let status: uint8 =
                  (sensor.bus.readRegister(LIS3DHTR_REG_ACCEL_STATUS2)) and
                  (LIS3DHTR_REG_ACCEL_STATUS2_UPDATE_MASK)
  return status.bool # TODO: double-check/test if this actually works

proc getAcceleration*(sensor: Lis3dhtrDevice, x, y, z: var float32) =
  ## TODO: docstring
  # read raw sensor data
  sensor.bus.start()
  sensor.bus.send(sensor.address)
  sensor.bus.send(LIS3DHTR_REG_ACCEL_OUT_X_L or 0x80) # set MSb of subaddress to 1 to read multiple
  sensor.bus.stop()

  sensor.bus.start()
  sensor.bus.send(sensor.address or 0x01)
  let
    ax: int16 =
            (sensor.bus.recv(false).int16) or
            (sensor.bus.recv(false).int16 shl 8)
    ay: int16 = 
            (sensor.bus.recv(false).int16) or
            (sensor.bus.recv(false).int16 shl 8)
    az: int16 =
            (sensor.bus.recv(false).int16) or
            (sensor.bus.recv(true).int16 shl 8)
  sensor.bus.stop()

  # convert the raw values to real values
  x = float(ax / sensor.accRange)
  y = float(ay / sensor.accRange)
  z = float(az / sensor.accRange)

proc getAccelerationX*(sensor: Lis3dhtrDevice): float32 =
  ## TODO: docstring
  # read raw sensor data
  sensor.bus.start()
  sensor.bus.send(sensor.address)
  sensor.bus.send(LIS3DHTR_REG_ACCEL_OUT_X_L or 0x80) # set MSb of subaddress to 1 to read multiple
  sensor.bus.stop()

  sensor.bus.start()
  sensor.bus.send(sensor.address or 0x01)
  let ax: int16 =
              (sensor.bus.recv(false).int16) or
              (sensor.bus.recv(true).int16 shl 8)
  sensor.bus.stop()

  # convert the raw values to real values
  return float(ax / sensor.accRange)

proc getAccelerationY*(sensor: Lis3dhtrDevice): float32 =
  ## TODO: docstring
  # read raw sensor data
  sensor.bus.start()
  sensor.bus.send(sensor.address)
  sensor.bus.send(LIS3DHTR_REG_ACCEL_OUT_Y_L or 0x80) # set MSb of subaddress to 1 to read multiple
  sensor.bus.stop()

  sensor.bus.start()
  sensor.bus.send(sensor.address or 0x01)
  let ay: int16 =
              (sensor.bus.recv(false).int16) or
              (sensor.bus.recv(true).int16 shl 8)
  sensor.bus.stop()

  # convert the raw values to real values
  return float(ay / sensor.accRange)

proc getAccelerationZ*(sensor: Lis3dhtrDevice): float32 =
  ## TODO: docstring
  # read raw sensor data
  sensor.bus.start()
  sensor.bus.send(sensor.address)
  sensor.bus.send(LIS3DHTR_REG_ACCEL_OUT_Z_L or 0x80) # set MSb of subaddress to 1 to read multiple
  sensor.bus.stop()

  sensor.bus.start()
  sensor.bus.send(sensor.address or 0x01)
  let az: int16 =
              (sensor.bus.recv(false).int16) or
              (sensor.bus.recv(true).int16 shl 8)
  sensor.bus.stop()

  # convert the raw values to real values
  return float(az / sensor.accRange)

proc click*(sensor: Lis3dhtrDevice, c: uint8, clickThresh: uint8, limit: uint8 = 10, latency: uint8 = 20, window: uint8 = 255) =
  ## TODO: docstring
  if (c == 0):
    let r: uint8 =
                (sensor.bus.readRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG3)) and
                (not 0x80)  # turn off I1_CLICK
    sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG3, r)
    sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CLICK_CFG, 0x00)
    return
  
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG3, 0x80)
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG5, 0x08)

  if (c == 1):
    sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CLICK_CFG, 0x15)
  elif (c == 2):
    sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CLICK_CFG, 0x2A)
  
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CLICK_THS, click_thresh);
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_TIME_LIMIT, limit);
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_TIME_LATENCY, latency);
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_TIME_WINDOW, window);

proc openTemp*(sensor: Lis3dhtrDevice) =
  ## TODO: docstring
  let config5: uint8 =
                    (LIS3DHTR_REG_TEMP_ADC_PD_ENABLED) or
                    (LIS3DHTR_REG_TEMP_TEMP_EN_ENABLED)
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_TEMP_CFG, config5)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

proc closeTemp*(sensor: Lis3dhtrDevice) =
  ## TODO: docstring
  let config5: uint8 =
                    (LIS3DHTR_REG_TEMP_ADC_PD_ENABLED) or
                    (LIS3DHTR_REG_TEMP_TEMP_EN_DISABLED)
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_TEMP_CFG, config5)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

proc readbitADC1*(sensor: Lis3dhtrDevice): uint16 =
  ## TODO: docstring
  # read raw sensor data
  sensor.bus.start()
  sensor.bus.send(sensor.address)
  sensor.bus.send(LIS3DHTR_REG_OUT_ADC1_L or 0x80) # set MSb of subaddress to 1 to read multiple
  sensor.bus.stop()

  sensor.bus.start()
  sensor.bus.send(sensor.address or 0x01)
  let adc1: int16 =
              (sensor.bus.recv(false).int16) or
              (sensor.bus.recv(true).int16 shl 8)
  sensor.bus.stop()

  # bit-wise fuckery I do not yet understand
  return ((0 - adc1) + 32768) shr 6

proc readbitADC2*(sensor: Lis3dhtrDevice): uint16 =
  ## TODO: docstring
  # read raw sensor data
  sensor.bus.start()
  sensor.bus.send(sensor.address)
  sensor.bus.send(LIS3DHTR_REG_OUT_ADC2_L or 0x80) # set MSb of subaddress to 1 to read multiple
  sensor.bus.stop()

  sensor.bus.start()
  sensor.bus.send(sensor.address or 0x01)
  let adc2: int16 =
              (sensor.bus.recv(false).int16) or
              (sensor.bus.recv(true).int16 shl 8)
  sensor.bus.stop()

  # bit-wise fuckery I do not yet understand
  return ((0 - adc2) + 32768) shr 6

proc readbitADC3*(sensor: Lis3dhtrDevice): uint16 =
  ## TODO: docstring
  # read raw sensor data
  sensor.bus.start()
  sensor.bus.send(sensor.address)
  sensor.bus.send(LIS3DHTR_REG_OUT_ADC3_L or 0x80) # set MSb of subaddress to 1 to read multiple
  sensor.bus.stop()

  sensor.bus.start()
  sensor.bus.send(sensor.address or 0x01)
  let adc3: int16 =
              (sensor.bus.recv(false).int16) or
              (sensor.bus.recv(true).int16 shl 8)
  sensor.bus.stop()

  # bit-wise fuckery I do not yet understand
  return ((0 - adc3) + 32768) shr 6

proc getTemperature*(sensor: Lis3dhtrDevice): int16 =
  ## TODO: docstring
  # read raw sensor data
  sensor.bus.start()
  sensor.bus.send(sensor.address)
  sensor.bus.send(LIS3DHTR_REG_OUT_ADC3_L or 0x80) # set MSb of subaddress to 1 to read multiple
  sensor.bus.stop()

  sensor.bus.start()
  sensor.bus.send(sensor.address or 0x01)
  let temp: int16 =
              (sensor.bus.recv(false).int16) or
              (sensor.bus.recv(true).int16 shl 8)
  sensor.bus.stop()

  # convert to actual value
  return (temp / 256) + 25

proc isConnection*(sensor: Lis3dhtrDevice): bool =
  ## TODO: docstring
  return (sensor.getDeviceID() == 0x33)

proc getDeviceID*(sensor: Lis3dhtrDevice): uint8 =
  ## TODO: docstring
  return sensor.bus.readRegister(LIS3DHTR_REG_ACCEL_WHO_AM_I)

proc reset*(sensor: Lis3dhtrDevice) =
  ## TODO: docstring
  ## doesn't seem to be implemented in the original arduino library
  discard