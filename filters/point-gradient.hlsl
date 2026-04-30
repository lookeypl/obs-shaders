/**
 * Gradient between two selected points
 *
 *
 */

#include "../common.hlsl"

uniform float First_step_U<
    string label = "First step U coord";
    string widget_type = "slider";
    float minimum = -1.0f;
    float maximum = 2.0f;
    float step = 0.01f;
> = 0.2f;

uniform float First_step_V<
    string label = "First step V coord";
    string widget_type = "slider";
    float minimum = -1.0f;
    float maximum = 2.0f;
    float step = 0.01f;
> = 0.2f;

uniform float4 First_step_color<
    string label = "First step color";
> = { 0.2f, 0.2f, 0.2f, 1.0f };

uniform float Second_step_U<
    string label = "Second step U coord";
    string widget_type = "slider";
    float minimum = -1.0f;
    float maximum = 2.0f;
    float step = 0.01f;
> = 0.8f;

uniform float Second_step_V<
    string label = "Second step V coord";
    string widget_type = "slider";
    float minimum = -1.0f;
    float maximum = 2.0f;
    float step = 0.01f;
> = 0.8f;

uniform float4 Second_step_color<
    string label = "Second step color";
> = { 0.8f, 0.8f, 0.8f, 1.0f };

uniform bool Override_alpha<
    string label = "Override final Alpha";
> = false;

uniform float Custom_alpha<
    string label = "Custom Alpha value";
    string widget_type = "slider";
    float minimum = 0.0f;
    float maximum = 1.0f;
    float step = 0.01f;
> = 0.9f;

float4 mainImage(VertData v_in): TARGET
{
    const float2 uv_in = v_in.uv;
    const float2 first = float2(First_step_U, First_step_V);
    const float2 second = float2(Second_step_U, Second_step_V);

    float4 color = image.Sample(textureSampler, uv_in);
    float4 gradient = lerp(color, First_step_color, distance(first, uv_in));
    gradient = lerp(gradient, Second_step_color, distance(uv_in, second));

    if (Override_alpha) {
        gradient.a = Custom_alpha;
    }

    return gradient;
}
