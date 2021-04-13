uniform int Blur_left = 20;
uniform int Blur_right = 20;
uniform int Blur_top = 20;
uniform int Blur_bottom = 20;

float blurAscending(float from, float to, float current)
{
    if (current > to)
        return 1.0f;

    float a = -1.0f / (from - to);
    float b = 1.0f - (to * a);
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

    float a = -1.0f / (to - from);
    float b = 1.0f - (from * a);
    float y = a * current + b;
    if (y < 0.0f)
        y = 0.0f;
    if (y > 1.0f)
        y = 1.0f;
    return y;
}

float4 mainImage(VertData v_in) : TARGET
{
    float4 color = image.Sample(textureSampler, v_in.uv);

    float blurLeft_uv_from = 0.0f;
    float blurLeft_uv_to = (float)Blur_left * uv_pixel_interval.x;
    color.w = color.w * blurAscending(blurLeft_uv_from, blurLeft_uv_to, v_in.uv.x);

    float blurRight_uv_from = 1.0f - ((float)Blur_right * uv_pixel_interval.x);
    float blurRight_uv_to = 1.0f;
    color.w = color.w * blurDescending(blurRight_uv_from, blurRight_uv_to, v_in.uv.x);

    float blurTop_uv_from = 0.0f;
    float blurTop_uv_to = (float)Blur_top * uv_pixel_interval.y;
    color.w = color.w * blurAscending(blurTop_uv_from, blurTop_uv_to, v_in.uv.y);

    float blurBottom_uv_from = 1.0f - ((float)Blur_bottom * uv_pixel_interval.y);
    float blurBottom_uv_to = 1.0f;
    color.w = color.w * blurDescending(blurBottom_uv_from, blurBottom_uv_to, v_in.uv.y);


    return color;
}
