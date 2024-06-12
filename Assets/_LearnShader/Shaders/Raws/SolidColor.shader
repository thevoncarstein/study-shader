Shader "SelfLearn/Unlit" {
    Properties {
        _MainColor("Color", Color) = (1, 1, 1, 1)
    }
    SubShader {
        Tags {
            "RenderType" = "Opaque"
        }
        
        Pass {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 vertex: SV_POSITION;
            };
            
            float4 _MainColor;

            v2f vert(appdata input) {
                v2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);

                return output;
            }

            fixed4 frag(v2f input): SV_TARGET {
                return _MainColor;
            }

            ENDHLSL
        }
    }
}