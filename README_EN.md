# FFXIV Enhanced Game Play

| [中文](README.md) | **English** |

> Translated by copilot, may contain errors

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/1600a1f7-3f93-4f99-9a23-f980539e96ec)

A relatively mild ReShade preset for Final Fantasy XIV, suitable for most daily gameplay scenarios, including some improved shaders.

Unlike most presets designed for photography, this preset aims to optimize the daily gameplay experience, prioritizing versatility. It is suitable for almost any gameplay scenario, close to the original visual intent, and does not cause visual discomfort (too bright/too dark/too vivid). This preset addresses some commonly criticized issues in the game through relatively restrained modifications and adds some texture, while also providing some quick presets for cutscenes and light photography.

> All images in this document are screenshots taken with this preset, without any additional adjustments.

## Update for Dawntrail

The lighting in Dawntrail has seen significant improvements, alleviating some of the previous issues with over-saturation and harsh lighting. Therefore, the overall changes involve reducing the intensity of some color-related effects, without changing the overall style. Additionally, the AO and GI shaders have been updated.

* Both Max and Balance now use the more efficient and accurate [MartysMods_MXAO](https://github.com/martymcmodding/iMMERSE/blob/main/Shaders/MartysMods_MXAO.fx), making their effects very similar. Lite continues to use the fast AO from [Glamayre_Fast_Effects](https://github.com/rj200/Glamarye_Fast_Effects_for_ReShade/blob/main/Shaders/Glamayre_Fast_Effects.fx).
* Max has added [RadiantGI](https://github.com/BlueSkyDefender/AstrayFX/commits/master/Shaders/RadiantGI.fx) as a GI supplement, which may not have very noticeable effects in most places but is very resource-intensive, recommended for use in environments where frame rate is not a concern.
* Considering the new DLSS and FSR in 7.0, CAS sharpening is now used uniformly, with a slight increase in sharpening intensity.

Additionally, the UI masking solution in REST no longer has switch issues, so using FFKeepUIX is no longer necessary by default.

For REST, you can manually install [REST](https://github.com/4lex4nder/ReshadeEffectShaderToggler) or use the [ReShade-CN2 integration package](https://github.com/liuxd17thu/reshade/).

Using the REST solution can also solve the issue of AO covering semi-transparent objects (such as glasses, hair tips, etc.). If needed, you can use [ReshadeEffectShaderToggler.ini](reshade-addons/ReshadeEffectShaderToggler.ini) to overwrite the REST configuration file.

## What issues does this preset solve?

Due to the limitations of the game itself, no preset can cover everything, but this preset mainly addresses the following issues:

1. FFXIV does not limit the saturation of high brightness, resulting in many bright and vivid colors, such as the iconic crystal blue. This does not match common exposure performance and is one of the main causes of various harsh lighting effects. This preset limits the saturation of high brightness, making high brightness colors more natural, and also solves the issue of fluorescent weapons and mounts clashing with the overall picture.

2. FFXIV's overall picture tends to be yellow-green, which is why many people feel it is "warm," especially some indoor lighting that appears somewhat unrealistic and plastic-like due to this color grading. This preset slightly adjusts the overall color to make it more neutral.

3. FFXIV lacks GI, and this preset uses a very efficient GI shader that allows objects to slightly take on the color of their environment, making the overall visual experience more consistent. This can effectively alleviate the feeling that characters and objects are pasted into the scene. For example, objects on the beach will have a slight yellow tint from the sand, objects on the grass will have a slight green tint, and indoor environments will have a slightly warm or cool tint depending on the environment.

4. FFXIV's AO performance is quite subtle, with strong and weak settings being rather rigid, and the HBAO radius being too large, lacking detailed performance. This preset adds some extra AO, making characters and environments more three-dimensional and realistic.

5. <del>Using an improved FFKeepUI can solve some job gauge masking issues without introducing the various problems of the REST solution.</del>

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/2ee27864-05fc-417d-bb8f-f1ee060f5964)

In addition to the above improvements, some additional adjustments have been made to give the picture a slight "cinematic feel":

1. Slightly compressed the black and white levels, so that white is not too bright (e.g., the floor of Limsa Lominsa at noon, cutscenes, etc.), and black contrast is not too high, with overall contrast in the mid-brightness range slightly increased.

2. Slightly adjusted the balance of red and blue, similar to common film works, making sunrise, sunset, and other scenes warmer, and making dark and nighttime scenes slightly cooler, adding a bit of atmosphere.

3. Provided automatic and manual quick DOF presets for cutscenes and light photography, allowing quick switching of depth of field in different scenes.

> This preset was created and adjusted on a calibrated sRGB display, which is also the color space used for the game's production and rendering. Different display devices may produce slightly different results, but the overall tendency should be the same.

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/c1f88868-d77a-401d-a2d0-93f7ebbcf369)

## Preset Details

This preset uses some custom shaders, combined in a specific order and rules. If you are interested in these details, you can refer to [this document](Shaders&Effects.md).

## Usage

### Installation

This preset is based on the original ReShade and provides some shaders not included in ReShade or improved from GShade.

1. Install the original ReShade. For simplicity, you need to select to download all shaders provided by the ReShade installation package during installation. You can also use the [ReShade-CN2 integration package](https://github.com/liuxd17thu/reshade/).

2. Copy the files from this preset to the game directory, merging/overwriting the corresponding directories, usually `reshade-shaders` and `reshade-presets`. Since some shader versions in the integration package are relatively old, they need to be overwritten.

3. In the ReShade settings page, add `.\reshade-shaders\Shaders\Custom` to the Effect path. If you have set `\reshade-shaders\Shaders\**` for recursive search, you can skip this step.
   <br>![snipaste_20230815_133834](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/de16b0e0-8e45-40c7-a41e-997a206a1f78)

5. In the ReShade settings page, turn off `Load only enabled effects`, otherwise, you will not be able to quickly switch functions in performance mode. It is also recommended to enable `Group effect files with tabs instead of a tree` below, so that all effects are not mixed together when adjusting.
   <br>![snipaste_20230815_133915](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/8b12d9f6-df09-446b-9579-50dee515c37e)
   <br>![snipaste_20230815_133944](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/b4a72dbb-d777-4224-8617-2da1158418fc)

7. Game graphics settings:
   * `FXAA`: On. Used to solve UI masking issues, with sharpening provided by ReShade.
   * `Ambient Occlusion`: Off. Inserted more appropriately by ReShade.
   * `Glare`: Recommended to be on. All post-processing glare effects cannot accurately distinguish the truly glowing parts of the game. For presets focusing on daily gameplay and versatility, the built-in glare is the most natural and comfortable.
   * `Underwater Distortion`: Adjust as needed. Underwater distortion mainly affects depth-based shaders, causing artifacts, but may not be very noticeable during actual gameplay.
   * Other settings adjusted according to computer configuration.

8. In the ReShade main page, select `Enhanced_XIV_GamePlay` as the preset. The preset is divided into `Max`, `Balance`, and `Lite`, corresponding to different performance costs, as detailed below.

9. <del>If you need to address job gauge masking issues for Bard, Astrologian, and Monk, please refer to the usage method of the FFKeepUIX section in [this document](Shaders&Effects.md).</del>

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/0a4b95af-428d-4246-860d-d071ea176e88)

### Preset Hotkeys

Can be adjusted as needed by right-clicking.

1. <kbd>F10</kbd>: Toggle manual DOF, used for occasional photography, automatically adjusting focus based on mouse position.
2. <kbd>F11</kbd>: Toggle automatic DOF, providing automatic depth of field for cutscenes.
3. <kbd>Shift</kbd> + <kbd>F10</kbd>: Toggle 21:9 black bars, without covering the UI.
4. <kbd>Shift</kbd> + <kbd>F11</kbd>: Toggle all effects except sharpening and AO.

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/27217a63-9d1d-42cb-9c38-6884ff84cb87)

## Configuration Comparison

To accommodate different configurations, three presets with different performance costs are provided, mainly differing in the use of AO and sharpening.

### Enhanced_XIV_GamePlay_0_Max: Highest Preset

* Uses MartysMods_MXAO for high-quality AO.
* Uses Glamayre_Fast_Effects for rough GI.
* Uses RadiantGI for some fine GI (high performance cost).

### Enhanced_XIV_GamePlay_1_Balance: Balanced Preset [Recommended]

Performance cost is about 60% of Max.

* Uses MartysMods_MXAO for high-quality AO.
* Uses Glamayre_Fast_Effects for rough GI.

### Enhanced_XIV_GamePlay_2_Lite: Lightweight Preset

Performance cost is about 35% of Max.

* Uses Glamayre_Fast_Effects for AO, less detailed than the above (still acceptable if not viewed closely!).
* Uses Glamayre_Fast_Effects for rough GI.
* Does not use AnamorphicFlare for lens flare effects.

## Some Comparisons

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/cc7ba18f-5f1e-438f-a22f-fbbdcde836fd)
▲ Before / After: Alleviates the strange transition colors on the face under specific lighting, making the colors in the highlights more natural. The AO on the hair and clothes adds a three-dimensional effect.

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/a98b016e-e0fd-4ada-9360-1f8d7e6980f1)
▲ Before / After: Improves the strange overly yellow tint of indoor lighting. The shadow performance on the face is more realistic.

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/0d5104b7-6fee-4668-8de5-dfb04ac6c175)
▲ Before / After: The lighting in Ul'dah has a subtle last-gen game cheapness. After adjustment, the overall color tone is more harmonious while retaining the overall visual tendency.

## Some Casual Shots

Thanks to FFXIV's relatively excellent art and scene design, many places you pass by during daily gameplay are quite scenic. Although this preset is not intended for photography, some cinematic processing still helps the overall visual experience.

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/d266395f-c743-4a67-b963-baaee474e768)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/ffa40337-eefd-47e6-9cf7-5e37e67c7be4)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/84af7237-fc73-4a2b-8b2c-e0bef180007d)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/05ff4c21-c3d4-4b7e-986d-c7e0712a684f)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/14fa666a-77b6-4190-b8bb-e8e55e59ca8d)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/6e741548-7b66-4f48-98e7-7653aac1c254)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/c32d80c3-8803-4569-9787-c1faf1d52a76)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/2856ce37-38c2-4c69-98c7-34a5e3c0d2c5)
