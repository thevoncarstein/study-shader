Shader "SelfLearn/Outliner" {
    Properties {
        _MainColor("Color", Color) = (1, 1, 1, 1)
        _Width("Width", Range(0, 10)) = 0
    }

    SubShader {
        Tags {
            "RenderType" = "Transparent"
        }

        Pass {
            ZWrite Off

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct data {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };

            struct v2f {
                float4 vertex: SV_POSITION;
                float3 normal: NORMAL;
            };

            float4 _MainColor;
            float _Width;

            v2f vert(data input) {
                v2f output;

                output.normal = input.normal;

                float distanceToCamera = distance(mul((float3x3)unity_ObjectToWorld, input.vertex.xyz), _WorldSpaceCameraPos);
                input.vertex.xyz += normalize(output.normal) * _Width * 0.001 * distanceToCamera;
                output.vertex = UnityObjectToClipPos(input.vertex);

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                return _MainColor;
            }

            ENDCG
        }
    }
}