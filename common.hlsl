/**
 * Commons file for all other shaderfilter plus shaders.
 */

#define PI 3.14159265f
#define PI2 6.2831853f


float rand(float2 n)
{
    return frac(sin(dot(n, float2(12.9898f, 4.1414f))) * 43758.5453f);
}

float mod(float x, float y)
{
    return x - y * floor(x / y);
}
