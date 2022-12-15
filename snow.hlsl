/**
 * Snowfall-like shader
 *
 * Adds some snowflakes on top of what is currently drawn
 *
 * Based on https://www.shadertoy.com/view/Mdt3Df
 */

#pragma shaderfilter set Snow_iterations__min 1
#pragma shaderfilter set Snow_iterations__description "Snow iterations"
uniform int Snow_iterations = 12; // affect how many snow flakes are rendered - GPU-EXPENSIVE

#pragma shaderfilter set Snow_layers__min 1
#pragma shaderfilter set Snow_layers__description "Snow layers"
uniform int Snow_layers = 2; // multiply/layer Snow_loops - GPU-EXPENSIVE

#pragma shaderfilter set Snow_density__slider true
#pragma shaderfilter set Snow_density__description "Snow density"
#pragma shaderfilter set Snow_density__min 0.08
#pragma shaderfilter set Snow_density__max 0.6
#pragma shaderfilter set Snow_density__step 0.04
uniform float Snow_density = 0.08f; // affect how dense the snow is

#pragma shaderfilter set Fall_speed__slider true
#pragma shaderfilter set Fall_speed__description "Snow fall speed"
#pragma shaderfilter set Fall_speed__min 0.3
#pragma shaderfilter set Fall_speed__max 1.0
#pragma shaderfilter set Fall_speed__step 0.05
uniform float Fall_speed = 0.3f; // affect how fast the snow flakes fall

#pragma shaderfilter set Scene_zoom__slider true
#pragma shaderfilter set Scene_zoom__description "Scene zoom"
#pragma shaderfilter set Scene_zoom__min 1.0
#pragma shaderfilter set Scene_zoom__max 5.0
#pragma shaderfilter set Scene_zoom__step 0.05
uniform float Scene_zoom = 2.0f; // affect how zoomed in the scene is

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
        for (int i = 0; i < Snow_iterations; i++)
        {
            float cellSize = 3.0f + i / (Scene_zoom - 0.9);
            float downSpeed = -Fall_speed - (sin(builtin_elapsed_time * 0.4f + float(k + i * 20)) + 0.6f) * 0.00008f;

            float2 uv = uv_in + float2(
                0.02f * sin((builtin_elapsed_time + float(k * 6185)) * 0.4f + i) * (i * 0.2f),
                downSpeed * (builtin_elapsed_time + float(k * 3128)) * (1.0f / float(i))
            );
            float2 uvStep = ceil(uv * cellSize - 0.5f) / cellSize;
            float x = frac(sin(dot(uvStep, float2(12.9898 + float(k) * 12.0, 78.233 + float(k) * 315.156))) * 43758.5453 + float(k) * 12.0) - 0.5;
            float y = frac(sin(dot(uvStep, float2(62.2364 + float(k) * 23.0, 94.674 + float(k) * 95.0))) * 62159.8432 + float(k) * 12.0) - 0.5;

            float randomMagnitude1 = sin(builtin_elapsed_time * 2.5f) * 0.7f / cellSize;
            float randomMagnitude2 = cos(builtin_elapsed_time * 2.5f) * 0.7f / cellSize;

            float d = 5.0f * distance((uvStep + float2(x * sin(y), y) * randomMagnitude1 + float2(y, x) * randomMagnitude2), uv);

            float omiVal = frac(sin(dot(uvStep, float2(32.4691, 94.615))) * 31572.1684);
            if (omiVal < Snow_density)
            {
                float newd = (x + 1) * 0.4f * clamp(1.9f - d * (15.0f + (x * 6.3f)) * (cellSize / 2.0f), 0.0f, 1.0f);
                snow += newd;
            }
        }
    }

    return image.Sample(builtin_texture_sampler, uv_in) + float4(snow, snow, snow, snow) + random * 0.02f;
}