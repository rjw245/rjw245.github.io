---
layout:     post
title:      Light-up Graduation Cap
date:       2016-05-23 12:00:00
summary:    My last build of college, for my graduation ceremony.
preview:  assets/img/graduation-cap/gradcapback-small.gif
project: true
permalink: projects/:title
tags:
    - project
    - neopixel
    - arduino
---

On Sunday I graduated college! It's always been a tradition for graduating students to decorate their graduation caps, and for mine I wanted to add a little EE flavor. I decided to add RGB LED strips to create an eye-catching pattern on top. Check it out in the video below:

<iframe width="640" height="360" src="https://www.youtube.com/embed/VzNShGp1zbs"
frameborder="0" allowfullscreen></iframe>
<br />

Pretty cool right? Here's how it works:

Electronics
-----------

I taped [Neopixel LED strips](https://www.adafruit.com/category/168) on the cardboard beneath the
fabric of my graduation cap and can control them with an Arduino Uno, housed
inside the cap beneath the cardboard. The Uno is a bit unwieldy -- I would have
much preferred to extract the microcontroller and put it on a small breadboard,
but time constraints forced me to put the Arduino itself in the cap. The whole
thing is powered by a portable USB battery pack sitting in my pocket, connected
via a USB cable (which runs down my back and makes me look like a robot). 

Here are some closeups of the internals. 

![](/assets/img/graduation-cap/neopixel1.jpg){:height="360px" width="360px"}
![](/assets/img/graduation-cap/neopixel3.jpg){:height="360px" width="360px"}

Closeup of the Neopixels

![](/assets/img/graduation-cap/arduino1.jpg){:height="360px" width="360px"}
![](/assets/img/graduation-cap/arduino2.jpg){:height="360px" width="360px"}

Closeup of the Arduino Uno

![](/assets/img/graduation-cap/gradcapback.gif){:height="360px" width="360px"}

A behind view of me wearing the cap.

Software
--------

Below is the Arduino code I've written for this project:

{% highlight c++ %}
#include <Adafruit_NeoPixel.h>

#define PIN  8           // LED strip control pin
#define NUMPIXELS    52  // Total number of pixels on cap
#define SNAKE_LEN    10  // Length in pixels of each snake
#define NUM_SNAKES   2   // Number of snakes circling the cap
#define DELAYTIME    70  // Time in ms between movements

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, 
        NEO_GRB + NEO_KHZ800);
int snake_heads[NUM_SNAKES];

void setup() {
    int s;
    pixels.begin();

    // Set the snakes' starting positions, spacing them evenly
    for(s=0; s<NUM_SNAKES; s++) {
        snake_heads[s] = NUMPIXELS*s/NUM_SNAKES;
    }
}

void loop() {
    int i,s;

    // Turn off all pixels to start
    for(i=0; i<NUMPIXELS; i++){
        pixels.setPixelColor(i, pixels.Color(0,0,0));
    }

    // Light up the proper pixels given where the snakes are
    for(s=0; s<NUM_SNAKES; s++) {
        for(i=0; i<SNAKE_LEN; i++){
            int pix = (snake_heads[s]+NUMPIXELS-i)%NUMPIXELS;
            pixels.setPixelColor(pix, pixels.Color(0,255,0));
        }
        snake_heads[s]++;
        snake_heads[s] %= NUMPIXELS;
    }

    pixels.show();
    delay(DELAYTIME);
}
{% endhighlight %}

I'm proud of how configurable it is: it allows you to easily change the number of snakes moving around the hat, their lengths, and how fast they move via #defines at the top of the file.
