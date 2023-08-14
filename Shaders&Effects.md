# Shaders & Effects

这个文档包含了一些 Shaders 说明和以及本预设的整体思路与结构

## 改进过的 Shaders

这些 Shaders 或多或少解决了一些原版存在的问题，或者扩展了一些功能。

### FFKeepUIX

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/ee808df4-62cc-4450-af5b-930fcc8dddf2)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/93c79b4e-4c84-4bc0-b448-be7c61f1c3e7)

* 增加排除指定区域的功能，使用方法：
  * 关闭性能模式来开启编辑功能
  * 在编辑模式下将绿框覆盖诗人、占星和武僧的量普
  * 选择你所使用的 UI 主题
  * 重新打开性能模式
> 如果你同时玩占星，诗人，武僧，并且量普位置还完全不一样，那就没办法了
<br>如果你不玩这三个职业，关闭这个功能可以十分略微地提升性能
<br>如果你完全不在意 UI 被一起处理，可以直接关闭这个 shader 对应的两个 effects

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/546f3e52-cd9b-4ecf-be8a-2459172e3f7e)

* 优化遮罩功能，原版的遮罩并不正常工作，这个 Shader 修复了这个问题，可以略微降低UI的亮度，减少对后续 Shader 的影响

> FFKeepUI 用于还原被滤镜处理过的 UI 元素以避免界面出现奇怪的阴影和颜色，原版的 FFKeepUI 在 ReShade 下存在部分职业量普不正常的问题，虽然现在有 REST 的解决方案，但它会导致切换功能异常，并无法监测性能开销，无法同时生成原始和处理后的截图，泛用性不佳。这个Shader针对大多数人的使用习惯增加了一个排除指定区域的功能，使得职业量表区可以和背景被一起调整，从而避免奇怪的边框问题，并对不同游戏UI主题进行了适配以缓解排除区域被其它 UI 遮挡时出现的问题。

### ClipboardX

* 增加天空区域单独处理

> Clipboard 可以按比例混合原始画面和处理后的画面，从而达到减淡的效果。FFXIV 的一些地区和天气下的天空比较有特色，对于高饱和度的限制会影响一些天空的视觉表现。这个Shader在原版的基础上增加了对天空区域的单独处理，使得天空可以更接近原始的色调。

### PPFX_SSDO_X

* 增加了近距离淡出的选项。可以配合其它 AO Shader 针对不同距离使用。对于本预设，主要用于在最高配制下与 MXAO 搭配，MAXO 提供近距离，精细的AO，SSDO 提供中等距离的广泛的AO。

* 增加了高光减益，原版的 SSDO 没有对计算原始像素亮度，这会导致一些发光/高亮区域被错误的增加阴影。

### AnamorphicFlare

基于 BloomAndLensFlares 简化而来，提供电影中常见的横向光晕效果，为黑暗场景中的高光提供一些电影化的效果。

## Effect 顺序以及作用说明

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/846afbb7-3b83-4ff9-a804-c761e1b8b117)

如上图所示，除了首尾的 KeepUI，本预设按照一定的顺序排列了 effects 来确保效果被正确应用，这些 effects 按顺序大致分为4组：

### 1. 前期处理，包含锐化、AO 以及 GI

> 这些效果从定义上来说属于“原始画面”或者“世界”本身应该存在或者增强的内容，所以它们应该应用在任何摄影与调色之前
 
1. CAS
<br>一个快速高效的抗锯齿方案算法，结果自然
 
2. PPFX SSDO X
<br>一个相比 MXAO 开销稍低的 AO 效果，用于提供相对广泛的阴影

3. MXAO
<br>一个高质量的 AO 效果，可以提供精细的阴影，但开销较高，只在最高预设中使用

4. Glamayre Fast Effect
<br>一个超级高效的效果合集，包含 FXAA、锐化、快速 AO、快速 GI 等功能，低配福音，本预设主要使用它来提供 GI， 以及在平衡和轻量预设预设中提供锐化与 AO
   
### 2. 摄影处理，用于模拟景深

1. ADOF
<br>用于过场动画中的自动景深，效果相对自然

3. CinematicDOF
<br>用于偶尔拍摄特写或者移轴效果的的手动景深，根据鼠标位置对焦，有良好的前景虚化效果，但是效果相对激进

### 3. 后期处理，用于调色与增加特效

1. Clipboard X
<br>用于混合调色前后的图像以达到减淡的目的

2. BloomingHDR
<br>提供 ACES 色调映射和 HDR 风格化处理
<br>感兴趣的话可以参考[这篇来自 UE 的文档](https://docs.unrealengine.com/4.26/en-US/RenderingAndGraphics/PostProcessEffects/ColorGrading/)来了解这个色调映射方案，从而理解它是怎么解决 FFXIV 在的高光过饱和的问题

3. EyeAdaption
<br>提供亮度自适应，在色调映射和 HDR 风格化处理后画面整体对比度会有所提高，但这会降低一些黑暗场景的可见度。这个效果会稍微增加这些场景的亮度来确保游玩体验。

4. Vegnette2
<br>一个复制的临边昏暗效果，用于一些可无的调整

5. Anamorphic Flare
<br>为黑暗场景中的高光提供一些提供电影中常见的横向光晕效果。这类效果其实在游戏中各过场动画、技能特效中被广泛应用。

6. PandaFX
<br>一些电影化效果的集合，本预设中主要用于调整红色和蓝色的平衡来的添加些许风格化效果

### 4. 遮罩，包括临边昏暗与模拟 21:9 的黑边
