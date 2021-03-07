Shader "Retro Camera/Post Process/Split Lines" 
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_MaskTex("Mask texture", 2D) = "white" {}
		_MaskBlend("Mask blending", Float) = 0.5
		_MaskSize("Mask Size", Float) = 1
		_ScrollSpeed("Scroll Speed", Float) = 1
	}

		SubShader
		{
			Pass
			{
				CGPROGRAM
				#pragma vertex vert_img
				#pragma fragment frag
				#include "UnityCG.cginc"

				uniform sampler _MainTex;
				uniform sampler2D _MaskTex;

				fixed _MaskBlend;
				fixed _MaskSize;
				float _ScrollSpeed;

				fixed4 frag(v2f_img i) : COLOR
				{
					fixed2 maskPos = i.uv * _MaskSize;
					maskPos.y += (_Time * _ScrollSpeed);
					fixed4 mask = tex2D(_MaskTex, maskPos);
					fixed4 base = tex2D(_MainTex, i.uv);

					return lerp(base, mask, _MaskBlend);
				}

				ENDCG
			}
		}
}
