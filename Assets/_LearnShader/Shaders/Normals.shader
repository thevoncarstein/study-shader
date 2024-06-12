Shader "SelfLearn/Normals" {
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
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 vertex: SV_POSITION;
                float3 normal: NORMAL;
            };
            
            v2f vert(data input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.normal = input.normal;

                return output;
            }

            fixed4 frag (v2f input) : SV_Target {
                fixed4 output = fixed4(input.normal, 1);
                return output;
            }
            
            ENDCG
        }
    }
}