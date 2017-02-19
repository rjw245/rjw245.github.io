---
layout:     post
title:      Getting Started with the DE2i-150 Dev Board
date:       2017-02-19
summary:    Setting up Altera Quartus on Ubuntu
thumbnail:  smile-o
tags:
- altera
- fpga
- linux
---
I'v been itching for a side project lately, so I decided to dig out my DE2i-150 FPGA/Intel Atom development board and start playing with it. I had previously worked with it a bit in a Windows environment, but now that I'm using Ubuntu full-time, I needed to set it up in Linux. I'm going to document all the steps I took to get the board up and running in the hopes that this helps other people get going faster.

<figure class="full">
    <img src="/assets/img/quartus_install/de2i-150.jpg">
    <figcaption>The DE2i-150</figcaption>
</figure>

## Installing Quartus

The latest version of Quartus (as of this writing) is 16.1.2 -- unfortunately, template projects for the DE2i-150 board are only supported for versions 15.1.0 and 16.0.0. So I elected to download the slightly older 16.0.0 release. No big deal.

Here's a link to Quartus Prime Lite 16.0.0:
[http://dl.altera.com/16.0/?edition=lite]()

The download will come with a setup.sh script in the top-level directory. I recommend running the script as root so that you can install the application in `/opt`:
~~~
sudo ./setup.sh
~~~
For monolithic applications like this one, it's typically recommended to install them in `/opt`:
<figure class="full">
    <img src="/assets/img/quartus_install/install_dir.png">
    <figcaption>Choosing the install directory</figcaption>
</figure>

On the next screen, you'll choose the components you want to install. Because I am working exclusively with a Cyclone IV GX board, I chose to install only Cyclone IV devices:

<figure class="full">
    <img src="/assets/img/quartus_install/install_components.png">
    <figcaption>Choosing what to install</figcaption>
</figure>

Proceed with the installation. Go grab something to eat while it finishes up.

Once it's done, you can add the installation to your path to more easily start the program from the command line. On my machine, all Quartus executables are located at `/opt/altera_lite/16.0/quartus/bin`.
To add this to my path, I created a script in /etc/profile.d called quartus.sh:
~~~
PATH=$PATH:/opt/altera_lite/16.0/quartus/bin
~~~
At startup, this script and all others in /etc/profile.d will be sourced.
Adapt this script to your system, replacing `/opt/altera_lite/16.0` with the install path you used before.

## Configuring the USB Blaster

Now it's time to set up the USB Blaster, which we will use to program the FPGA. Altera Quartus comes with a little daemon
called `jtagd` which runs in the background and provides a connection between Altera tools and the Linux
USB drivers, so that Quartus can use the USB Blaster. By default, only `root` will be given access to the USB
device -- we can leverage udev rules to give normal users access.

Power your DE2i-150 board and plug it into your computer. Type the command `lsusb` to show the USB devices currently
available, and look for the entry with "Altera" in the name:
~~~
...
Bus 001 Device 014: ID 09fb:6001 Altera Blaster
...
~~~

Take note of the two hex numbers separate by a colon just before "Altera Blaster". The first of these,
`09fb`, is the vendor ID. This uniquely identifies Altera.
The second, `6001`, is the product ID, which uniquely identifies
the USB Blaster. I suspect that these will be the same for everyone with this board, but in case,
take note of whichever vendor and product IDs you see, as you will need them in the next step.

Navigate to `/etc/udev/rules.d`. Create a file as root called `51-usbblaster.rules`:
~~~
sudo nano 51-usbblaster.rules
~~~
Inside that file, paste the following:
~~~
# For Altera USB-Blaster permissions.
SUBSYSTEM=="usb",\
ENV{DEVTYPE}=="usb_device",\
ATTR{idVendor}=="09fb",\
ATTR{idProduct}=="6001",\
MODE="0666",\
NAME="bus/usb/$env{BUSNUM}/$env{DEVNUM}",\
RUN+="/bin/chmod 0666 %c"
~~~
Replace `09fb` above with the vendor ID you saw previously,
and replace `6001` with your product ID.

This rule will be executed whenever a new USB device is plugged in.
The first four lines specify that this rule only applies to USB devices
with a certain vendor and product ID. The rule states that the device
be assigned permissions `0666`, aka everyone can read and write.

**IMPORTANT:** At this point, unplug your USB blaster. We don't want to
activate this udev rule while it is plugged in, as this makes troubleshooting
difficult. I got quite frustrated at first when my udev rule didn't appear to be working --
all because I hadn't unplugged and replugged, which meant the rule hadn't yet
been triggered.

Run the following command to load your new udev rule:
~~~
sudo udevadm control --reload
~~~
And now plug back in your USB blaster. You can use the `jtagconfig` tool
to test your connection.
~~~
$ jtagconfig 
1) USB-Blaster [1-3]
  028040DD   EP4CGX150
~~~
The above shows that `jtagconfig` successfully identified my USB Blaster.

## Troubleshooting USB Blaster Setup

If you see the following when running `jtagconfig`
~~~
$ jtagconfig
1) USB-Blaster variant [1-3]
  Unable to lock chain - Insufficient port permissions
~~~
then your udev rule is either malformed or hasn't been run.
Try the following to fix the issue:
1. Unplug your USB blaster
2. Ensure your new udev rule is installed in `/etc/udev/rules.d`
3. Run `sudo udevadm control --reload` to load your new rule.
4. Plug the USB blaster back in.
5. Try `jtagconfig` once more.

***********

You may see the following when running `jtagconfig`
~~~
$ jtagconfig
1) USB-Blaster [1-3]
  Unable to read device chain - JTAG chain broken
~~~
This can happen if you unplug and replug your USB blaster
after `jtagd` has been started. You should kill `jtagd`
~~~
sudo killall -9 jtagd
~~~
and run `jtagconfig` again, which will start `jtagd` in the background.
A similar error can occur if you unplug the USB Blaster while running
Quartus.