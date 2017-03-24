---
layout:     post
title:      Absolutistic Modal Flatitude!
date:       2017-02-19
summary:    Using Python to illustrate modes of a C major scale.
thumbnail:  music
tags:
- guitar
- music theory
- python
---

I've been taking guitar lessons for a few months now, and I recently found a fun way to combine music and programming. When I'm not playing songs during my lessons, I'm learning about music theory and how western scales are constructed. There are certain pattern these scales obey which make them sound "correct" to our ears. One of the main patterns in play with the C major scale is the distance between successive notes.

<img src="/assets/img/amf/c-major-scale.png" style="width:400px;">

As you can see above, certain notes of the scale have an unplayed black key between them, and others don't. The intervals where a black key is skipped are called "full steps", and adjacent note intervals are "half steps". What we see in the C major scale is the following interval pattern:

*Full, full, half, full, full, full, half.*

It turns out that all Western scales follow that interval pattern. What's more, it's possible to change the character of the scale by flatting certain notes, one at a time, as long as you preserve the above interval pattern **somewhere** in the scale (meaning it can rotate around). This is called changing the mode of the scale; subsequent modes will sound more and more "evil" as more notes are flatted.

One of the darker modes is the Phrygian mode. Take a listen:

<iframe width="854" height="480" src="https://www.youtube.com/embed/a6b-T_tNwtc?start=142" frameborder="0" allowfullscreen></iframe>



Now take a look at that on the keyboard. If you count intervals starting from the minor/flatted 6th note (-6) and don't double count the 1, you will again see the *full, full, half, full, full, full, half* step pattern! Crazy!

<img src="/assets/img/amf/phrygian_keyscale.png" style="width:400px;">

So this is how you move from one mode to the next: by flatting the one note in the scale that, when flatted, creates the necessary interval pattern somewhere else in the scale.

My guitar teacher [Sam Davis](http://samdavis.com) calls this relationship between modes "Absolutistic Modal Flatitude", hence the name of this post.

I wanted to prove to myself that I understood this concept, so I wrote a Python program that uses the above algorithm to generate consecutive Western modes. You can find the [source code on Github](https://github.com/rjw245/absolutistic-modal-flatitude).
