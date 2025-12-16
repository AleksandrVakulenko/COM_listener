# COM listener V1.0
Matlab script for intercepting messages between host computer and any device via RS232.

## Dependences
 - com0com ([download](https://sourceforge.net/projects/com0com/))

## Usage
1) Install com0com.

<img src="pic/com0com_setup.png" width="200" alt="com0com_setup.png" />

2) Run com0com/setupg.exe and set linked port numbers (if you don't want to use the default ones)

<img src="pic/com0com_settings.png" width="350" alt="com0com_settings.png" />

3) Make sure the two new ports are available in Device Manager.

<img src="pic/device_manager.png" width="350" alt="device_manager.png" />

4) In your main control program, select one of the linked ports as the port for communicating with the device.

<img src="pic/prog_port_select.png" width="150" alt="prog_port_select.png" />

5) In the script settings:
- set COM_port_host to the second linked port.
- set COM_port_device to the port to which the device is connected.
- set BAUD_rate to the value required for the device to operate properly.

<img src="pic/matlab_settings.png" width="500" alt="matlab_settings.png" />


- An example of the resulting communication diagram:

<img src="pic/link_diagram.png" width="400" alt="link_diagram.png" />
