Shader "SelfLearn/DissolvableValueNoise" {
    Properties {
        _Scale("Scale", float) = 1
        _Threshold("Thresold", Range(0, 1)) = 0.5
        _Progress("Progress", Range(-1, 1)) = -1
    }

    SubShader {
        Tags {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }

        Pass {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM

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

            inline float unity_noise_randomValue(float2 uv) {
                return frac(
                    sin(
                        dot(
                            uv,
                            float2(3.123908, 23.458937)
                        )
                    ) * 12937.23457
                );
            }
            
            inline float unity_valueNoise(float2 uv) {
                float2 i = floor(uv);
                float2 f = frac(uv);
                f = f * f * (3 - 2 * f);

                uv = abs(frac(uv) - 0.5);
                float2 c0 = i + float2(0, 0);
                float2 c1 = i + float2(1, 0);
                float2 c2 = i + float2(0, 1);
                float2 c3 = i + float2(1, 1);
                float r0 = unity_noise_randomValue(c0);
                float r1 = unity_noise_randomValue(c1);
                float r2 = unity_noise_randomValue(c2);
                float r3 = unity_noise_randomValue(c3);

                float bottomOfGrid = lerp(r0, r1, f.x);
                float topOfGrid = lerp(r2, r3, f.x);
                float t = lerp(bottomOfGrid, topOfGrid, f.y);

                return t;
            }

            float Unity_SimpleNoise_float(float2 uv, float scale) {
                float t = 0.0;

                float freq = pow(2, 0);
                float amp = pow(0.5, 3);
                float2 ratio = uv * scale / freq;
                t += unity_valueNoise(ratio) * amp;

                freq = pow(2, 1);
                amp = pow(0.5, 2);
                ratio = uv * scale / freq;
                t += unity_valueNoise(ratio) * amp;

                freq = pow(2, 2);
                amp = pow(0.5, 1);
                ratio = uv * scale / freq;
                t += unity_valueNoise(ratio) * amp;

                return t;
            }

            inline float4 Remap(float4 input, float2 inMinMax, float2 outMinMax) {
                return outMinMax.x + (input - inMinMax.x) * (outMinMax.y - outMinMax.x) / (inMinMax.y - inMinMax.x);
            }

            float _Scale, _Threshold, _Progress;

            v2f vert(data input) {
                v2f output;
                
                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                // _Progress = Remap(_Progress, float2(-1, 1), float2(0, 1));
                float alpha = Unity_SimpleNoise_float(input.uv, _Scale);
                // clip(alpha - _Progress);

                float3 skin = step(alpha, _Threshold);
                fixed4 output = float4(skin, 1);

                return output;
            }

            ENDCG
        }
    }
}