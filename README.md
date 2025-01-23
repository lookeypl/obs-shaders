OBS Shaders
===========

A collection of my shaders used with [obs-shaderfilter plugin](https://github.com/exeldro/obs-shaderfilter/).

How to use
----------

1. Install obs-shaderfilter plugin.
1. Add a "User-defined shader" filter to one of your sources or as a transition.
1. Tick the mark next to "Load shader code from file" and point at one of the files. Set parameters if applicable.

What shaders do
---------------

* `borderblur.hlsl` - Creates a blur on borders of source by modifying alpha component. Parameters are in amount of pixels which blur should take.
* `fbm.hlsl` - Fractal Brownian Motion noise generator. Can generate animated "waves" over a picture with some adjustments.
* `pulse.hlsl` - Dims and brightens the feed in a loop.
* `smart-scroll.hlsl` - A smarter scroller than OBS's default scroller. Can pad text, scroll (only on one axis) when needed and at different speeds. Useful for song titles/artists at a predefined space (Custom text extent must be DISABLED for this shader to work properly).
* `snow.hlsl` - Snow-like effect overlaying on top of your OBS Source. Has some parameters to play around with to make it less heavy, or more stream-compression-friendly.
