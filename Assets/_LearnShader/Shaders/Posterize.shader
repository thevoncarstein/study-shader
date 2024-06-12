Shader "SelfLearn/Posterize" {
    Properties {
        _TopColor("Top Color", Color) = (1, 1, 1, 1)
        _BottomColor("Bottom Color", Color) = (0, 0, 0, 1)
        _FillPercentage("Fill Percentage", Range(0.0, 1.0)) = 0.5
        _Smoothness("Smoothness", Range(0.0, 1.0)) = 0.1
        _ColorBands("Color Bands", Range(1, 100)) = 10
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

            fixed4 _TopColor, _BottomColor;
            fixed _FillPercentage, _Smoothness;
            int _ColorBands;

            v2f vert(data input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                fixed4 output;
                fixed percentage;

                percentage = smoothstep(
                    _FillPercentage - _Smoothness / 2,
                    _FillPercentage + _Smoothness / 2,
                    input.uv.y
                );
                percentage = round(percentage * (_ColorBands)) / (_ColorBands);
                output = lerp(_BottomColor, _TopColor, percentage);

                return output;
            }

            ENDCG
        }
    }
}