/**
 * Commons file for all other shaderfilter shaders.
 */

#define PI 3.14159265f
#define PI2 6.2831853f

#ifdef FILTER
#endif // FILTER

#ifdef TRANSITION
uniform texture2d image_a;
uniform texture2d image_b;
uniform float transition_time<
    string label = "Transittion Time";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 1.0;
    float step = 0.001;
> = 0.5;
uniform bool convert_linear = true;
#endif // TRANSITION


float rand(float2 n)
{
    return frac(sin(dot(n, float2(12.9898f, 4.1414f))) * 43758.5453f);
}

float mod(float x, float y)
{
    return x - y * floor(x / y);
}
