/**
 * Smart-scroll shader
 *
 * Provides a bit more facility to scrolling an OBS source compared to native scroller.
 * Allows to "stop" the scroll every loop, modify speed and introduce a gap between loops.
 */

#define FILTER
#include "common.hlsl"

uniform int Cut_width<
    string name = "Source cut width (px)";
    int minimum = 0;
> = 0; // in pixels

uniform int Scroll_loop_empty_space<
    string name = "Gap width (px)";
    int minimum = 0;
> = 50; // in pixels

uniform float Scroll_wait_seconds<
    string name = "Scroll pause per loop (s)";
    float minimum = 0.0f;
> = 2.0f; // in seconds

uniform int Scroll_speed<
    string name = "Scroll speed (px/s)";
    int minimum = 0;
> = 40; // in pixels/second


float4 render(VSInfo vtx) : TARGET
{
    float2 uv_in = vtx.texcoord0.xy;

    // early exit if there's nothing to cut
    if ((Cut_width == 0) || (ViewSize.x < Cut_width))
        return InputA.Sample(DefaultSampler, uv_in);

    float uvCutPoint = (float)(Cut_width) / ViewSize.x;

    if (uv_in.x > uvCutPoint)
        return float4(0.0f, 0.0f, 0.0f, 0.0f);

    const float emptySpace = (float)Scroll_loop_empty_space;
    float uvEmptySpace = emptySpace / ViewSize.x;

    float uvAnimTime = (float)(ViewSize.x + emptySpace) / Scroll_speed;

    // pause for Scroll_wait_seconds, scroll for uvAnimTime
    float totalAnimTime = Scroll_wait_seconds + uvAnimTime;

    float curAnimTime = Time.x / totalAnimTime;
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

    return InputA.Sample(DefaultSampler, uv_in);
}


technique SmartScroll
{
    pass
    {
        vertex_shader = DefaultVS(vtx);
        pixel_shader = render(vtx);
    }
}
