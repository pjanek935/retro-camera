Shader "Retro Camera/Post Process/Dither_Two_Colors"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_DitherPattern("Texture", 2D) = "white" {}
		_Color1("Dither Color 1", Color) = (0, 0, 0, 1)
		_Color2("Dither Color 2", Color) = (1, 1, 1, 1)
		_DitherSize("Dither Size", int) = 4
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

			fixed4 frag(v2f i) : SV_TARGET
			{
				float4 texColor = tex2D(_MainTex, i.uv);
				float grayScaleOriginal = 0.3 * texColor.r + 0.59 * texColor.g + 0.11 * texColor.b;
				float2 coordInDitherTex = ((i.uv * _ScreenParams) % _DitherSize) / _DitherSize;
				float ditherSample = tex2D(_DitherPattern, coordInDitherTex).r;
				float4 ditheredValue = step (grayScaleOriginal, ditherSample);
				return lerp(_Color1, _Color2, ditheredValue);
			}
			ENDCG
		}
	}
}