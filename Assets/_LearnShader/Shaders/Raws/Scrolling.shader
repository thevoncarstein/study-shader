Shader "SelfLearn/Scrolling" {
    Properties {
        _Texture("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _Subcolor("Sub Color", Color) = (1, 1, 1, 1)
        _HorizontalSpeed("Horizontal Speed", Range(0, 100)) = 1
        _VerticalSpeed("Vertical Speed", Range(0, 100)) = 1
    }

    SubShader {
        Tags {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
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

            SamplerState samplerLinearRepeat;
            Texture2D _Texture;
            float4 _Texture_ST, _Color, _Subcolor;
            
            float _HorizontalSpeed, _VerticalSpeed, _Scale;

            v2f vert(data input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = TRANSFORM_TEX(input.uv, _Texture);

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                input.uv.x += _Time * _HorizontalSpeed;
                input.uv.y += _Time * _VerticalSpeed;

                float4 mainColor = _Texture.Sample(samplerLinearRepeat, input.uv) * _Color;
                float4 subColor = float4(1.0f - mainColor.aaa, 1.0f) * _Subcolor;
                
                float4 result = max(subColor, mainColor);
                return result;
            }

            ENDCG
        }
    }
}