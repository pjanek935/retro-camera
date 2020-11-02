Shader "PostProcess/Dither"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_DitherPattern("Texture", 2D) = "white" {}
		_DitherSize("Dither Size", int) = 4
		_ColorQuant("Color Quantization", int) = 4
		_DitherStrength("Dither Strength", Float) = 1
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
				sampler2D _DitherPattern;
				float4 _DitherPattern_TexelSize;
				float4 _Color1;
				float4 _Color2;
				int _DitherSize;
				int _ColorQuant;
				float _DitherStrength;

				//left here just in case
				/*static const float4x4 ditherTable = float4x4
					(
						-4.0, 0.0, -3.0, 1.0,
						2.0, -2.0, 3.0, -1.0,
						-3.0, 1.0, -4.0, 0.0,
						3.0, -1.0, 2.0, -2.0
						);*/

				fixed4 frag(v2f i) : SV_TARGET
				{
					float4 texColor = tex2D(_MainTex, i.uv);
					float2 coordInDitherTex = ((i.uv * _ScreenParams) % _DitherSize) / _DitherSize;
					float4 ditherSample = tex2D(_DitherPattern, coordInDitherTex) - 0.5;
					texColor += ditherSample * _DitherStrength;
					texColor = round(texColor * _ColorQuant) / _ColorQuant;
					return texColor;
				}

				ENDCG
			}
		}
}