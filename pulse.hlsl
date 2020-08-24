float4 mainImage(VertData v_in) : TARGET
{
    float multiplier = (0.1f * sin(elapsed_time * 0.4f)) + 0.9f;
    if (multiplier < 0.0f)
        multiplier = multiplier * -1.0f;
    return multiplier * image.Sample(textureSampler, v_in.uv);
}
