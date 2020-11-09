Shader "Retro Camera/Post Process/Two Colors"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Threshold("Threshold", Float) = 0.5
		_Color1("Color 1", Color) = (0, 0, 0, 1)
		_Color2("Color 2", Color) = (1, 1, 1, 1)
	}
		SubShader
		{
			Cull Off ZWrite Off ZTest Always

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				sampler2D _MainTex;
				float4 _Color1;
				float4 _Color2;
				float _Threshold;

				fixed4 frag(v2f i) : SV_TARGET
				{
					float4 texColor = tex2D(_MainTex, i.uv);
					float grayScale = 0.3 * texColor.r + 0.59 * texColor.b + 0.11 * texColor.b;
					
					return lerp (_Color1, _Color2, step (grayScale, _Threshold));
				}

				ENDCG
			}
		}
}