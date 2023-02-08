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

# couldn't just add it as a field under Lis3dhtrDevice
# as that made it non-static
# hence, you really can only instantiate one device
# (maybe a cleaner solution is needed if one wants two
# or more devices)
var accRange: int16 = 0

proc begin*(sensor: static[Lis3dhtrDevice]) =
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

proc getRawAcceleration*(sensor: static[Lis3dhtrDevice], ax, ay, az: var int16) =
  ## Retrieves raw acceleration values (before conversion to float),
  ## which may be helpful for systems without a floating point unit
  # read raw sensor data
  sensor.bus.start()
  sensor.bus.send(sensor.address)
  sensor.bus.send(LIS3DHTR_REG_ACCEL_OUT_X_L or 0x80) # set MSb of subaddress to 1 to read multiple
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

proc setPowerMode*(sensor: static[Lis3dhtrDevice], mode: PowerType) = 
  ## Sets the power mode (low-power or normal)
  let data: uint8 =
                (sensor.bus.readRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG1)) and
                (not LIS3DHTR_REG_ACCEL_CTRL_REG1_LPEN_MASK) or
                (mode.ord().uint8)
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG1, data)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

proc setFullScaleRange*(sensor: static[Lis3dhtrDevice], scaleRange: ScaleType) =
  ## Sets the scaling range of accelerometer sensing
  let data: uint8 =
                (sensor.bus.readRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG4)) and
                (not LIS3DHTR_REG_ACCEL_CTRL_REG4_FS_MASK) or
                (scaleRange.ord().uint8)
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG4, data)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

  accRange = case scaleRange:
    of range16G:
      1280
    of range8G:
      3968
    of range4G:
      7282
    of range2G:
      16000

proc setOutputDataRate*(sensor: static[Lis3dhtrDevice], odr: ODRType) =
  ## Sets the output data rate (in Hz)
  let data: uint8 =
                (sensor.bus.readRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG1)) and
                (not LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_MASK) or
                (odr.ord().uint8)
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG1, data)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

proc setHighSolution*(sensor: static[Lis3dhtrDevice], enable: bool) =
  ## TODO: docstring
  var data: uint8 = sensor.bus.readRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG4)

  if enable:
    data =
        (data) or
        (LIS3DHTR_REG_ACCEL_CTRL_REG4_HS_ENABLE)
  else:
    data =
        (data) and
        (not LIS3DHTR_REG_ACCEL_CTRL_REG4_HS_ENABLE)
  
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_ACCEL_CTRL_REG4, data);

proc available*(sensor: static[Lis3dhtrDevice]): bool =
  ## TODO: docstring
  let status: uint8 =
                  (sensor.bus.readRegister(sensor.address, LIS3DHTR_REG_ACCEL_STATUS2)) and
                  (LIS3DHTR_REG_ACCEL_STATUS2_UPDATE_MASK)
  return status.bool # TODO: double-check/test if this actually works

proc getAcceleration*(sensor: static[Lis3dhtrDevice], x, y, z: var float32) =
  ## Retrieves acceleration values (in Gs)
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
  x = float(ax / accRange)
  y = float(ay / accRange)
  z = float(az / accRange)

proc getAccelerationX*(sensor: static[Lis3dhtrDevice]): float32 =
  ## Retrieves x-axis acceleration value (in Gs)
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
  return float(ax / accRange)

proc getAccelerationY*(sensor: static[Lis3dhtrDevice]): float32 =
  ## Retrieves y-axis acceleration value (in Gs)
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
  return float(ay / accRange)

proc getAccelerationZ*(sensor: static[Lis3dhtrDevice]): float32 =
  ## Retrieves z-axis acceleration value (in Gs)
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
  return float(az / accRange)

proc click*(sensor: static[Lis3dhtrDevice], c: uint8, clickThresh: uint8, limit: uint8 = 10, latency: uint8 = 20, window: uint8 = 255) =
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

proc openTemp*(sensor: static[Lis3dhtrDevice]) =
  ## TODO: docstring
  let config5: uint8 =
                    (LIS3DHTR_REG_TEMP_ADC_PD_ENABLED) or
                    (LIS3DHTR_REG_TEMP_TEMP_EN_ENABLED)
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_TEMP_CFG, config5)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

proc closeTemp*(sensor: static[Lis3dhtrDevice]) =
  ## TODO: docstring
  let config5: uint8 =
                    (LIS3DHTR_REG_TEMP_ADC_PD_ENABLED) or
                    (LIS3DHTR_REG_TEMP_TEMP_EN_DISABLED)
  sensor.bus.writeRegister(sensor.address, LIS3DHTR_REG_TEMP_CFG, config5)
  delayMs(LIS3DHTR_CONVERSIONDELAY)

proc readbitADC1*(sensor: static[Lis3dhtrDevice]): uint16 =
  ## Retrieves the ADC output from ADC1
  # read raw data
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

proc readbitADC2*(sensor: static[Lis3dhtrDevice]): uint16 =
  ## Retrieves the ADC output from ADC2
  # read raw data
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

proc readbitADC3*(sensor: static[Lis3dhtrDevice]): uint16 =
  ## Retrieves the ADC output from ADC3
  # read raw data
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

proc getTemperature*(sensor: static[Lis3dhtrDevice]): int16 =
  ## Retrieves accelerometer temperature (in Celsius)
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

proc isConnection*(sensor: static[Lis3dhtrDevice]): bool =
  ## Verifies the device ID is correct (should always be 0x33)
  return (sensor.getDeviceID() == 0x33)

proc getDeviceID*(sensor: static[Lis3dhtrDevice]): uint8 =
  ## Retrieves the device ID (should always be 0x33)
  return sensor.bus.readRegister(sensor.address, LIS3DHTR_REG_ACCEL_WHO_AM_I)

proc reset*(sensor: static[Lis3dhtrDevice]) =
  ## TODO: docstring
  ## doesn't seem to be implemented in the original arduino library
  ## despite being in its header file
  discard
