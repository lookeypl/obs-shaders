/**
 * Smart-scroll shader
 *
 * Provides a bit more facility to scrolling an OBS source compared to native scroller.
 * Allows to "stop" the scroll every loop, modify speed and introduce a gap between loops.
 */

#define FILTER
#include "../common.hlsl"

uniform bool Vertical_scroll<
    string label = "Vertical scroll";
> = false;

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

    float size;
    float coord;
    if (Vertical_scroll)
    {
        size = uv_size.y;
        coord = uv_in.y;
    }
    else
    {
        size = uv_size.x;
        coord = uv_in.x;
    }

    // early exit if there's nothing to cut
    if ((Cut_width == 0) || (size < Cut_width))
        return image.Sample(textureSampler, uv_in);

    float uvCutPoint = (float)(Cut_width) / size;

    if (coord > uvCutPoint)
        return float4(0.0f, 0.0f, 0.0f, 0.0f);

    const float emptySpace = (float)Scroll_loop_empty_space;
    float uvEmptySpace = emptySpace / size;

    float uvAnimTime = (float)(size + emptySpace) / Scroll_speed;

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
        coord += scrollCoeff * (1.0f + uvEmptySpace);
        if (coord > (1.0f + uvEmptySpace))
            coord -= (1.0f + uvEmptySpace);
    }

    if (Vertical_scroll)
        uv_in.y = coord;
    else
        uv_in.x = coord;

    return image.Sample(textureSampler, uv_in);
}
