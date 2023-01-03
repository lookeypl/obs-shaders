/**
 * Commons file for all other StreamFX effects.
 *
 * Contains some defines and variables which are preset by StreamFX and could be used in shaders.
 */

#define PI 3.14159265f
#define PI2 6.2831853f

// These are all automatic uniforms provided by StreamFX
uniform float4x4 ViewProj<
    bool automatic = true;
>;

uniform float4 Time<
    bool automatic = true;
>;

uniform float4 ViewSize<
    bool automatic = true;
>;

uniform int RandomSeed<
    bool automatic = true;
>;

uniform float4x4 Random<
    bool automatic = true;
>;

#ifdef FILTER
uniform texture2d InputA<
    bool automatic = true;
>;
#endif // FILTER

#ifdef TRANSITION
uniform texture2d InputA<
    bool automatic = true;
>;

uniform texture2d InputB<
    bool automatic = true;
>;

uniform float TransitionTime<
    bool automatic = true;
>;
#endif // TRANSITION


struct VSInfo {
    float4 position : POSITION;
    float4 texcoord0 : TEXCOORD0;
};

sampler_state DefaultSampler {
    Filter    = Linear;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

VSInfo DefaultVS(VSInfo vtx) {
    vtx.position = mul(float4(vtx.position.xyz, 1.0), ViewProj);
    return vtx;
};

float rand(float2 n)
{
    return frac(sin(dot(n, float2(12.9898f, 4.1414f))) * 43758.5453f);
}

float mod(float x, float y)
{
    return x - y * floor(x / y);
}
