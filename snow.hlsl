/**
 * Snowfall-like shader
 *
 * Adds some snowflakes on top of what is currently drawn
 *
 * Based on https://www.shadertoy.com/view/Mdt3Df
 */

uniform int Snow_density = 12;
uniform int Snow_layers = 2;

float rand(float2 uv_in)
{
    return frac(sin(dot(uv_in, float2(12.9898, 78.233))) * 43758.5453);
}

float4 render(float2 uv_in)
{
    float snow = 0.0f;
    float random = rand(uv_in);

    for (int k = 0; k < Snow_layers; k++)
    {
        for (int i = 0; i < Snow_density; i++)
        {
            float cellSize = 2.0f + (i * 3.0f);
            float downSpeed = -0.3f - (sin(builtin_elapsed_time * 0.4f + float(k + i * 20)) + 1.0f) * 0.00008f;

            float2 uv = uv_in + float2(
                0.01f * sin((builtin_elapsed_time + float(k * 6185)) * 0.6 + float(i)) * (5.0f / float(i)),
                downSpeed * (builtin_elapsed_time + float(k * 1352)) * (1.0 / float(i))
            );
            float2 uvStep = ceil(uv * cellSize - 0.5f) / cellSize;
            float x = frac(sin(dot(uvStep, float2(12.9898 + float(k) * 12.0, 78.233 + float(k) * 315.156))) * 43758.5453 + float(k) * 12.0) - 0.5;
            float y = frac(sin(dot(uvStep, float2(62.2364 + float(k) * 23.0, 94.674 + float(k) * 95.0))) * 62159.8432 + float(k) * 12.0) - 0.5;

            float randomMagnitude1 = sin(builtin_elapsed_time * 2.5f) * 0.7f / cellSize;
            float randomMagnitude2 = cos(builtin_elapsed_time * 2.5f) * 0.7f / cellSize;

            float d = 5.0f * distance((uvStep + float2(x * sin(y), y) * randomMagnitude1 + float2(y, x) * randomMagnitude2), uv);

            float omiVal = frac(sin(dot(uvStep, float2(32.4691, 94.615))) * 31572.1684);
            if (omiVal < 0.08)
            {
                float newd = (x + 1) * 0.4f * clamp(1.9f - d * (15.0f + (x * 6.3f)) * (cellSize / 1.4f), 0.0f, 1.0f);
                snow += newd;
            }
        }
    }

    return image.Sample(builtin_texture_sampler, uv_in) + float4(snow, snow, snow, snow) + random * 0.005f;
}