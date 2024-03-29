/**
 * Fractional Brownian Motion shader
 *
 * Applies a specified color and does a motion kinda thingy. Idk how to describe it. Looks cool.
 *
 * Based on https://www.shadertoy.com/view/tdG3Rd
 */

#define FILTER
#include "../common.hlsl"

uniform float4 FBM_color<
    string label = "FBM Color";
> = {0.1f, 0.1, 0.1f, 1.0f};

uniform float Intensity<
    string label = "Intensity";
    float minimum = 0.0;
    float step = 0.05;
> = 0.5f;

uniform float Anim_speed<
    string label = "Animation speed";
    float minimum = 0.0;
    float step = 0.1;
> = 0.8f;

uniform bool Include_source_transparency<
    string label = "Include source transparency";
> = false;


float noise(float2 p)
{
    float2 ip = floor(p);
    float2 u = frac(p);
    u = u * u * (3.0f - 2.0f * u);

    float res = lerp(
        lerp(rand(ip), rand(ip + float2(1.0f, 0.0f)), u.x),
        lerp(rand(ip + float2(0.0f, 1.0f)), rand(ip + float2(1.0f, 1.0f)), u.x),
        u.y
    );
    return res * res;
}

float fbm(float2 uv)
{
    const float2x2 mtx = {1.0f, 0.8f,-0.8f, 1.0f};
    float f = 0.0;
    float2 p = uv;

    f += 0.500000f * noise(p + (elapsed_time * Anim_speed));

    p = mul(mtx, p * 2.02f);
    f += 0.031250f * noise(p);

    p = mul(mtx, p * 2.01f);
    f += 0.250000f * noise(p);

    p = mul(mtx, p * 2.03f);
    f += 0.125000f * noise(p);

    p = mul(mtx, p * 2.01f);
    f += 0.062500f * noise(p);

    p = mul(mtx, p * 2.04f);
    f += 0.015625f * noise(p + sin(elapsed_time * Anim_speed));

    return f / 0.96875f;
}

float4 mainImage(VertData v_in): TARGET
{
    const float2 uv_in = v_in.uv;
    float4 color = image.Sample(textureSampler, uv_in);

    float shade = fbm(uv_in + fbm(uv_in + fbm(uv_in)));
    float4 lerpColor = lerp(color, FBM_color, shade * Intensity);

    if (Include_source_transparency)
        lerpColor.w *= color.w;

    return lerpColor;
}
