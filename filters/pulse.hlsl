/**
 * Pulse shader
 *
 * Provides a simple "pulsing" effect to an OBS source.
 *
 * Really nothing big, but also my first shader and you have to start somewhere...
 */

#include "../common.hlsl"

uniform float Pulse_multiplier<
    string label = "Pulse multiplier";
    string widget_type = "slider";
    float minimum = 0.0f;
    float maximum = 1.0f;
    float step = 0.1f;
> = 0.5f;

uniform float Pulse_shift<
    string label = "Pulse shift";
    string widget_type = "slider";
    float minimum = 0.0f;
    float maximum = 1.0f;
    float step = 0.05f;
> = 0.5f; // coefficient from 0.0 to 1.0

uniform float Pulse_period<
    string label = "Pulse period (s)";
    float minimum = 0.0f;
    float step = 0.1f;
> = 4.0f; // in seconds

float4 mainImage(VertData v_in): TARGET
{
    float multiplier = Pulse_shift + (Pulse_multiplier * sin(elapsed_time * (2 * PI / Pulse_period)));
    return float4(multiplier, multiplier, multiplier, 1.0f) * image.Sample(textureSampler, v_in.uv);
}
