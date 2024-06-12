Shader "SelfLearn/WorldSpace" {
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
                float3 worldPosition: TEXCOORD0;
            };

            v2f vert(data input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.worldPosition = mul(unity_ObjectToWorld, input.vertex);

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                return fixed4(input.worldPosition, 1);
            }
            
            ENDCG
        }
    }
}