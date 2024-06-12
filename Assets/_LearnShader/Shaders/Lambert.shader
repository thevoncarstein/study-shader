Shader "SelfLearn/Lambert" {
    Properties {
        _MainColor("Main Color", Color) = (1, 1, 1, 1)
        _AmbientColor("Ambient Color", Color) = (0, 0, 0, 1)
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
            #include "Lighting.cginc"

            struct data {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };

            struct v2f {
                float4 vertex: SV_POSITION;
                float3 normal: NORMAL;
            };

            fixed4 _MainColor, _AmbientColor;

            v2f vert(data input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.normal = input.normal;

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                fixed4 output;

                float3 lightSource = _WorldSpaceLightPos0.xyz;
                float lightFallOff = max(0, dot(lightSource, input.normal));
                float3 directDiffuseLight = lightFallOff * _LightColor0;

                float3 diffuseLight = directDiffuseLight + _AmbientColor;
                output = fixed4(diffuseLight * _MainColor, 1);

                return output;
            }

            ENDCG
        }
    }
}