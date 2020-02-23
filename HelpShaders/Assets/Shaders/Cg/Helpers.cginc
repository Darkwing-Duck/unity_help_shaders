float2x2 rotate2d(float angle)
{
    return float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
}
