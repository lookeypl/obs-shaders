/**
 * Smart-scroll shader
 *
 * Provides a bit more facility to scrolling an OBS source compared to native scroller.
 * Allows to "stop" the scroll every loop, modify speed and introduce a gap between loops.
 */

#include "common.hlsl"

#pragma shaderfilter set Cut_width__min 0
#pragma shaderfilter set Cut_width__description Source cut width (px)
uniform int Cut_width = 0; // in pixels

#pragma shaderfilter set Scroll_loop_empty_space__min 0
#pragma shaderfilter set Scroll_loop_empty_space__description Gap width (px)
uniform int Scroll_loop_empty_space = 50; // in pixels

#pragma shaderfilter set Scroll_wait_seconds__min 0.0
#pragma shaderfilter set Scroll_wait_seconds__description Scroll pause per loop (s)
uniform float Scroll_wait_seconds = 2.0f; // in seconds

#pragma shaderfilter set Scroll_speed__min 0
#pragma shaderfilter set Scroll_speed__description Scroll speed (px/s)
uniform int Scroll_speed = 40; // in pixels/second


float4 render(float2 uv_in)
{
    // early exit if there's nothing to cut
    if ((Cut_width == 0) || (builtin_uv_size.x < Cut_width))
        return image.Sample(builtin_texture_sampler, uv_in);

    float uvCutPoint = (float)(Cut_width) / builtin_uv_size.x;

    if (uv_in.x > uvCutPoint)
        return float4(0.0f, 0.0f, 0.0f, 0.0f);

    const float emptySpace = (float)Scroll_loop_empty_space;
    float uvEmptySpace = emptySpace / builtin_uv_size.x;

    float uvAnimTime = (float)(builtin_uv_size.x + emptySpace) / Scroll_speed;

    // pause for Scroll_wait_seconds, scroll for uvAnimTime
    float totalAnimTime = Scroll_wait_seconds + uvAnimTime;

    float curAnimTime = builtin_elapsed_time / totalAnimTime;
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

    return image.Sample(builtin_texture_sampler, uv_in);
}
