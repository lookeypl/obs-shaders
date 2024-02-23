/**
 * Snowfall-like shader
 *
 * Adds some snowflakes on top of what is currently drawn
 *
 * Based on https://www.shadertoy.com/view/Mdt3Df
 */

#define FILTER
#include "../common.hlsl"

uniform int Snow_iterations<
    string label = "Snow iterations";
    int minimum = 0;
> = 12; // affect how many snow flakes are rendered - GPU-EXPENSIVE

uniform int Snow_layers<
    string label = "Snow layers";
    int minimum = 0;
> = 2; // multiply/layer Snow_loops - GPU-EXPENSIVE

uniform float Snow_density<
    string label = "Snow density";
    string widget_type = "slider";
    float minimum = 0.08;
    float maximum = 0.6;
    float step = 0.04;
> = 0.08f; // affect how dense the snow is

uniform float Fall_speed<
    string label = "Snow fall speed";
    string widget_type = "slider";
    float minimum = 0.1;
    float maximum = 1.0;
    float step = 0.05;
> = 0.3f; // affect how fast the snow flakes fall

uniform float Scene_zoom<
    string label = "Scene zoom";
    string widget_type = "slider";
    float minimum = 1.0;
    float maximum = 5.0;
    float step = 0.05;
> = 2.0f; // affect how zoomed in the scene is

float4 mainImage(VertData v_in): TARGET
{
    const float2 uv_in = v_in.uv;

    float snow = 0.0f;
    const float random = rand(uv_in);
    const float time = elapsed_time;

    for (int k = 0; k < Snow_layers; k++)
    {
        for (int i = 1; i < Snow_iterations; i++)
        {
            float cellSize = 3.0f + i / (Scene_zoom - 0.9);
            float downSpeed = -Fall_speed - (sin(time * 0.4f + float(k + i * 20)) * 0.0008f);

            float2 uv = uv_in + float2(
                0.02f * sin((time + float(k * 61)) * 0.6f + i) * (i * 0.2f),
                downSpeed * mod(time + k, PI2 * 20 + float(k + i * 20))
            );
            float2 uvStep = ceil(uv * cellSize - 0.5f) / cellSize;
            float x = frac(sin(dot(uvStep, float2(12.9898f + float(k) * 10.0f, 78.233f + float(k) * 315.156f))) * 4.375854f + float(k) * 12.0) - 0.5;
            float y = frac(cos(dot(uvStep, float2(62.2364f + float(k) * 23.0f, 94.674f + float(k) * 95.0f))) + float(k * 12)) - 0.5f;

            float randomMagnitude1 = sin(time * 2.5f) * 0.7f / cellSize;
            float randomMagnitude2 = cos(time * 2.5f) * 0.7f / cellSize;

            float d = 5.0f * distance((uvStep + float2(x, y) * randomMagnitude1 + float2(y, x) * randomMagnitude2), uv);

            float omiVal = frac(sin(dot(uvStep, float2(12.9898f, 78.233f))) * 4.375854f);
            if (omiVal < Snow_density)
            {
                float newd = (x + 1) * 0.4f * clamp(1.9f - d * (15.0f + (x * 6.3f)) * (cellSize / 2.0f), 0.0f, 1.0f);
                snow += newd;
            }
        }
    }

    return image.Sample(textureSampler, uv_in) + float4(snow, snow, snow, snow) + random * 0.02f;
}
