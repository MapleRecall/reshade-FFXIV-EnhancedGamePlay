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
static const float3 LightTheme = float3(247.0 / 255.0, 218.0 / 255.0, 181.0 / 255.0);
static const float3 BlueTheme = float3(37.0 / 255.0, 0.0 / 255.0, 158.0 / 255.0);

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

    color = tex2D(ReShade::BackBuffer, texcoord);
    color.rgb = lerp(color.rgb, keep.rgb, keep.a).rgb;
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
