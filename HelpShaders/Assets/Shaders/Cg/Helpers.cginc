static const float PI = 3.14159265;
static const float E = 0.000001;
static const float RAD_2_DEG = 57.295779578552299;
static const float DEG_2_RAD = 0.0174532925;

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

inline float rect(in float2 st, in float w, in float h, in float grsize)
{
    float2 gap = float2(0.5 - w / 2, 0.5 - h / 2);
    float2 bl = smoothstep(gap - E, gap + grsize, st);
    float2 tr = smoothstep(gap - E, gap + grsize, 1.0 - st);
    return bl.x * bl.y * tr.x * tr.y;
}

inline float frame(in float2 st, in float w, in float h, in float grin, in float grout, in float width)
{
    float2 outGap = float2(0.5 - w / 2, 0.5 - h / 2) - width / 2;
    float2 inGap = float2(0.5 - w / 2, 0.5 - h / 2) + width / 2;

    float2 bl_in = smoothstep(inGap - E, inGap + grin, st);
    float2 tr_in = smoothstep(inGap - E, inGap + grin, 1.0 - st);

    float2 bl_out = smoothstep(outGap - E, outGap + grout, st);
    float2 tr_out = smoothstep(outGap - E, outGap + grout, 1.0 - st);

    return bl_out.x * bl_out.y * tr_out.x * tr_out.y - bl_in.x * bl_in.y * tr_in.x * tr_in.y;
}

inline float2x2 scale2d(in float2 scale)
{
    return float2x2(scale.x, 0.0, 0.0, scale.y);
}

inline float2x2 rotate2d(in float angle)
{
    return float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
}
