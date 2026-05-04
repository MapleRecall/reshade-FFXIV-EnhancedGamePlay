// KeepUI for FFXIV, Phantasy Star Online, and other games with a UI depth of 0.
// Author: seri14
// 
// This is free and unencumbered software released into the public domain.
// 
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
// 
// In jurisdictions that recognize copyright laws, the author or authors
// of this software dedicate any and all copyright interest in the
// software to the public domain. We make this dedication for the benefit
// of the public at large and to the detriment of our heirs and
// successors. We intend this dedication to be an overt act of
// relinquishment in perpetuity of all present and future rights to this
// software under copyright law.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// Lightly optimized by Marot Satil for the GShade project.
// Special thanks to Sleeps_Hungry for the addition of the FFOccludeUI technique.

#ifndef KeepUIDebug
	#define KeepUIDebug 0 // Set to 1 if you need to use KeepUI's debug features.
#endif

#ifndef KeepUIExclude
	#define KeepUIExclude 1
#endif

#if KeepUIExclude
uniform bool bKeepUIExclude <
    ui_category = "Exclude area";
    ui_label = "Exclude";
> = true;

uniform bool bKeepUIExcludeEdit <
    ui_category = "Exclude area";
    ui_label = "Edit mode";
    ui_tooltip = "Turn off after you are done editing the exclude area.\n"
                 "You can turn on KeepUIDebug to help you edit area.\n";
> = true;

uniform float2 fKeepUIExcludeH <
    ui_type = "slider";
    ui_category = "Exclude area";
    ui_label = "Top / Bottom";
    ui_min = 0.0; ui_max = 1.0;
> = float2(0.4,0.6);

uniform float2 fKeepUIExcludeV <
    ui_type = "slider";
    ui_category = "Exclude area";
    ui_label = "Left / Right";
    ui_min = 0.0; ui_max = 1.0;
> = float2(0.4,0.6);

uniform int fKeepUIExcludeTheme <
    ui_type = "combo";
    ui_category = "Exclude area";
    ui_label = "UI Theme"; 
    ui_tooltip = "Select the UI theme you are using. This will help with occlusion assistance.";
    ui_items = "Dark\0Light\0Classic FF\0Clear Blue\0";
> = 0;
#endif

#ifndef KeepUIOccludeAssist
	#define KeepUIOccludeAssist 1
#endif

#if KeepUIOccludeAssist
uniform bool bKeepUIOcclude <
    ui_category = "Occlude UI";
    ui_label = "Occlusion Assistance";
    ui_tooltip = "Set to 1 if you notice odd graphical issues with Bloom or similar shaders. May cause problems with SSDO when enabled.";
    ui_bind = "KeepUIOccludeAssist";
> = true;
uniform float fKeepUIOccludeMinAlpha <
    ui_type = "slider";
    ui_category = "Occlude UI";
    ui_label = "Occlusion Assistance Alpha blending";
    ui_min = 0; ui_max = 1;
> = 0.8;
#endif

uniform bool bKeepUIBlurBackground <
    ui_category = "Restore UI";
    ui_label = "Blur UI background";
    ui_tooltip = "Blur the game image behind restored UI. Strength ramps from the start alpha to the end alpha.";
> = false;

uniform float fKeepUIBackgroundBlur <
    ui_type = "slider";
    ui_category = "Restore UI";
    ui_label = "Background blur";
    ui_min = 0.0; ui_max = 32.0;
> = 12.0;

uniform int iKeepUIBackgroundBlurAlgorithm <
    ui_type = "combo";
    ui_category = "Restore UI";
    ui_label = "Background blur algorithm";
    ui_tooltip = "Full-res modes sample only UI pixels. Low-res modes downsample the saved background for smoother large-radius blur.";
    ui_items = "Fast\0Balanced\0Smooth\0Downsample 1/4\0Dual Kawase 1/4\0Gaussian 1/4\0";
> = 1;

uniform bool bKeepUIBlurPreserveEffectLayer <
    ui_category = "Restore UI";
    ui_label = "Preserve effect layer";
    ui_tooltip = "Use FFKeepUIEffectX after effects that should stay sharp behind UI blur. The captured alpha is packed into a single-channel mask from 0 to 0.1 alpha.";
> = false;

uniform float fKeepUIBackgroundBlurMinAlpha <
    ui_type = "slider";
    ui_category = "Restore UI";
    ui_label = "Background blur start alpha";
    ui_tooltip = "UI alpha where background blur starts. Lower this if highly transparent UI areas are not blurred.";
    ui_min = 0.0; ui_max = 1.0;
> = 0.1;

uniform float fKeepUIBackgroundBlurMaxAlpha <
    ui_type = "slider";
    ui_category = "Restore UI";
    ui_label = "Background blur end alpha";
    ui_tooltip = "UI alpha where background blur reaches the full slider strength. If this is lower than the start alpha, the two values are swapped.";
    ui_min = 0.0; ui_max = 1.0;
> = 0.2;

#if KeepUIDebug
uniform bool bTroubleshootOpacityIssue <
    ui_category = "Troubleshooting";
    ui_label = "Enable UI Highlighting";
    ui_tooltip = "If you notice invalid colors on objects, enable FXAA in Final Fantasy XIV's Graphics Settings.\n"
                 "Open [System Configuration]\n"
                 "  -> [Graphics Settings]\n"
                 "  -> [General]\n"
                 " Set [Edge Smoothing (Anti-aliasing)] from \"Off\" to \"FXAA\"";
> = true;

uniform int iBlendSource <
    ui_category = "Troubleshooting (Do not use)";
    ui_label = "Blend Type"; ui_type = "combo";
    ui_items = "Checkerboard\0Negative\0";
> = 0;
#endif

#include "ReShade.fxh"

texture KeepUIX_Tex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
sampler KeepUIX_Sampler { Texture = KeepUIX_Tex; };
texture KeepUIX_BackgroundTex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
sampler KeepUIX_BackgroundSampler { Texture = KeepUIX_BackgroundTex; };
texture KeepUIX_EffectLayerTex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = R8; };
sampler KeepUIX_EffectLayerSampler { Texture = KeepUIX_EffectLayerTex; };
texture KeepUIX_BackgroundHalfTex { Width = BUFFER_WIDTH / 2; Height = BUFFER_HEIGHT / 2; };
sampler KeepUIX_BackgroundHalfSampler { Texture = KeepUIX_BackgroundHalfTex; MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = POINT; AddressU = CLAMP; AddressV = CLAMP; };
texture KeepUIX_BackgroundQuarterTex { Width = BUFFER_WIDTH / 4; Height = BUFFER_HEIGHT / 4; };
sampler KeepUIX_BackgroundQuarterSampler { Texture = KeepUIX_BackgroundQuarterTex; MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = POINT; AddressU = CLAMP; AddressV = CLAMP; };
texture KeepUIX_BackgroundBlurTempTex { Width = BUFFER_WIDTH / 4; Height = BUFFER_HEIGHT / 4; };
sampler KeepUIX_BackgroundBlurTempSampler { Texture = KeepUIX_BackgroundBlurTempTex; MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = POINT; AddressU = CLAMP; AddressV = CLAMP; };
texture KeepUIX_BackgroundBlurTex { Width = BUFFER_WIDTH / 4; Height = BUFFER_HEIGHT / 4; };
sampler KeepUIX_BackgroundBlurSampler { Texture = KeepUIX_BackgroundBlurTex; MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = POINT; AddressU = CLAMP; AddressV = CLAMP; };
static const float2 KeepUIX_PixelSize = float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT);
static const float2 KeepUIX_HalfPixelSize = float2(BUFFER_RCP_WIDTH * 2.0, BUFFER_RCP_HEIGHT * 2.0);
static const float2 KeepUIX_QuarterPixelSize = float2(BUFFER_RCP_WIDTH * 4.0, BUFFER_RCP_HEIGHT * 4.0);
static const float KeepUIX_OpaqueAlpha = 0.999;
static const float KeepUIX_EffectMaskEndAlpha = 0.1;
static const int KeepUIX_BlurModeDownsample = 3;
static const int KeepUIX_BlurModeDualKawase = 4;
static const int KeepUIX_BlurModeGaussian = 5;
static const float3 LightTheme = float3(247.0 / 255.0, 218.0 / 255.0, 181.0 / 255.0);
static const float3 BlueTheme = float3(37.0 / 255.0, 0.0 / 255.0, 158.0 / 255.0);

float GetKeepUIBackgroundBlurMask(float alpha)
{
    float blurStartAlpha = min(fKeepUIBackgroundBlurMinAlpha, fKeepUIBackgroundBlurMaxAlpha);
    float blurEndAlpha = max(fKeepUIBackgroundBlurMinAlpha, fKeepUIBackgroundBlurMaxAlpha);

    return saturate((alpha - blurStartAlpha) / max(blurEndAlpha - blurStartAlpha, 0.001));
}

bool KeepUIUsesLowResBlur()
{
    return bKeepUIBlurBackground && fKeepUIBackgroundBlur > 0.0 && iKeepUIBackgroundBlurAlgorithm >= KeepUIX_BlurModeDownsample;
}

void PS_KeepUIBackground(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    color = tex2D(ReShade::BackBuffer, texcoord);
}

void PS_KeepUIEffectLayer(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    if (!bKeepUIBlurPreserveEffectLayer)
    {
        color = 0.0;
        return;
    }

    color = float4(saturate(tex2D(ReShade::BackBuffer, texcoord).a), 0.0, 0.0, 1.0);
}

void PS_KeepUI(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    color = tex2D(ReShade::BackBuffer, texcoord);
}

#if KeepUIExclude
void PS_KeepUIExclude(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    if (!bKeepUIExclude) discard;

    const color = tex2D(ReShade::BackBuffer, texcoord);

    const float alphaTL = tex2D(ReShade::BackBuffer, float2(fKeepUIExcludeV.x, fKeepUIExcludeH.x)).a;
    const float alphaTR = tex2D(ReShade::BackBuffer, float2(fKeepUIExcludeV.y, fKeepUIExcludeH.x)).a;
    const float alphaBL = tex2D(ReShade::BackBuffer, float2(fKeepUIExcludeV.x, fKeepUIExcludeH.y)).a;
    const float alphaBR = tex2D(ReShade::BackBuffer, float2(fKeepUIExcludeV.y, fKeepUIExcludeH.y)).a;

    const bool isCovered = alphaTL >= 0.1 && alphaTR >= 0.1 && alphaBL >= 0.1 && alphaBR >= 0.1;

    if (!bKeepUIExcludeEdit && isCovered)
    {
        return;
    }
    else if (texcoord.y >= fKeepUIExcludeH.x && texcoord.y <= fKeepUIExcludeH.y && texcoord.x >= fKeepUIExcludeV.x && texcoord.x <= fKeepUIExcludeV.y)
    {   
        const float alpha = color.a;
        color.a = 0;

        if (bKeepUIExcludeEdit)
        {
            color.b = isCovered ? 1 : 0;
            color.g = 1;
            color.a = 0.5;
        }  
        else if ((color.r > 0.1 && color.r < 0.8 || color.r == 0 ) && abs(color.r - color.g) < 0.015 && abs(color.r - color.b) < 0.015)
            color.a = alpha;
        else if(fKeepUIExcludeTheme == 1 && abs(color.r - LightTheme.r) < 0.04 && abs(color.g - LightTheme.g) < 0.04 && abs(color.b - LightTheme.b) < 0.04)
            color.a = alpha;
        else if(fKeepUIExcludeTheme == 2 && abs(color.r - BlueTheme.r) < 0.01 && abs(color.g - BlueTheme.g) < 0.01 && abs(color.b - BlueTheme.b) < 0.01)
            color.a = alpha;
    }
}
#endif

#if KeepUIOccludeAssist
void PS_OccludeUI(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    if (!bKeepUIOcclude) discard;

    color = tex2D(ReShade::BackBuffer, texcoord);
    float4 keep = tex2D(KeepUIX_Sampler, texcoord);
    if(keep.a > 0)
    {
        color = lerp(color, keep * fKeepUIOccludeMinAlpha, keep.a);
    }
}
#endif

float4 SampleKeepUIBox4(float2 texcoord, sampler sourceSampler, float2 sourcePixelSize)
{
    float2 offset = sourcePixelSize * 0.5;
    float4 color = tex2D(sourceSampler, texcoord + float2(-offset.x, -offset.y));
    color += tex2D(sourceSampler, texcoord + float2( offset.x, -offset.y));
    color += tex2D(sourceSampler, texcoord + float2(-offset.x,  offset.y));
    color += tex2D(sourceSampler, texcoord + float2( offset.x,  offset.y));

    return color * 0.25;
}

float4 SampleKeepUIKawase4(float2 texcoord, sampler sourceSampler, float2 sourcePixelSize, float radius)
{
    float2 offset = sourcePixelSize * radius;
    float4 color = tex2D(sourceSampler, texcoord + float2( offset.x,  offset.y));
    color += tex2D(sourceSampler, texcoord + float2(-offset.x,  offset.y));
    color += tex2D(sourceSampler, texcoord + float2( offset.x, -offset.y));
    color += tex2D(sourceSampler, texcoord + float2(-offset.x, -offset.y));

    return color * 0.25;
}

float4 SampleKeepUIGaussian9(float2 texcoord, sampler sourceSampler, float2 sourcePixelSize, bool isVertical)
{
    float2 axis = isVertical ? float2(0.0, sourcePixelSize.y) : float2(sourcePixelSize.x, 0.0);
    axis *= max(fKeepUIBackgroundBlur * 0.25, 0.25);

    float4 color = tex2D(sourceSampler, texcoord) * 0.227027;
    color += tex2D(sourceSampler, texcoord + axis * 1.0) * 0.194595;
    color += tex2D(sourceSampler, texcoord - axis * 1.0) * 0.194595;
    color += tex2D(sourceSampler, texcoord + axis * 2.0) * 0.121622;
    color += tex2D(sourceSampler, texcoord - axis * 2.0) * 0.121622;
    color += tex2D(sourceSampler, texcoord + axis * 3.0) * 0.054054;
    color += tex2D(sourceSampler, texcoord - axis * 3.0) * 0.054054;
    color += tex2D(sourceSampler, texcoord + axis * 4.0) * 0.016216;
    color += tex2D(sourceSampler, texcoord - axis * 4.0) * 0.016216;

    return color;
}

void PS_KeepUIBackgroundDownsampleHalf(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    if (!KeepUIUsesLowResBlur()) discard;

    color = SampleKeepUIBox4(texcoord, KeepUIX_BackgroundSampler, KeepUIX_PixelSize);
}

void PS_KeepUIBackgroundDownsampleQuarter(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    if (!KeepUIUsesLowResBlur()) discard;

    color = SampleKeepUIBox4(texcoord, KeepUIX_BackgroundHalfSampler, KeepUIX_HalfPixelSize);
}

void PS_KeepUIBackgroundKawaseA(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    if (iKeepUIBackgroundBlurAlgorithm != KeepUIX_BlurModeDualKawase || !KeepUIUsesLowResBlur()) discard;

    color = SampleKeepUIKawase4(texcoord, KeepUIX_BackgroundQuarterSampler, KeepUIX_QuarterPixelSize, max(fKeepUIBackgroundBlur * 0.125, 0.75));
}

void PS_KeepUIBackgroundKawaseB(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    if (iKeepUIBackgroundBlurAlgorithm != KeepUIX_BlurModeDualKawase || !KeepUIUsesLowResBlur()) discard;

    color = SampleKeepUIKawase4(texcoord, KeepUIX_BackgroundBlurTempSampler, KeepUIX_QuarterPixelSize, max(fKeepUIBackgroundBlur * 0.0625, 0.5));
}

void PS_KeepUIBackgroundGaussianH(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    if (iKeepUIBackgroundBlurAlgorithm != KeepUIX_BlurModeGaussian || !KeepUIUsesLowResBlur()) discard;

    color = SampleKeepUIGaussian9(texcoord, KeepUIX_BackgroundQuarterSampler, KeepUIX_QuarterPixelSize, false);
}

void PS_KeepUIBackgroundGaussianV(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    if (iKeepUIBackgroundBlurAlgorithm != KeepUIX_BlurModeGaussian || !KeepUIUsesLowResBlur()) discard;

    color = SampleKeepUIGaussian9(texcoord, KeepUIX_BackgroundBlurTempSampler, KeepUIX_QuarterPixelSize, true);
}

float4 SampleKeepUIBackgroundOffset(float2 texcoord, float2 pixelOffset, float2 offset)
{
    return tex2D(KeepUIX_BackgroundSampler, texcoord + pixelOffset * offset);
}

float4 SampleKeepUIBackgroundBlurFast(float2 texcoord, float radius)
{
    float2 pixelOffset = KeepUIX_PixelSize * radius;
    float4 blur = tex2D(KeepUIX_BackgroundSampler, texcoord) * 0.28;

    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.90,  0.00)) * 0.18;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.90,  0.00)) * 0.18;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.00,  0.90)) * 0.18;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.00, -0.90)) * 0.18;

    return blur;
}

float4 SampleKeepUIBackgroundBlurBalanced(float2 texcoord, float radius)
{
    float2 pixelOffset = KeepUIX_PixelSize * radius;
    float4 blur = tex2D(KeepUIX_BackgroundSampler, texcoord) * 0.16;

    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.55,  0.00)) * 0.06;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.55,  0.00)) * 0.06;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.00,  0.55)) * 0.06;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.00, -0.55)) * 0.06;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.39,  0.39)) * 0.06;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.39,  0.39)) * 0.06;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.39, -0.39)) * 0.06;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.39, -0.39)) * 0.06;

    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 1.06,  0.44)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.44,  1.06)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.44,  1.06)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-1.06,  0.44)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-1.06, -0.44)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.44, -1.06)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.44, -1.06)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 1.06, -0.44)) * 0.045;

    return blur;
}

float4 SampleKeepUIBackgroundBlurSmooth(float2 texcoord, float radius)
{
    float2 pixelOffset = KeepUIX_PixelSize * radius;
    float4 blur = tex2D(KeepUIX_BackgroundSampler, texcoord) * 0.10;

    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.42,  0.00)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.42,  0.00)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.00,  0.42)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.00, -0.42)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.30,  0.30)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.30,  0.30)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.30, -0.30)) * 0.045;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.30, -0.30)) * 0.045;

    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.33,  0.78)) * 0.035;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.33,  0.78)) * 0.035;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.78,  0.33)) * 0.035;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.78, -0.33)) * 0.035;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.33, -0.78)) * 0.035;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.33, -0.78)) * 0.035;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.78, -0.33)) * 0.035;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.78,  0.33)) * 0.035;

    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.26,  1.32)) * 0.0325;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.75,  1.12)) * 0.0325;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-1.32,  0.26)) * 0.0325;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-1.12, -0.75)) * 0.0325;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2(-0.26, -1.32)) * 0.0325;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 0.75, -1.12)) * 0.0325;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 1.32, -0.26)) * 0.0325;
    blur += SampleKeepUIBackgroundOffset(texcoord, pixelOffset, float2( 1.12,  0.75)) * 0.0325;

    return blur;
}

float4 SampleKeepUIBackgroundBlur(float2 texcoord, float radius)
{
    if (iKeepUIBackgroundBlurAlgorithm <= 0)
        return SampleKeepUIBackgroundBlurFast(texcoord, radius);
    else if (iKeepUIBackgroundBlurAlgorithm == 1)
        return SampleKeepUIBackgroundBlurBalanced(texcoord, radius);
    else if (iKeepUIBackgroundBlurAlgorithm == 2)
        return SampleKeepUIBackgroundBlurSmooth(texcoord, radius);
    else if (iKeepUIBackgroundBlurAlgorithm == KeepUIX_BlurModeDownsample)
        return tex2D(KeepUIX_BackgroundQuarterSampler, texcoord);

    return tex2D(KeepUIX_BackgroundBlurSampler, texcoord);
}

float GetKeepUIEffectMask(float2 texcoord)
{
    if (!bKeepUIBlurPreserveEffectLayer)
        return 0.0;

    return saturate(tex2D(KeepUIX_EffectLayerSampler, texcoord).r / KeepUIX_EffectMaskEndAlpha);
}

float GetKeepUIEffectiveBackgroundBlurMask(float alpha, float2 texcoord)
{
    return GetKeepUIBackgroundBlurMask(alpha) * (1.0 - GetKeepUIEffectMask(texcoord));
}

void PS_BlurUIBackground(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    if (!bKeepUIBlurBackground || fKeepUIBackgroundBlur <= 0.0) discard;

    float4 keep = tex2D(KeepUIX_Sampler, texcoord);
    if (keep.a >= KeepUIX_OpaqueAlpha) discard;

    float blurMask = GetKeepUIEffectiveBackgroundBlurMask(keep.a, texcoord);
    if (blurMask <= 0.0) discard;

    color = tex2D(ReShade::BackBuffer, texcoord);
    float3 savedBackground = tex2D(KeepUIX_BackgroundSampler, texcoord).rgb;
    float3 blurredBackground = SampleKeepUIBackgroundBlur(texcoord, fKeepUIBackgroundBlur * blurMask).rgb;
    color.rgb = lerp(savedBackground, blurredBackground, blurMask);
}

void PS_RestoreUI(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
    const float4 keep = tex2D(KeepUIX_Sampler, texcoord);

#if KeepUIDebug
    if (bTroubleshootOpacityIssue)
    {
        if (0 == iBlendSource)
        {
            if (step(1, pos.x / 32 % 2) == step(1, pos.y / 32 % 2))
                color = lerp(0.45, keep, keep.a);
            else
                color = lerp(0.55, keep, keep.a);
            color.a *= keep.a;
        }
        else
        {
            if (step(1.19209e-07, keep.a))
                color = lerp(1 - keep, keep, 1-keep.a);
            else
                color = lerp(keep, keep, 1 - keep.a);
            color.a = keep.a;
        }

        return;
    }
#endif

    if (keep.a >= KeepUIX_OpaqueAlpha)
    {
        color = tex2D(ReShade::BackBuffer, texcoord);
        color.rgb = keep.rgb;
        return;
    }

    if (bKeepUIBlurBackground && fKeepUIBackgroundBlur > 0.0)
    {
        float blurMask = GetKeepUIEffectiveBackgroundBlurMask(keep.a, texcoord);
        if (blurMask > 0.0)
        {
            color = tex2D(ReShade::BackBuffer, texcoord);
            float3 savedBackground = tex2D(KeepUIX_BackgroundSampler, texcoord).rgb;
            color.rgb = keep.rgb + (color.rgb - savedBackground) * (1.0 - keep.a);
            return;
        }
    }

    color = tex2D(ReShade::BackBuffer, texcoord);
    color.rgb = lerp(color.rgb, keep.rgb, keep.a).rgb;
}

technique FFKeepUIBackgroundX <
    ui_label = "==  [ FFXIV Keep UI ]  BACKGROUND ==================================";
    ui_tooltip = "Place this before the UI is rendered to save the original image without UI for FFKeepUIX background blur.\n";
>
{
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_KeepUIBackground;
        RenderTarget = KeepUIX_BackgroundTex;
    }
}

technique FFKeepUIEffectX <
    ui_label = "==  [ FFXIV Keep UI ]  EFFECT LAYER ==============================";
    ui_tooltip = "Place this after effects that should stay sharp behind UI blur and before UI is rendered. It saves the current alpha into an R8 blur protection mask; 0.1 alpha and above fully disables blur.\n";
>
{
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_KeepUIEffectLayer;
        RenderTarget = KeepUIX_EffectLayerTex;
    }
}

technique FFKeepUIX <
    ui_label = "==  [ FFXIV Keep UI ]  KEEP =========================================";
    ui_tooltip = "Place this at the top of your Technique list to save the UI into a texture for restoration with FFRestoreUI.\n"
                 "To use this Technique, you must also enable \"FFRestoreUI\".\n";
>
{
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_KeepUI;
        RenderTarget = KeepUIX_Tex;
    }

    #if KeepUIExclude
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_KeepUIExclude;
        RenderTarget = KeepUIX_Tex;
    }
    #endif
    
    #if KeepUIOccludeAssist
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_OccludeUI;
    }
    #endif

    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_KeepUIBackgroundDownsampleHalf;
        RenderTarget = KeepUIX_BackgroundHalfTex;
    }

    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_KeepUIBackgroundDownsampleQuarter;
        RenderTarget = KeepUIX_BackgroundQuarterTex;
    }

    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_KeepUIBackgroundKawaseA;
        RenderTarget = KeepUIX_BackgroundBlurTempTex;
    }

    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_KeepUIBackgroundKawaseB;
        RenderTarget = KeepUIX_BackgroundBlurTex;
    }

    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_KeepUIBackgroundGaussianH;
        RenderTarget = KeepUIX_BackgroundBlurTempTex;
    }

    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_KeepUIBackgroundGaussianV;
        RenderTarget = KeepUIX_BackgroundBlurTex;
    }

    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_BlurUIBackground;
    }
}

technique FFRestoreUIX <
    ui_label = "==  [ FFXIV Keep UI ]  RESTORE ======================================";
    ui_tooltip = "Place this at the bottom of your Technique list to restore the UI texture saved by FFKeepUI.\n"
                 "To use this Technique, you must also enable \"FFKeepUIX\".\n";
>
{
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_RestoreUI;
    }
}
