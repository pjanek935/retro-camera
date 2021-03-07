Shader "Retro Camera/Post Process/Combine Two Render Textures"
{
    Properties
    {
		_MainTex("Base (RGB)", 2D) = "black" {}
		_FrontTex("Base (RGB)", 2D) = "black" {}
		_BackTex("Base (RGB)", 2D) = "black" {}
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _FrontTex;
			uniform sampler2D _BackTex;

			struct Input
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
			};

			float4 frag(Input i) : COLOR
			{
				half4 frontColor = tex2D(_FrontTex, i.uv);
				half4 backColor = tex2D(_BackTex, i.uv);
				half threshold = step(frontColor.a, 0);

				return backColor * threshold + frontColor * (1 - threshold);
			}

            ENDCG
        }
    }
}
