Shader "SelfLearn/SineVertexDisplacement" {
    Properties {
        _Color("Color", Color) = (1, 1, 1, 1)
        _Frequency("Frequency", Float) = 0.1
        _Speed("Speed", Float) = 1.0
        _Amplitude("Amplitude", Float) = 1.0
        _Axis("Axis", Vector) = (0, 1, 0, 1)
    }

    SubShader {
        Tags {
            "RenderType"="Opaque"
        }

        Pass {
            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM

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

            float4 _Axis, _Color;
            float _Frequency, _Speed, _Amplitude;

            float4 Unity_Combine_float(float R, float G, float B, float A)
            {
                return float4(R, G, B, A);
            }

            v2f vert(data input) {
                float time = _Speed * _Time * 200;

                float4 sineWave = sin(time + input.vertex * _Frequency) * _Amplitude;

                float3 waveX = sineWave * _Axis.r;
                float3 waveY = sineWave * _Axis.g;
                float3 waveZ = sineWave * _Axis.b;

                float4 modifiedVerts = Unity_Combine_float(
                    input.vertex.x + waveX,
                    input.vertex.y + waveY,
                    input.vertex.z + waveZ,
                    1
                );

                v2f o;
                o.vertex = UnityObjectToClipPos(modifiedVerts);
                o.uv = input.uv;
                return o;
            }

            fixed4 frag(v2f input): SV_TARGET {
                return _Color;
            }

            ENDHLSL
        }
    }
}