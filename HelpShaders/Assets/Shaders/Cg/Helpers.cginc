static const float PI = 3.14159265;
static const float E = 0.000001;

inline float circle(in float2 st, in float radius, in float grsize)
{
    float2 dist = st - float2(0.5, 0.5);
	  return 1 - smoothstep(radius - (E * radius) - grsize * 4, radius + (E * radius), dot(dist, dist) * 4);
}

inline float2x2 scale2d(in float2 scale)
{
    return float2x2(scale.x, 0.0, 0.0, scale.y);
}

inline float2x2 rotate2d(in float angle)
{
    return float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
}
