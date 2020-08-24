OBS Shaders
===========

A collection of my shaders used with obs-shaderfilter plugin.

How to use
----------

1. Install obs-shaderfilter plugin
1. Add a "User-defined shader" effect/video filter to one of your sources
1. Tick the mark next to "Load shader code from file" and point at one of the files

What shaders do
---------------

* `pulse.hlsl` - Dims and brightens the feed in a loop.
* `smart-scroll.hlsl` - A smarter scroller than OBS's default scroller. Can pad text, scroll only when needed and at different speeds. But only in X axis. Useful for song titles/artists at a predefined space (Custom text extent must be DISABLED for this shader to work properly).
