/**
 * Scan-freeze filter - goes through the scene freezing it as it scans through the image.
 * To unfreeze disable the filter.
 */

#define FILTER
#define USE_PREVIOUS_OUTPUT
#include "../common.hlsl"

uniform float Scan_length<
    string label = "Scan length (s)";
    string widget_type = "slider";
    float minimum = 1.0f;
    float maximum = 20.0f;
    float step = 0.1f;
> = 10.0f;

#define TOLERANCE 0.002f

float4 mainImage(VertData v_in): TARGET
{
    const float transitionRatio = (elapsed_time_show / Scan_length) * 2.0f - 2.0f;
    if (transitionRatio > 1.0) {
        return previous_output.Sample(textureSampler, v_in.uv);
    }

    const float transitionPoint = -(v_in.uv.x + v_in.uv.y);
    if (transitionPoint > (transitionRatio + TOLERANCE)) {
        // transition did not get to the line yet
        return image.Sample(textureSampler, v_in.uv);
    // } else if (transitionPoint <= (transitionRatio + TOLERANCE) &&
    //            transitionPoint > (transitionRatio - TOLERANCE)) {
    // TODO this doesn't exactly average as I want it to. Has to be good enough for now.p
    //     float4 src = image.Sample(textureSampler, v_in.uv);
    //     float4 prev = previous_output.Sample(textureSampler, v_in.uv);
    //     float t = (transitionPoint - transitionRatio + TOLERANCE) / (2.0 * TOLERANCE);
    //     return lerp(src, prev, t);
    } else {
        return previous_output.Sample(textureSampler, v_in.uv);
    }
}
