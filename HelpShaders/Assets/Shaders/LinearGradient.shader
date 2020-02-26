Shader "Unlit/Gradient/Linear"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        // gradient start color
        _ColorIn ("Color In", Color) = (1, 1, 1, 1)
        // gradient ent color
        _ColorOut ("Color Out", Color) = (1, 1, 1, 1)
        // gradient angle
        _Angle ("Angle", Range(0, 360)) = 0
        // gradient width
        _Width ("Width", Range(0, 5)) = 1
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
            
            half _Angle;
            half _Width;

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
                st = mul(rotate2d(_Angle / 180 * PI), st);
                // back to the center
                st += 0.5;
                
                // get half of gradient width
                fixed halfWidth = _Width / 2;
                // gradient value
                fixed gr = smoothstep(0.5 - halfWidth, 0.5 + halfWidth, st.x);
                
                // apply _ColorIn and _ColorOut
                col *= gr * _ColorIn + (1 - gr) * _ColorOut;
                
                return col * i.color;
            }
            ENDCG
        }
    }
}
