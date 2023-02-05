
const
    # I2C ADDRESS/BITS
    LIS3DHTR_DEFAULT_ADDRESS*: uint8 = 0x18                     # 3C >> 1 = 7-bit default
    LIS3DHTR_ADDRESS_UPDATED*: uint8 = 0x19                     #

    # CONVERSION DELAY (in mS)
    LIS3DHTR_CONVERSIONDELAY* = 100                             # TODO: type?

    # ADC REGISTERS
    LIS3DHTR_REG_OUT_ADC1_L*: uint8 = 0x08                      # Auxiliary 10-bit ADC Channel 1 Conversion, Low Register
    LIS3DHTR_REG_OUT_ADC1_H*: uint8 = 0x09                      # Auxiliary 10-bit ADC Channel 1 Conversion, High Register
    LIS3DHTR_REG_OUT_ADC2_L*: uint8 = 0x0A                      # Auxiliary 10-bit ADC Channel 2 Conversion, Low Register
    LIS3DHTR_REG_OUT_ADC2_H*: uint8 = 0x0B                      # Auxiliary 10-bit ADC Channel 2 Conversion, High Register
    LIS3DHTR_REG_OUT_ADC3_L*: uint8 = 0x0C                      # Auxiliary 10-bit ADC Channel 3 Conversion, Low Register
    LIS3DHTR_REG_OUT_ADC3_H*: uint8 = 0x0D                      # Auxiliary 10-bit ADC Channel 3 Conversion, High Register

    # ACCELEROMETER REGISTERS
    LIS3DHTR_REG_ACCEL_STATUS*: uint8 = 0x07                    # Status Register
    LIS3DHTR_REG_ACCEL_OUT_ADC1_L*: uint8 = 0x28                # 1-Axis Acceleration Data Low Register
    LIS3DHTR_REG_ACCEL_OUT_ADC1_H*: uint8 = 0x29                # 1-Axis Acceleration Data High Register
    LIS3DHTR_REG_ACCEL_OUT_ADC2_L*: uint8 = 0x2A                # 2-Axis Acceleration Data Low Register
    LIS3DHTR_REG_ACCEL_OUT_ADC2_H*: uint8 = 0x2B                # 2-Axis Acceleration Data High Register
    LIS3DHTR_REG_ACCEL_OUT_ADC3_L*: uint8 = 0x2C                # 3-Axis Acceleration Data Low Register
    LIS3DHTR_REG_ACCEL_OUT_ADC3_H*: uint8 = 0x2D                # 3-Axis Acceleration Data High Register
    LIS3DHTR_REG_ACCEL_WHO_AM_I*: uint8 = 0x0F                  # Device identification Register
    LIS3DHTR_REG_TEMP_CFG*: uint8 = 0x1F                        # Temperature Sensor Register
    LIS3DHTR_REG_ACCEL_CTRL_REG1*: uint8 = 0x20                 # Accelerometer Control Register 1
    LIS3DHTR_REG_ACCEL_CTRL_REG2*: uint8 = 0x21                 # Accelerometer Control Register 2
    LIS3DHTR_REG_ACCEL_CTRL_REG3*: uint8 = 0x22                 # Accelerometer Control Register 3
    LIS3DHTR_REG_ACCEL_CTRL_REG4*: uint8 = 0x23                 # Accelerometer Control Register 4
    LIS3DHTR_REG_ACCEL_CTRL_REG5*: uint8 = 0x24                 # Accelerometer Control Register 5
    LIS3DHTR_REG_ACCEL_CTRL_REG6*: uint8 = 0x25                 # Accelerometer Control Register 6
    LIS3DHTR_REG_ACCEL_REFERENCE*: uint8 = 0x26                 # Reference/Datacapture Register
    LIS3DHTR_REG_ACCEL_STATUS2*: uint8 = 0x27                   # Status Register 2
    LIS3DHTR_REG_ACCEL_OUT_X_L*: uint8 = 0x28                   # X-Axis Acceleration Data Low Register
    LIS3DHTR_REG_ACCEL_OUT_X_H*: uint8 = 0x29                   # X-Axis Acceleration Data High Register
    LIS3DHTR_REG_ACCEL_OUT_Y_L*: uint8 = 0x2A                   # Y-Axis Acceleration Data Low Register
    LIS3DHTR_REG_ACCEL_OUT_Y_H*: uint8 = 0x2B                   # Y-Axis Acceleration Data High Register
    LIS3DHTR_REG_ACCEL_OUT_Z_L*: uint8 = 0x2C                   # Z-Axis Acceleration Data Low Register
    LIS3DHTR_REG_ACCEL_OUT_Z_H*: uint8 = 0x2D                   # Z-Axis Acceleration Data High Register
    LIS3DHTR_REG_ACCEL_FIFO_CTRL*: uint8 = 0x2E                 # FIFO Control Register
    LIS3DHTR_REG_ACCEL_FIFO_SRC*: uint8 = 0x2F                  # FIFO Source Register
    LIS3DHTR_REG_ACCEL_INT1_CFG*: uint8 = 0x30                  # Interrupt Configuration Register
    LIS3DHTR_REG_ACCEL_INT1_SRC*: uint8 = 0x31                  # Interrupt Source Register
    LIS3DHTR_REG_ACCEL_INT1_THS*: uint8 = 0x32                  # Interrupt Threshold Register
    LIS3DHTR_REG_ACCEL_INT1_DURATION*: uint8 = 0x33             # Interrupt Duration Register
    LIS3DHTR_REG_ACCEL_CLICK_CFG*: uint8 = 0x38                 # Interrupt Click Recognition Register
    LIS3DHTR_REG_ACCEL_CLICK_SRC*: uint8 = 0x39                 # Interrupt Click Source Register
    LIS3DHTR_REG_ACCEL_CLICK_THS*: uint8 = 0x3A                 # Interrupt Click Threshold Register
    LIS3DHTR_REG_ACCEL_TIME_LIMIT*: uint8 = 0x3B                # Click Time Limit Register
    LIS3DHTR_REG_ACCEL_TIME_LATENCY*: uint8 = 0x3C              # Click Time Latency Register
    LIS3DHTR_REG_ACCEL_TIME_WINDOW*: uint8 = 0x3D               # Click Time Window Register

    # TEMPERATURE REGISTER DESCRIPTION
    LIS3DHTR_REG_TEMP_ADC_PD_MASK*: uint8 = 0x80                # ADC Power Enable Status
    LIS3DHTR_REG_TEMP_ADC_PD_DISABLED*: uint8 = 0x00            # ADC Disabled
    LIS3DHTR_REG_TEMP_ADC_PD_ENABLED*: uint8 = 0x80             # ADC Enabled

    LIS3DHTR_REG_TEMP_TEMP_EN_MASK*: uint8 = 0x40               # Temperature Sensor (T) Enable Status
    LIS3DHTR_REG_TEMP_TEMP_EN_DISABLED*: uint8 = 0x00           # Temperature Sensor (T) Disabled
    LIS3DHTR_REG_TEMP_TEMP_EN_ENABLED*: uint8 = 0x40            # Temperature Sensor (T) Enabled

    # ACCELEROMETER CONTROL REGISTER 1 DESCRIPTION
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_MASK*: uint8 = 0xF0       # Acceleration Data Rate Selection
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_PD*: uint8 = 0x00         # Power-Down Mode
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_1*: uint8 = 0x10          # Normal / Low Power Mode (1 Hz)
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_10*: uint8 = 0x20         # Normal / Low Power Mode (10 Hz)
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_25*: uint8 = 0x30         # Normal / Low Power Mode (25 Hz)
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_50*: uint8 = 0x40         # Normal / Low Power Mode (50 Hz)
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_100*: uint8 = 0x50        # Normal / Low Power Mode (100 Hz)
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_200*: uint8 = 0x60        # Normal / Low Power Mode (200 Hz)
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_400*: uint8 = 0x70        # Normal / Low Power Mode (400 Hz)
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_1_6K*: uint8 = 0x80       # Low Power Mode (1.6 KHz)
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AODR_5K*: uint8 = 0x90         # Normal (1.25 KHz) / Low Power Mode (5 KHz)

    LIS3DHTR_REG_ACCEL_CTRL_REG1_LPEN_MASK*: uint8 = 0x08       # Low Power Mode Enable
    LIS3DHTR_REG_ACCEL_CTRL_REG1_LPEN_NORMAL*: uint8 = 0x00     # Normal Mode
    LIS3DHTR_REG_ACCEL_CTRL_REG1_LPEN_LOW*: uint8 = 0x08        # Low Power Mode

    LIS3DHTR_REG_ACCEL_CTRL_REG1_AZEN_MASK*: uint8 = 0x04       # Acceleration Z-Axis Enable
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AZEN_DISABLE*: uint8 = 0x00    # Acceleration Z-Axis Disabled
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AZEN_ENABLE*: uint8 = 0x04     # Acceleration Z-Axis Enabled

    LIS3DHTR_REG_ACCEL_CTRL_REG1_AYEN_MASK*: uint8 = 0x02       # Acceleration Y-Axis Enable
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AYEN_DISABLE*: uint8 = 0x00    # Acceleration Y-Axis Disabled
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AYEN_ENABLE*: uint8 = 0x02     # Acceleration Y-Axis Enabled

    LIS3DHTR_REG_ACCEL_CTRL_REG1_AXEN_MASK*: uint8 = 0x01       # Acceleration X-Axis Enable
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AXEN_DISABLE*: uint8 = 0x00    # Acceleration X-Axis Disabled
    LIS3DHTR_REG_ACCEL_CTRL_REG1_AXEN_ENABLE*: uint8 = 0x01     # Acceleration X-Axis Enabled 

    # ACCELEROMETER CONTROL REGISTER 4 DESCRIPTION
    LIS3DHTR_REG_ACCEL_CTRL_REG4_BDU_MASK*: uint8 = 0x80        # Block Data Update
    LIS3DHTR_REG_ACCEL_CTRL_REG4_BDU_CONTINUOUS*: uint8 = 0x00  # Continuous Update
    LIS3DHTR_REG_ACCEL_CTRL_REG4_BDU_NOTUPDATED*: uint8 = 0x80  # Output Registers Not Updated until MSB and LSB Read

    LIS3DHTR_REG_ACCEL_CTRL_REG4_BLE_MASK*: uint8 = 0x40        # Big/Little Endian Data Selection
    LIS3DHTR_REG_ACCEL_CTRL_REG4_BLE_LSB*: uint8 = 0x00         # Data LSB @ lower address
    LIS3DHTR_REG_ACCEL_CTRL_REG4_BLE_MSB*: uint8 = 0x40         # Data MSB @ lower address

    LIS3DHTR_REG_ACCEL_CTRL_REG4_FS_MASK*: uint8 = 0x30         # Full-Scale Selection
    LIS3DHTR_REG_ACCEL_CTRL_REG4_FS_2G*: uint8 = 0x00           # +/- 2G
    LIS3DHTR_REG_ACCEL_CTRL_REG4_FS_4G*: uint8 = 0x10           # +/- 4G
    LIS3DHTR_REG_ACCEL_CTRL_REG4_FS_8G*: uint8 = 0x20           # +/- 8G
    LIS3DHTR_REG_ACCEL_CTRL_REG4_FS_16G*: uint8 = 0x30          # +/- 16G

    LIS3DHTR_REG_ACCEL_CTRL_REG4_HS_MASK*: uint8 = 0x08         # High Resolution Output Mode
    LIS3DHTR_REG_ACCEL_CTRL_REG4_HS_DISABLE*: uint8 = 0x00      # High Resolution Disable
    LIS3DHTR_REG_ACCEL_CTRL_REG4_HS_ENABLE*: uint8 = 0x08       # High Resolution Enable

    LIS3DHTR_REG_ACCEL_CTRL_REG4_ST_MASK*: uint8 = 0x06         # Self-Test Enable
    LIS3DHTR_REG_ACCEL_CTRL_REG4_ST_NORMAL*: uint8 = 0x00       # Normal Mode
    LIS3DHTR_REG_ACCEL_CTRL_REG4_ST_0*: uint8 = 0x02            # Self-Test 0
    LIS3DHTR_REG_ACCEL_CTRL_REG4_ST_1*: uint8 = 0x04            # Self-Test 1

    LIS3DHTR_REG_ACCEL_CTRL_REG4_SIM_MASK*: uint8 = 0x01        # SPI Serial Interface Mode Selection
    LIS3DHTR_REG_ACCEL_CTRL_REG4_SIM_4WIRE*: uint8 = 0x00       # 4-Wire Interface
    LIS3DHTR_REG_ACCEL_CTRL_REG4_SIM_3WIRE*: uint8 = 0x01       # 3-Wire Interface

    LIS3DHTR_REG_ACCEL_STATUS2_UPDATE_MASK*: uint8 = 0x08       # Has New Data Flag Mask