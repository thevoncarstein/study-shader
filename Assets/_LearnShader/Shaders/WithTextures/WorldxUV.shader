Shader "MixedWithTextures/WorldxUV" {
    Properties {
        _Texture ("Texture", 2D) = "white" {}
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
            };

            struct v2f {
                float4 vertex: SV_POSITION;
                float2 uv: TEXCOORD0;
                float3 worldPosition: TEXCOORD1;
            };

            sampler2D _Texture;
            float4 _Texture_ST;

            v2f vert(appdata input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;
                output.worldPosition = mul(unity_ObjectToWorld, input.vertex);

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                return tex2D(_Texture, input.uv) * float4(input.worldPosition, 1);
            }

            ENDHLSL
        }
    }
}