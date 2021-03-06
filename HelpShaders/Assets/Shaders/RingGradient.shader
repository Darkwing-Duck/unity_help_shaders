﻿Shader "Unlit/Gradient/Ring"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        [Space(10)]
        // gradient start color
        _ColorIn ("Color In", Color) = (1, 1, 1, 1)
        // gradient ent color
        _ColorOut ("Color Out", Color) = (1, 1, 1, 1)

        [Space(10)]
        // circle radius
        _Radius ("Radius", Range(0, 5)) = 0.4
        // ring width
        _Width ("Ring Width", Range(0, 1)) = 0.05

        [Space(10)]
        // inner gradient size
        _GrIn ("Inner Gradient Size", Range(0, 2)) = 0.1
        // outter gradient size
        _GrOut ("Outter Gradient Size", Range(0, 2)) = 0.1

        [Space(10)]
        _ScaleX ("Scale X", Range(0, 1)) = 1
        _ScaleY ("Scale Y", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" "IgnoreProjector"="True" }
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Cg/Helpers.cginc"
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color    : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                fixed4 color    : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _ColorIn;
            fixed4 _ColorOut;

            float _Radius;
            float _Width;

            float _GrIn;
            float _GrOut;

            float _ScaleX;
            float _ScaleY;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 st = frac(i.uv);

                // sample the texture
                fixed4 col = tex2D(_MainTex, st);
                float2 scale = half2(_ScaleX, _ScaleY);

                // displace to origin
                st -= 0.5;
                // apply scale
                st /= scale;
                // back to the center
                st += 0.5;

                fixed gr = ring(st, _Radius, _GrIn, _GrOut, _Width);

                // apply _ColorIn and _ColorOut
                col *= gr * _ColorIn + (1 - gr) * _ColorOut;
                return col * i.color;
            }
            ENDCG
        }
    }
}
