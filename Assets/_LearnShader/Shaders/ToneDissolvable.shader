Shader "SelfLearn/ToneDissolvable" {
    Properties {
        _Resolution("Resolution", float) = 30
        _Main("Main", Color) = (1, 1, 1, 1)
        _Edge("Edge", Color) = (0, 0, 0, 1)
        _EdgePercentage("Edge Percentage", Range(0, 1)) = 0.3
        _Progress("Progress", Range(0, 1)) = 0.5
    }

    SubShader {
        Tags {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
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
            
            float4 _Main, _Edge;
            float _Resolution, _EdgePercentage, _Progress;

            float RandomValue(float2 uv) {
                return frac(
                    sin(
                        dot(
                            uv,
                            float2(23.52345, 4.76867)
                        )
                    ) * 54092.34523
                );
            }

            float CalculateNoise(float2 uv) {
                float2 i = floor(uv);
                float2 f = frac(uv);
                f = f * f * (3 - 2 * f);

                uv = abs(frac(uv) - 0.5);
                float2 c0 = i + float2(0, 0);
                float2 c1 = i + float2(1, 0);
                float2 c2 = i + float2(0, 1);
                float2 c3 = i + float2(1, 1);
                float r0 = RandomValue(c0);
                float r1 = RandomValue(c1);
                float r2 = RandomValue(c2);
                float r3 = RandomValue(c3);

                float bottom = lerp(r0, r1, f.x);
                float top = lerp(r2, r3, f.x);
                float t = lerp(bottom, top, f.y);

                return t;
            }

            float ValueNoise(float2 uv, float scale) {
                float t = 0.0;

                float freq = pow(2, 0);
                float amp = pow(0.5, 3);
                float2 ratio = uv * scale / freq;
                t += CalculateNoise(ratio) * amp;

                freq = pow(2, 1);
                amp = pow(0.5, 2);
                ratio = uv * scale / freq;
                t += CalculateNoise(ratio) * amp;

                freq = pow(2, 2);
                amp = pow(0.5, 1);
                ratio = uv * scale / freq;
                t += CalculateNoise(ratio) * amp;

                return t;
            }

            float4 Remap(float4 input, float2 inMinMax, float2 outMinMax) {
                return outMinMax.x + (input - inMinMax.x) * (outMinMax.y - outMinMax.x) / (inMinMax.y - inMinMax.x);
            }

            v2f vert(data input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                float noise = ValueNoise(input.uv, _Resolution);

                float alpha = Remap(noise, float2(-1, 1), float2(0, 1));
                float progress = Remap(_Progress, float2(-1.25, 1.25), float2(0, 1));

                float offset = alpha - _EdgePercentage;
                float offsetStep = step(offset, progress);
                float4 edge = offsetStep * _Edge;

                float inner = abs(float4(1, 1, 1, 1) - offsetStep);
                float4 inside = inner * _Main;

                clip(alpha - progress);

                return inside + edge;
            }

            ENDHLSL
        }
    }
}