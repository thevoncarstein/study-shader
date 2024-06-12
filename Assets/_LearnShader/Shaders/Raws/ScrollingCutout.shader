Shader "SelfLearn/ScrollingCutout" {
    Properties {
        _Texture("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _HorizontalSpeed("Horizontal Speed" , Range(0, 100)) = 1
        _VerticalSpeed("Vertical", Range(0, 100)) = 1
    }

    SubShader {
        Tags {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }

        Pass {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct data {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };

            struct v2f {
                float4 vertex: SV_POSITION;
                float2 uv: TEXCOORD0;
            };

            Texture2D _Texture;
            SamplerState _SamplerRepeatLinear;
            float4 _Color, _Texture_ST;
            float _HorizontalSpeed, _VerticalSpeed, _Foo;

            v2f vert(data input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = TRANSFORM_TEX(input.uv, _Texture);

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                input.uv.x += _Time * _HorizontalSpeed;
                input.uv.y += _Time * _VerticalSpeed;

                float4 tex = _Texture.Sample(_SamplerRepeatLinear, input.uv);
                float4 invertedColor = float4(1.0f - tex.aaa, 1.0f);
                float dis = distance(float4(1, 1, 1, 1), invertedColor);
                float colorMask = lerp(float4(1, 1, 1, 1), invertedColor, saturate(dis - 1));

                return colorMask * _Color;
            }

            ENDCG
        }
    }
}