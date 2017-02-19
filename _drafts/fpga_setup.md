---
layout:     post
title:      Getting Started with Altera Quartus Prime
date:       2017-02-19
summary:    Setting up Altera Quartus on Ubuntu
thumbnail:  smile-o
tags:
- altera
- fpga
- linux
---
I'v been itching for a side project lately, so I decided to dig out my DE2i-150 FPGA/Intel Atom development board and start playing with it. I had previously worked with it a bit in a Windows environment, but now that I'm using Ubuntu full-time, I needed to set it up in Linux. I'm going to document all the steps I took to get the board up and running in the hopes that this helps other people get going faster.

You can download Quartus Prime from Intel here:
[https://www.altera.com/products/design-software/fpga-design/quartus-prime/download.html]()

I chose to download the Lite edition, since it supported my FPGA Series (Cyclone IV GX). If you're in the market for an introductory FPGA, you should consider getting one which the Lite edition supports so that you don't have to pay for the software. A list of supported devices for each software version appears on the above page.

The download will come with a setup.sh script in the top-level directory. I recommend running the script as root so that you can install the application in `/opt`:

    sudo ./setup.sh

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

