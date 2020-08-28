uniform float Pulse_multiplier = 0.5f;
uniform float Pulse_shift = 0.5f; // coefficient from 0.0 to 1.0
uniform float Pulse_period = 4.0f; // in seconds

float4 mainImage(VertData v_in) : TARGET
{
    const float PI = 3.14159265f;
    float multiplier = Pulse_shift + (Pulse_multiplier * sin(elapsed_time * (2 * PI / Pulse_period)));
    return float4(multiplier, multiplier, multiplier, 1.0f) * image.Sample(textureSampler, v_in.uv);
}
