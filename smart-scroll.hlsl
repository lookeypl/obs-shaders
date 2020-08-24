uniform int Cut_width = 0; // in pixels
uniform int Scroll_loop_empty_space = 50; // in pixels
uniform float Scroll_wait_seconds = 2.0f; // in seconds
uniform float Scroll_speed = 40.0f; // in pixels/second

float4 mainImage(VertData v_in) : TARGET
{
    // early exit if there's nothing to cut
    if ((Cut_width == 0) || (uv_size.x < Cut_width))
        return image.Sample(textureSampler, v_in.uv);

    float uvCutPoint = Cut_width / uv_size.x;

    if (v_in.uv.x > uvCutPoint)
        return float4(0.0f, 0.0f, 0.0f, 0.0f);

    const float emptySpace = (float)Scroll_loop_empty_space;
    float uvEmptySpace = emptySpace / uv_size.x;

    float uvAnimTime = (uv_size.x + emptySpace) / Scroll_speed;

    // pause for Scroll_wait_seconds, scroll for uvAnimTime
    float totalAnimTime = Scroll_wait_seconds + uvAnimTime;

    float curAnimTime = elapsed_time / totalAnimTime;
    float curLoopTime = curAnimTime - (float)((int)curAnimTime);

    float switchPoint = Scroll_wait_seconds / totalAnimTime;

    float2 uv = v_in.uv;
    if (curLoopTime > switchPoint)
    {
        float scrollTime = curLoopTime - switchPoint; // from 0.0 to uvAnimTime
        float mult = 1.0f - switchPoint;
        float scrollCoeff = scrollTime / mult; // scaled from 0.0 to 1.0
        uv.x += scrollCoeff * (1.0f + uvEmptySpace);
        if (uv.x > (1.0f + uvEmptySpace))
            uv.x -= (1.0f + uvEmptySpace);
    }

    return image.Sample(textureSampler, uv);
}
