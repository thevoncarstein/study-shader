Shader "Example/Outliner" {
    Properties {
        _MainColor("Outline Color", Color) = (1, 1, 1, 1)
        _Width("Outline Width", Range(0, 100)) = 0
    }
    
    SubShader {
        Tags {
            "RenderType" = "Transparent"
            "RenderPipeline" = "UniveralPipeline"
        }

        Pass {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

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
            v2f _MainObject;

            v2f vert(data input) {
                v2f output;

                VertexPositionInputs vertex = GetVertexPositionInputs(input.vertex.xyz);
                output.vertex = vertex.positionCS;

                VertexNormalInputs normal = GetVertexNormalInputs(input.normal);
                output.normal = normal.normalWS;

                float distanceToCamera = distance(mul((float3x3)unity_ObjectToWorld, output.vertex.xyz), _WorldSpaceCameraPos);
                input.vertex.xyz += normalize(output.normal) * _Width * 0.001 * distanceToCamera;
                output.vertex = TransformObjectToHClip(input.vertex.xyz);

                return output;
            }

            half4 frag(v2f input): SV_TARGET {
                return _MainColor;
            }

            ENDHLSL
        }
    }
}