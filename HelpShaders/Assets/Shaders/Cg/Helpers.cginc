static const float PI = 3.14159265;
static const float E = 0.000001;

inline float circle(in float2 st, in float radius, in float grsize)
{
    float2 dist = length(st - float2(0.5, 0.5));
	  return 1 - smoothstep(radius - grsize * radius * 2, radius + E, dist);
}

inline float ring(in float2 st, in float radius, in float grin, in float grout, in float width)
{
    float halfWidth = width / 2;
    float halfGrIn = grin / 2;
    float halfGrOut = grout / 2;
    float2 dist = length(st - float2(0.5, 0.5));
	  return (smoothstep(radius - halfGrIn - halfWidth, radius + halfGrIn - halfWidth + E , dist) *
    smoothstep(radius + halfGrOut + halfWidth, radius - halfGrOut + halfWidth - E, dist));
}

inline float2x2 scale2d(in float2 scale)
{
    return float2x2(scale.x, 0.0, 0.0, scale.y);
}

inline float2x2 rotate2d(in float angle)
{
    return float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
}
