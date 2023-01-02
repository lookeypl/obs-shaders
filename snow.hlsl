/**
 * Snowfall-like shader
 *
 * Adds some snowflakes on top of what is currently drawn
 *
 * Based on https://www.shadertoy.com/view/Mdt3Df
 */

#define FILTER
#include "common.hlsl"

// affect how many snow flakes are rendered - GPU-EXPENSIVE
uniform int Snow_iterations<
    string name = "Snow iterations";
> = 12;

// multiply/layer Snow_loops - GPU-EXPENSIVE
uniform int Snow_layers<
    string name = "Snow layers";
> = 2;

// affect how dense the snow is
uniform float Snow_density<
    string name = "Snow density";
    string field_type = "slider";
    float minimum = 0.08f;
    float maximum = 0.6f;
    float step = 0.04f;
> = 0.08f;

// affect how fast the snow flakes fall
uniform float Fall_speed<
    string name = "Fall speed";
    string field_type = "slider";
    float minimum = 0.3f;
    float maximum = 1.0f;
    float step = 0.05f;
> = 0.3f;

uniform float Scene_zoom<
    string name = "Scene zoom";
    string field_type = "slider";
    float minimum = 1.0f;
    float maximum = 5.0f;
    float step = 0.05f;
> = 2.0f; // affect how zoomed in the scene is

float4 render(VSInfo vtx) : TARGET
{
    float snow = 0.0f;
    const float random = rand(vtx.texcoord0.xy);
    const float time = Time.x + 16200;

    for (int k = 0; k < Snow_layers; k++)
    {
        for (int i = 1; i <= Snow_iterations; i++)
        {
            float cellSize = 3.0f + i / (Scene_zoom - 0.9);
            float downSpeed = Fall_speed + (sin(time * 0.4f + float(k + i * 20)) * 0.0008f);

            float2 uv = vtx.texcoord0.xy + float2(
                0.02f * sin((time + float(k * 61)) * 0.6f + i) * (i * 0.2f),
                downSpeed * (time + float(k * 15), 1.0) * 0.2f - (i + 1) * (1.0f / float(i))
            );
            float2 uvStep = ceil(uv * cellSize - 0.5f) / cellSize;
            float x = frac(sin(dot(uvStep, float2(12.9898f + float(k) * 10.0f, 78.233f + float(k) * 315.156f))) * 4.375854f + float(k) * 12.0) - 0.5;
            float y = frac(sin(dot(uvStep, float2(62.2364f + float(k) * 23.0f, 94.674f + float(k) * 95.0f))) * 6.215984f + float(k) * 12.0) - 0.5;

            float randomMagnitude1 = sin(time * 2.5f) * 0.7f / cellSize;
            float randomMagnitude2 = cos(time * 2.5f) * 0.7f / cellSize;

            float d = 5.0f * distance((uvStep + float2(x * sin(y), y) * randomMagnitude1 + float2(y, x) * randomMagnitude2), uv);

            float omiVal = frac(sin(dot(uvStep, float2(32.4691f, 94.615f))) * 3157.216f);
            if (omiVal < Snow_density)
            {
                float newd = (x + 1) * 0.4f * clamp(1.9f - d * (15.0f + (x * 6.3f)) * (cellSize / 2.0f), 0.0f, 1.0f);
                snow += newd;
            }
        }
    }

    return InputA.Sample(DefaultSampler, vtx.texcoord0.xy) + float4(snow, snow, snow, snow) + random * 0.02f;
}

technique Snow
{
    pass
    {
        vertex_shader = DefaultVS(vtx);
        pixel_shader  = render(vtx);
    }
}