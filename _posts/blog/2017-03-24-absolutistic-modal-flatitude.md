---
layout:     post
title:      Absolutistic Modal Flatitude!
date:       2017-03-24
summary:    Using Python to illustrate modes of a C major scale.
thumbnail:  music
tags:
- guitar
- music theory
- python
---

I've been taking guitar lessons for a few months now, and I recently found a fun way to combine music and programming.

When I'm not playing songs during my lessons, I'm learning about music theory and how western scales are constructed. There are certain patterns that define these scales; one of the main patterns in play with the C major scale is the distance between successive notes.

<img src="/assets/img/amf/c-major-scale.png" style="width:400px;">

As you can see above, certain notes of the scale have an unplayed black key between them, and others don't. The intervals where a black key is skipped are called "full steps", and adjacent note intervals are "half steps". What we see in the C major scale is the following interval pattern:

*Full, full, half, full, full, full, half.*

It's possible to change the character of the scale by making certain notes flat. To remain a western scale, however, the above pattern must always be present **somewhere** in the scale (in other words, it's okay for the pattern to rotate around). In fact, for any given scale, there will be exactly one note that can be flatted while retaining this pattern. This process of flatting particular notes is called changing the mode of the scale; subsequent modes will sound darker and darker as more notes are flatted.

The C major scale shown above is of the Ionian mode. Flat the right note, and we'll find ourselves at the Mixolydian mode. Listen to the Mixolydian mode being played:

<iframe width="854" height="480" src="https://www.youtube.com/embed/7ifPnSCGvYQ?start=256" frameborder="0" allowfullscreen></iframe>

You can see here that we've flatted the 7th note:

<img src="/assets/img/amf/mixolydian_keyscale.png" style="width:400px;">


So this is how you move from one mode to the next: by flatting the one note in the scale that, when flatted, creates the necessary interval pattern somewhere else in the scale.

My guitar teacher [Sam Davis](http://samdavis.com) calls this relationship between modes "Absolutistic Modal Flatitude", hence the name of this post.

I wanted to prove to myself that I understood this concept, so I wrote a Python program that uses this simple algorithm to move between neighboring Western modes. You can find the [source code on Github](https://github.com/rjw245/absolutistic-modal-flatitude), and I'll walk through it here.