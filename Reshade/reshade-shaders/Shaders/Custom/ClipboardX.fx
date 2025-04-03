// -------------------------------------
// ClipboardX (c) maplerecall
// -------------------------------------

// -------------------------------------
// Includes
// -------------------------------------

#include "ReShade.fxh"

// -------------------------------------
// Textures
// -------------------------------------

texture ClipboardX_Texture
{
	Width = BUFFER_WIDTH;
	Height = BUFFER_HEIGHT;
	Format = RGBA8;
};

// -------------------------------------
// Samplers
// -------------------------------------

sampler Sampler
{
	Texture = ClipboardX_Texture;
};

// -------------------------------------
// Variables
// -------------------------------------

uniform float BlendIntensity <
	ui_label = "Alpha blending level";
	ui_type = "drag";
	ui_min = 0; ui_max = 1;
	ui_step = 0.001;
> = 0.5;

uniform bool DetectSky <
    ui_label = "Detect sky (requires depth buffer)";
    ui_type = "radio";
> = false;

uniform float BlendIntensitySky <
	ui_label = "Alpha blending level for sky";
	ui_type = "drag";
	ui_min = 0; ui_max = 1;
	ui_step = 0.001;
> = 1.0;


uniform bool Debug <
    ui_label = "Debug Alpha";
    ui_type = "radio";
> = false;


// -------------------------------------
// Entrypoints
// -------------------------------------

void PS_CopyX(float4 pos : SV_Position, float2 texCoord : TEXCOORD, out float4 frontColor : SV_Target)
{
	frontColor = tex2D(ReShade::BackBuffer, texCoord);
}

void PS_PasteX(float4 pos : SV_Position, float2 texCoord : TEXCOORD, out float4 frontColor : SV_Target)
{
	const float4 backColor = tex2D(ReShade::BackBuffer, texCoord);

	if (Debug)
    {

		if (step(1, pos.x / 32 % 2) == step(1, pos.y / 32 % 2))
			frontColor = lerp(0.45, backColor, backColor.a);
		else
			frontColor = lerp(0.55, backColor, backColor.a);
			frontColor.a *= backColor.a;

        return;
    }


	frontColor = tex2D(Sampler, texCoord);

	float depth=0;

	if(DetectSky && ReShade::GetLinearizedDepth(texCoord) == 1)
	{
		frontColor = lerp(backColor, frontColor, min(1.0, BlendIntensitySky));
	}
	else
	{
		frontColor = lerp(backColor, frontColor, min(1.0, BlendIntensity));
	}
}

// -------------------------------------
// Techniques
// -------------------------------------

technique CopyX
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_CopyX;
		RenderTarget = ClipboardX_Texture;
	}
}

technique PasteX
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_PasteX;
	}
}
