---
layout:     post
title:      Testbed for Computer Architecture Research
date:       2016-05-13
summary:    An independent project in computer architecture completed during my last semester at Tufts.
thumbnail:  microchip
tags:
- project
- independent study
- computer architecture
- accelerators
- tufts
- hempstead
---

During my last semester at Tufts, I was fortunate enough to work with Professor Mark Hempstead at the [Tufts Computer Architecture Lab (TCAL)](https://sites.tufts.edu/tcal/){:target="_blank"}. I had previously taken a class with him on computer architecture and was interested in doing more work in the field, as well as gaining some research experience. I had been toying with the idea of going to graduate school the summer before and into the fall, ultimately deciding that I wanted to get some experience working in a lab before committing myself to
a Master's program, and this project was the perfect opportunity to gain that experience.

Professor Hempstead's lab focuses on the future of specialized hardware accelerators and their integration into general-purpose computer architectures. My project was to develop an architecture incorporating multiple accelerators and to write an application on top which utilizes them in complex ways to solve interesting problems either faster or more efficiently than traditional architectures could. I ran out of time to finish the application, but I did validate certain
aspects of the architecture. I showed that an FFT could be computed faster in hardware (specifically, on FPGA fabric) than in software, but unfortunately the overall process was bogged down by data transfer.

Through this project, I learned a lot about FPGA development with the Xilinx suite of tools. I worked with a ZedBoard which integrates a general-purpose ARM processor tightly coupled to FPGA fabric. It was pretty exciting to design a system architecture and then immediately be able to write code which interacts with its components. In addition to technical skills I acquired, I also learned a lot about the architecture research field and the work being done by the research
community. My full report from the project summarizing what I learned and accomplished is included below.

<iframe src="http://docs.google.com/gview?url=http://rileywood.me/assets/pdf/independent-study-report.pdf&embedded=true" style="width:718px; height:700px;" frameborder="0"></iframe>

