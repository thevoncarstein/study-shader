Shader "SelfLearn/SpecularCellShade" {
    Properties {
        _MainColor("Main Color", Color) = (1, 1, 1, 1)
        _AmbientColor("Ambient Color", Color) = (0, 0, 0, 1)
        _Gloss("Gloss", Range(0, 1000)) = 15
        _LightStepOff("Light Step Off", Range(0, 1)) = 0
        _GlossStepOff("Gloss Step Off", Range(0, 1)) = 0
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
                float3 worldPosition: TEXCOORD0;
            };

            fixed4 _MainColor, _AmbientColor;
            int _Gloss;
            fixed _LightStepOff, _GlossStepOff;

            v2f vert(data input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.normal = input.normal;
                output.worldPosition = mul(unity_ObjectToWorld, input.vertex);

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                fixed4 output;

                float3 normal = normalize(input.normal);
                float3 fragmentToCamera = _WorldSpaceCameraPos - input.worldPosition;
                float3 viewDirection = normalize(fragmentToCamera);

                float3 lightSource = _WorldSpaceLightPos0.xyz;
                float lightFallOff = max(0, dot(lightSource, normal));
                lightFallOff = step(_LightStepOff, lightFallOff);
                float3 directDiffuseLight = lightFallOff * _LightColor0;

                float3 reflectDirection = reflect(-viewDirection, normal);
                float specularFallOff = max(0, dot(reflectDirection, lightSource));
                specularFallOff = pow(specularFallOff, _Gloss);
                specularFallOff = step(_GlossStepOff, specularFallOff);
                float3 directSpecularLight = specularFallOff * _LightColor0;

                float3 diffuseLight = _AmbientColor + directDiffuseLight;
                output = fixed4(diffuseLight * _MainColor + directSpecularLight, 1);

                return output;
            }

            ENDCG
        }
    }
}