Shader "MixedWithTextures/NormalsxDiffuse" {
    Properties {
        _Textures ("Textures", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
    }

    SubShader {
        Tags {
            "RenderType" = "Opaque"
        }

        Pass {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
                float3 normals: NORMAL;
            };

            struct v2f {
                float4 vertex: SV_POSITION;
                float2 uv: TEXCOORD0;
                float3 normals: NORMAL;
            };

            sampler2D _Textures;
            float4 _Textures_ST, _Color;

            v2f vert(appdata input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;
                output.normals = input.normals;

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                return tex2D(_Textures, input.uv) * fixed4(input.normals, 1) * _Color;
            }

            ENDHLSL
        }
    }
}