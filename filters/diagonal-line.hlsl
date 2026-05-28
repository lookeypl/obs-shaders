/**
 * Draws a diagonal line through the screen. Useful in tandem with scan-freeze.hlsl
 */

#define FILTER
#include "../common.hlsl"

uniform float Scan_length<
    string label = "Scan length (s)";
    string widget_type = "slider";
    float minimum = 1.0f;
    float maximum = 20.0f;
    float step = 0.1f;
> = 10.0f;

uniform int Line_thickness<
    string label = "Line thickness";
    string widget_type = "slider";
    int minimum = 1;
    int maximum = 10;
    int step = 1;
> = 5;

float4 mainImage(VertData v_in): TARGET
{
    const float transitionRatio = (elapsed_time_show / Scan_length) * 2.0f - 2.0f;
    const float transitionPoint = -(v_in.uv.x + v_in.uv.y);
    const float borderInterval = (uv_pixel_interval.x + uv_pixel_interval.y) / 2.0f;
    const float borderWidth = borderInterval * Line_thickness;
    if (near(transitionPoint, transitionRatio, borderWidth)) {
        const float4 color = image.Sample(textureSampler, v_in.uv);
        const float factor = abs(transitionPoint - transitionRatio) / borderWidth;
        return float4(
            lerp(1 - color.xyz, color.xyz, factor),
            color.a
        );
    } else {
        return image.Sample(textureSampler, v_in.uv);
    }
}