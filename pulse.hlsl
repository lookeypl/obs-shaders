/**
 * Pulse shader
 *
 * Provides a simple "pulsing" effect to an OBS source.
 *
 * Really nothing big, but also my first shader and you have to start somewhere...
 */

#define FILTER
#include "common.hlsl"


uniform float Pulse_multiplier<
    string name = "Pulse multiplier";
> = 0.5f;

uniform float Pulse_shift<
    string name = "Pulse shift";
    float minimum = 0.0f;
    float maximum = 1.0f;
> = 0.5f; // coefficient from 0.0 to 1.0

uniform float Pulse_period<
    string name = "Pulse period (s)";
    float minimum = 0.1f;
> = 4.0f; // in seconds

float4 render(VSInfo vtx) : TARGET
{
    float multiplier = Pulse_shift + (Pulse_multiplier * sin(Time.x * (2 * PI / Pulse_period)));
    return float4(multiplier, multiplier, multiplier, 1.0f) * InputA.Sample(DefaultSampler, vtx.texcoord0.xy);
}

technique Pulse
{
    pass
    {
        vertex_shader = DefaultVS(vtx);
        pixel_shader = render(vtx);
    }
}
