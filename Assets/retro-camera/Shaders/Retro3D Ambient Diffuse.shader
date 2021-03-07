Shader "Retro Camera/Retro3D/Ambient Diffuse"
{
	Properties
	{
		_MainTex("Base", 2D) = "white" {}
		_GeoRes("Geometric Resolution", Float) = 40
		_TintColor("Tint Color", Color) = (1, 1, 1, 1)
		_MinimumLight("Minimum Light", Float) = 0.5
	}

		SubShader
		{
			Pass
			{
				Tags { "LightMode" = "ForwardBase" }

				CGPROGRAM

				#include "UnityCG.cginc"

				#pragma vertex vert
				#pragma fragment frag

				struct vertOutput
				{
					float4 position : SV_POSITION;
					float3 texcoord : TEXCOORD;
					half4 color : COLOR;
				};

					sampler2D _MainTex;
					float4 _MainTex_ST;
					float _GeoRes;
					uniform float4 _LightColor0;
					float4 _TintColor;
					float _MinimumLight;

				vertOutput vert(appdata_base v)
				{
					vertOutput o;

					float3 n = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
					float3 l = normalize(_WorldSpaceLightPos0.xyz);
					half4 color = half4 (dot(n, l) * (_LightColor0.rgb + (_TintColor)), 1.0);
					float t = step(_MinimumLight, color);
					color = (color * t) + _MinimumLight * (1 - t);;
					o.color = color + _TintColor * 0.1;

					float4 wp = mul(UNITY_MATRIX_MV, v.vertex);
					wp.xyz = floor(wp.xyz * _GeoRes) / _GeoRes;
					float4 sp = mul(UNITY_MATRIX_P, wp);
					o.position = sp;
					float2 uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord = float3(uv * sp.w, sp.w);

					return o;
				}

				fixed4 frag(vertOutput vo) : SV_Target
				{
					float2 uv = vo.texcoord.xy / vo.texcoord.z;
					return tex2D(_MainTex, uv) * vo.color;
				}

				ENDCG
			}


		}

			Fallback "VertexLit"
}