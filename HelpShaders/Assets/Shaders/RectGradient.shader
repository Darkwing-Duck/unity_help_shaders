Shader "Unlit/Gradient/Rect"
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
        // gradient angle
        _Width ("Width", Range(0, 2)) = 0.8
        _Height ("Height", Range(0, 2)) = 0.8
        // gradient width
        _GrSize ("Gradient Size", Range(0, 2)) = 0.2
        // gradient angle
        _Angle ("Angle", Range(0, 360)) = 0
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

            float _Width;
            float _Height;
            float _GrSize;
            float _Angle;

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

                // displace to origin
                st -= 0.5;
                // apply rotation matrix
                st = mul(rotate2d(_Angle * DEG_2_RAD), st);
                // back to the center
                st += 0.5;

                fixed gr = rect(st, _Width, _Height, _GrSize);

                // apply _ColorIn and _ColorOut
                col *= gr * _ColorIn + (1 - gr) * _ColorOut;
                return col * i.color;
            }
            ENDCG
        }
    }
}
