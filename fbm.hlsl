/**
 * Fractional Brownian Motion shader
 *
 * Applies a specified color and does a motion kinda thingy. Idk how to describe it. Looks cool.
 *
 * Based on https://www.shadertoy.com/view/tdG3Rd
 */

uniform float4 FBM_color = {0.1f, 0.1, 0.1f, 1.0f};
uniform float FBM_alpha = 1.0f;
uniform float Intensity = 0.5f;
uniform float Anim_speed = 0.8f;

float rand(float2 n)
{
    return frac(sin(dot(n, float2(12.9898f, 4.1414f))) * 43758.5453f);
}

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

    f += 0.500000f * noise(p + (builtin_elapsed_time * Anim_speed));

    p = mul(mtx, p * 2.02f);
    f += 0.031250f * noise(p);

    p = mul(mtx, p * 2.01f);
    f += 0.250000f * noise(p);

    p = mul(mtx, p * 2.03f);
    f += 0.125000f * noise(p);

    p = mul(mtx, p * 2.01f);
    f += 0.062500f * noise(p);

    p = mul(mtx, p * 2.04f);
    f += 0.015625f * noise(p + sin(builtin_elapsed_time * Anim_speed));

    return f / 0.96875f;
}

float4 render(float2 uv_in)
{
    float4 color = image.Sample(builtin_texture_sampler, uv_in);

    float shade = fbm(uv_in + fbm(uv_in + fbm(uv_in)));
    float4 fbmColor = float4(FBM_color.xyz, FBM_alpha);
    return lerp(color, fbmColor, shade * Intensity);
}
