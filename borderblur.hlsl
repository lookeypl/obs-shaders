/**
 * Border blur
 *
 * Applies an alpha-based blur to OBS source around the edges, including crop functionality
 */

#pragma shaderfilter set Blur_left__min 0
#pragma shaderfilter set Blur_left__description Left edge blur width (px)
uniform int Blur_left = 20;

#pragma shaderfilter set Blur_right__min 0
#pragma shaderfilter set Blur_right__description Right edge blur width (px)
uniform int Blur_right = 20;

#pragma shaderfilter set Blur_top__min 0
#pragma shaderfilter set Blur_top__description Top edge blur width (px)
uniform int Blur_top = 20;

#pragma shaderfilter set Blur_bottom__min 0
#pragma shaderfilter set Blur_bottom__description Bottom edge blur width (px)
uniform int Blur_bottom = 20;

#pragma shaderfilter set Crop_left__min 0
#pragma shaderfilter set Crop_left__description Left edge crop (px)
uniform int Crop_left = 0;

#pragma shaderfilter set Crop_right__min 0
#pragma shaderfilter set Crop_right__description Right edge crop (px)
uniform int Crop_right = 0;

#pragma shaderfilter set Crop_top__min 0
#pragma shaderfilter set Crop_top__description Top edge crop (px)
uniform int Crop_top = 0;

#pragma shaderfilter set Crop_bottom__min 0
#pragma shaderfilter set Crop_bottom__description Bottom edge crop (px)
uniform int Crop_bottom = 0;


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

float4 render(float2 uv_in)
{
    const float2 uv_pixel_interval = 1.0 / builtin_uv_size;
    float4 color = image.Sample(builtin_texture_sampler, uv_in);

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
