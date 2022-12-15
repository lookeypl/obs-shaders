uniform float Pulse_multiplier = 0.5f;
uniform float Pulse_shift = 0.5f; // coefficient from 0.0 to 1.0
uniform float Pulse_period = 4.0f; // in seconds

float4 render(float2 uv_in)
{
    const float PI = 3.14159265f;
    float multiplier = Pulse_shift + (Pulse_multiplier * sin(builtin_elapsed_time * (2 * PI / Pulse_period)));
    return float4(multiplier, multiplier, multiplier, 1.0f) * image.Sample(builtin_texture_sampler, uv_in);
}
