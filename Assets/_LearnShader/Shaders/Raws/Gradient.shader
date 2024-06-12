Shader "SelfLearn/Gradient" {
    Properties {
        _TopColor("Top Color", Color) = (1, 1, 1, 1)
        _BottomColor("Bottom Color", Color) = (0, 0, 0, 1)
    }

    SubShader {
        Tags {
            "RenderType" = "Opaque"
        }

        Pass {
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

            float4 _TopColor, _BottomColor;

            v2f vert(data input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                fixed4 output = lerp(_BottomColor, _TopColor, input.uv.y);
                return output;
            }

            ENDCG
        }
    }
}