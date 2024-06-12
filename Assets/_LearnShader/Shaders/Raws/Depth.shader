Shader "SelfLearn/Depth" {
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
            };

            struct v2f {
                float4 vertex: SV_POSITION;
                float depth: DEPTH;
            };

            v2f vert(data input) {
                v2f result;

                result.vertex = UnityObjectToClipPos(input.vertex);
                result.depth = -UnityObjectToClipPos(input.vertex).z * _ProjectionParams.w;

                return result;
            }

            fixed4 frag(v2f input): SV_TARGET {
                return fixed4(1 - input.depth.xxx, 1);
            }
            ENDCG
        }
    }
}