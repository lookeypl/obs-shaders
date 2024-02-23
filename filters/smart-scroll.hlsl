/**
 * Smart-scroll shader
 *
 * Provides a bit more facility to scrolling an OBS source compared to native scroller.
 * Allows to "stop" the scroll every loop, modify speed and introduce a gap between loops.
 */

#define FILTER
#include "../common.hlsl"

uniform int Cut_width<
    string label = "Source cut width (px)";
    int minimum = 0;
> = 0; // in pixels

uniform int Scroll_loop_empty_space<
    string label = "Gap width (px)";
    int minimum = 0;
> = 50; // in pixels

uniform float Scroll_wait_seconds<
    string label = "Scroll pause per loop (s)";
    float minimum = 0.0;
    float step = 0.1;
> = 2.0f; // in seconds

uniform int Scroll_speed<
    string label = "Scroll speed (px/s)";
    int minimum = 0;
> = 40; // in pixels/second


float4 mainImage(VertData v_in): TARGET
{
    float2 uv_in = v_in.uv;

    // early exit if there's nothing to cut
    if ((Cut_width == 0) || (uv_size.x < Cut_width))
        return image.Sample(textureSampler, uv_in);

    float uvCutPoint = (float)(Cut_width) / uv_size.x;

    if (uv_in.x > uvCutPoint)
        return float4(0.0f, 0.0f, 0.0f, 0.0f);

    const float emptySpace = (float)Scroll_loop_empty_space;
    float uvEmptySpace = emptySpace / uv_size.x;

    float uvAnimTime = (float)(uv_size.x + emptySpace) / Scroll_speed;

    // pause for Scroll_wait_seconds, scroll for uvAnimTime
    float totalAnimTime = Scroll_wait_seconds + uvAnimTime;

    float curAnimTime = elapsed_time / totalAnimTime;
    float curLoopTime = curAnimTime - (float)((int)curAnimTime);

    float switchPoint = Scroll_wait_seconds / totalAnimTime;

    if (curLoopTime > switchPoint)
    {
        float scrollTime = curLoopTime - switchPoint; // from 0.0 to uvAnimTime
        float mult = 1.0f - switchPoint;
        float scrollCoeff = scrollTime / mult; // scaled from 0.0 to 1.0
        uv_in.x += scrollCoeff * (1.0f + uvEmptySpace);
        if (uv_in.x > (1.0f + uvEmptySpace))
            uv_in.x -= (1.0f + uvEmptySpace);
    }

    return image.Sample(textureSampler, uv_in);
}
