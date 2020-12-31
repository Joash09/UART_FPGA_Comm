# UART Comm FPGA

Joash Naidoo

This project was done to learn how to implement from scratch UART serial communication on a FPGA. The hope is to reuse these modules for future projects. The code was implemented on a Digilent Arty A7-35 (100 Mhz system clock) board and the control PC ran Ubuntu 18.04. Baud rate is set to 9600. The project was written in Vivado 2017.4 and I used the Vivado Sythesis and Simulation tools. No additional IP cores were used.

## What it does

The program is simple. After the bitstream is loaded, it will print "Hello" to the console. Thereafter the FPGA will "echo" the input from the user (i.e. pressing any key will be displayed on the console). 

## Simulation Results

The testbench and module first transmit "Hello" and then will echo any other character entered (in this case X"77"). 

!(Vivado Simualtion)[./UART_Sim.png]

## Control PC and Minicom Setup

I used the [Minicom](https://wiki.emacinc.com/wiki/Getting_Started_With_Minicom#Running_Minicom) serial communication program for the control PC. Something like Putty will also do. Linux has the appropriate [FTDI](https://www.ftdichip.com/Support/Documents/InstallGuides.htm) Virtual Comm drivers in the kernel. Windows users will have to download and install these drivers. Minicom needs to be configured to have a baud rate of 9600 and Hardware Flow Control set to No. The commands/keystrokes will get you started:

`
minicom -D /dev/ttyUSB1 ttyUSB1 " Open minicom


<Cr>A + z " Access minicom settings


O " Open serial settings
`
