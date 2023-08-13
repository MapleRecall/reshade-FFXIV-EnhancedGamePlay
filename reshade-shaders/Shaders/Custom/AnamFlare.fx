// Copyright (c) 2009-2015 Gilcher Pascal aka Marty McFly

uniform bool bAnamFlareEnable <
> = false;
uniform float fAnamFlareThreshold <
	ui_type = "slider";
	ui_min = 0.1; ui_max = 1.0;
	ui_tooltip = "Every pixel brighter than this value gets a flare.";
> = 0.9;
uniform float fAnamFlareWideness <
	ui_type = "slider";
	ui_min = 1.0; ui_max = 2.5;
	ui_tooltip = "Horizontal wideness of flare. Don't set too high, otherwise the single samples are visible.";
> = 2.4;
uniform float fAnamFlareAmount <
	ui_type = "slider";
	ui_min = 1.0; ui_max = 20.0;
	ui_tooltip = "Intensity of anamorphic flare.";
> = 14.5;
uniform float fAnamFlareCurve <
	ui_type = "slider";
	ui_min = 1.0; ui_max = 2.0;
	ui_tooltip = "Intensity curve of flare with distance from source.";
> = 1.2;
uniform float3 fAnamFlareColor <
	ui_type = "color";
	ui_tooltip = "R, G and B components of anamorphic flare. Flare is always same color.";
> = float3(0.012, 0.313, 0.588);

// If 1, only pixels with depth = 1 get lens flares
// This prevents white objects from getting lens flares sources, which would normally happen in LDR
#ifndef LENZ_DEPTH_CHECK
	#define LENZ_DEPTH_CHECK 0
#endif
#ifndef CHAPMAN_DEPTH_CHECK
	#define CHAPMAN_DEPTH_CHECK 0
#endif
#ifndef GODRAY_DEPTH_CHECK
	#define GODRAY_DEPTH_CHECK 0
#endif
#ifndef FLARE_DEPTH_CHECK
	#define FLARE_DEPTH_CHECK 0
#endif

// texture texDirt2 < source = "LensDB.png"; > { Width = 1920; Height = 1080; Format = RGBA8; };
// texture texSprite2 < source = ""; > { Width = 1920; Height = 1080; Format = RGBA8; };

// sampler SamplerDirt2 { Texture = texDirt2; };
// sampler SamplerSprite2 { Texture = texSprite2; };

texture texBloom1
{
	Width = BUFFER_WIDTH;
	Height = BUFFER_HEIGHT;
	Format = RGBA16F;
};
texture texBloom2
{
	Width = BUFFER_WIDTH;
	Height = BUFFER_HEIGHT;
	Format = RGBA16F;
};
texture texBloom3
{
	Width = BUFFER_WIDTH / 2;
	Height = BUFFER_HEIGHT / 2;
	Format = RGBA16F;
};
texture texBloom4
{
	Width = BUFFER_WIDTH / 4;
	Height = BUFFER_HEIGHT / 4;
	Format = RGBA16F;
};
texture texBloom5
{
	Width = BUFFER_WIDTH / 8;
	Height = BUFFER_HEIGHT / 8;
	Format = RGBA16F;
};

sampler SamplerBloom1 { Texture = texBloom1; };
sampler SamplerBloom2 { Texture = texBloom2; };
sampler SamplerBloom3 { Texture = texBloom3; };
sampler SamplerBloom4 { Texture = texBloom4; };
sampler SamplerBloom5 { Texture = texBloom5; };

#include "ReShade.fxh"

float4 GaussBlur22(float2 coord, sampler tex, float mult, float lodlevel, bool isBlurVert)
{
	float4 sum = 0;
	float2 axis = isBlurVert ? float2(0, 1) : float2(1, 0);

	const float weight[11] = {
		0.082607,
		0.080977,
		0.076276,
		0.069041,
		0.060049,
		0.050187,
		0.040306,
		0.031105,
		0.023066,
		0.016436,
		0.011254
	};

	for (int i = -10; i < 11; i++)
	{
		float currweight = weight[abs(i)];
		sum += tex2Dlod(tex, float4(coord.xy + axis.xy * (float)i * ReShade::PixelSize * mult, 0, lodlevel)) * currweight;
	}

	return sum;
}

void BloomPass0(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 bloom : SV_Target)
{
	bloom = 0.0;

	const float2 offset[4] = {
		float2(1.0, 1.0),
		float2(1.0, 1.0),
		float2(-1.0, 1.0),
		float2(-1.0, -1.0)
	};

	for (int i = 0; i < 4; i++)
	{
		float2 bloomuv = offset[i] * ReShade::PixelSize.xy * 2;
		bloomuv += texcoord;
		float4 tempbloom = tex2Dlod(ReShade::BackBuffer, float4(bloomuv.xy, 0, 0));
		tempbloom.w = max(0, dot(tempbloom.xyz, 0.333) - fAnamFlareThreshold);
		bloom += tempbloom;
	}

	bloom *= 0.25;
}
void BloomPass1(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 bloom : SV_Target)
{
	bloom = 0.0;

	const float2 offset[8] = {
		float2(1.0, 1.0),
		float2(0.0, -1.0),
		float2(-1.0, 1.0),
		float2(-1.0, -1.0),
		float2(0.0, 1.0),
		float2(0.0, -1.0),
		float2(1.0, 0.0),
		float2(-1.0, 0.0)
	};

	for (int i = 0; i < 8; i++)
	{
		float2 bloomuv = offset[i] * ReShade::PixelSize * 4;
		bloomuv += texcoord;
		bloom += tex2Dlod(SamplerBloom1, float4(bloomuv, 0, 0));
	}

	bloom *= 0.125;
}
void BloomPass2(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 bloom : SV_Target)
{
	bloom = 0.0;

	const float2 offset[8] = {
		float2(0.707, 0.707),
		float2(0.707, -0.707),
		float2(-0.707, 0.707),
		float2(-0.707, -0.707),
		float2(0.0, 1.0),
		float2(0.0, -1.0),
		float2(1.0, 0.0),
		float2(-1.0, 0.0)
	};

	for (int i = 0; i < 8; i++)
	{
		float2 bloomuv = offset[i] * ReShade::PixelSize * 8;
		bloomuv += texcoord;
		bloom += tex2Dlod(SamplerBloom2, float4(bloomuv, 0, 0));
	}

	bloom *= 0.5; // brighten up the sample, it will lose brightness in H/V Gaussian blur
}
void BloomPass3(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 bloom : SV_Target)
{
	bloom = GaussBlur22(texcoord.xy, SamplerBloom3, 16, 0, 0);
	bloom.w *= fAnamFlareAmount;
}
void BloomPass4(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 bloom : SV_Target)
{
	bloom.w = GaussBlur22(texcoord, SamplerBloom4, 32 * fAnamFlareWideness, 0, 0).w * 2.5; // to have anamflare texture (bloom.w) avoid vertical blur
}

void LightingCombine(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
	color = tex2D(ReShade::BackBuffer, texcoord);

	// Anamorphic flare
	if (bAnamFlareEnable)
	{
		float3 anamflare = tex2D(SamplerBloom5, texcoord.xy).w * 2 * fAnamFlareColor;
		anamflare = max(anamflare, 0.0);
		color.rgb += pow(anamflare, 1.0 / fAnamFlareCurve);
	}
}

technique AnamorphicFlare<ui_label = "Anamorphic Lens Flare";>
{
	pass BloomPass0
	{
		VertexShader = PostProcessVS;
		PixelShader = BloomPass0;
		RenderTarget = texBloom1;
	}
	pass BloomPass1
	{
		VertexShader = PostProcessVS;
		PixelShader = BloomPass1;
		RenderTarget = texBloom2;
	}
	pass BloomPass2
	{
		VertexShader = PostProcessVS;
		PixelShader = BloomPass2;
		RenderTarget = texBloom3;
	}
	pass BloomPass3
	{
		VertexShader = PostProcessVS;
		PixelShader = BloomPass3;
		RenderTarget = texBloom4;
	}
	pass BloomPass4
	{
		VertexShader = PostProcessVS;
		PixelShader = BloomPass4;
		RenderTarget = texBloom5;
	}

	pass LightingCombine
	{
		VertexShader = PostProcessVS;
		PixelShader = LightingCombine;
	}
}
