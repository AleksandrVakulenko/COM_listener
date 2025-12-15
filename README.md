# COM listener V1.0
Matlab script for intercepting messages between host computer and any device via RS232.

## Dependences
 - com0com ([download](https://sourceforge.net/projects/com0com/))

## Usage
1) Install com0com.

2) Run com0com/setupg.exe and 

<img src="pic/com0com_settings.png" width="350" align="center" alt="com0com_settings.png" />

3) Make sure the two new ports are available in Device Manager.

<img src="pic/device_manager.png" width="350" align="center" alt="device_manager.png" />

4) In your main control program, select one of the linked ports as the port for communicating with the device.

<img src="pic/prog_port_select.png" width="150" align="center" alt="prog_port_select.png" />

5) In the script settings, set COM_port_host to the second linked port.

6) In the script settings, set the COM_port_device parameter to the port to which the device is connected.

<img src="pic/matlab_settings.png" width="500" align="center" alt="matlab_settings.png" />
