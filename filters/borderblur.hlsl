/**
 * Border blur
 *
 * Applies an alpha-based blur to OBS source around the edges, including crop functionality
 */

#define FILTER
#include "../common.hlsl"

uniform int Blur_left<
    string label = "Left edge blur width (px)";
    int minimum = 0;
    int step = 1;
> = 20;
uniform int Blur_right<
    string label = "Right edge blur width (px)";
    int minimum = 0;
    int step = 1;
> = 20;
uniform int Blur_top<
    string label = "Top edge blur width (px)";
    int minimum = 0;
    int step = 1;
> = 20;
uniform int Blur_bottom<
    string label = "Bottom edge blur width (px)";
    int minimum = 0;
    int step = 1;
> = 20;

uniform int Crop_left<
    string label = "Left edge crop (px)";
    int minimum = 0;
    int step = 1;
> = 0;
uniform int Crop_right<
    string label = "Right edge crop (px)";
    int minimum = 0;
    int step = 1;
> = 0;
uniform int Crop_top<
    string label = "Top edge crop (px)";
    int minimum = 0;
    int step = 1;
> = 0;
uniform int Crop_bottom<
    string label = "Bottom edge crop (px)";
    int minimum = 0;
    int step = 1;
> = 0;


float blurAscending(float from, float to, float current)
{
    if (current > to)
        return 1.0f;

    const float a = -1.0f / (from - to);
    const float b = 1.0f - (to * a);
    float y = a * current + b;
    if (y < 0.0f)
        y = 0.0f;
    if (y > 1.0f)
        y = 1.0f;
    return y;
}

float blurDescending(float from, float to, float current)
{
    if (current < from)
        return 1.0f;

    const float a = -1.0f / (to - from);
    const float b = 1.0f - (from * a);
    float y = a * current + b;
    if (y < 0.0f)
        y = 0.0f;
    if (y > 1.0f)
        y = 1.0f;
    return y;
}

float4 mainImage(VertData v_in): TARGET
{
    const float2 uv_in = v_in.uv;
    float4 color = image.Sample(textureSampler, uv_in);

    const float blurLeft_uv_from = Crop_left * uv_pixel_interval.x;
    const float blurRight_uv_to = 1.0f - (Crop_right * uv_pixel_interval.x);
    const float blurTop_uv_from = Crop_top * uv_pixel_interval.y;
    const float blurBottom_uv_to = 1.0f - (Crop_bottom * uv_pixel_interval.y);

    if (uv_in.x < blurLeft_uv_from || uv_in.x > blurRight_uv_to ||
        uv_in.y < blurTop_uv_from || uv_in.y > blurBottom_uv_to)
        return float4(color.x, color.y, color.z, 0.0f);

    float blurLeft_uv_to = blurLeft_uv_from + ((float)Blur_left * uv_pixel_interval.x);
    color.w = color.w * blurAscending(blurLeft_uv_from, blurLeft_uv_to, uv_in.x);

    float blurRight_uv_from = blurRight_uv_to - ((float)Blur_right * uv_pixel_interval.x);
    color.w = color.w * blurDescending(blurRight_uv_from, blurRight_uv_to, uv_in.x);

    float blurTop_uv_to = blurTop_uv_from + ((float)Blur_top * uv_pixel_interval.y);
    color.w = color.w * blurAscending(blurTop_uv_from, blurTop_uv_to, uv_in.y);

    float blurBottom_uv_from = blurBottom_uv_to - ((float)Blur_bottom * uv_pixel_interval.y);
    color.w = color.w * blurDescending(blurBottom_uv_from, blurBottom_uv_to, uv_in.y);

    return color;
}
