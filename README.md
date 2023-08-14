# FFXIV Enhanced Game Play

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/1600a1f7-3f93-4f99-9a23-f980539e96ec)

一个相对温和的用于《最终幻想XIV》的ReShade预设，适合绝大多数日常游玩场景，包含了一些改进过的 Shaders。

与大多数用于摄影的预设的目的不同，这个预设的目的是为了优化日常游玩体验，将泛用性放在第一位，它几乎适用于任何游玩场景，接近于画面原始意图，并且不会造成视觉上的困扰（太亮/太黑/太鲜艳）。通过一些相对的克制改动来解决一些游戏常常被诟病的问题，并增加一些质感，并提供针对剧情和轻量拍摄提供了一些快捷预设。

> 本文档中所有图片均为该预设下的截图，无任何其它额外调整

## 这个预设解决了什么问题？

因为游戏本身的限制，没有任何预设可以面面俱到，而这个预设主要是针对以下几个问题进行了改进：

1. FFXIV 没有对高亮度的饱和度进行限制，所以会出现很多又亮又艳的颜色，比如标志性的水晶蓝色。这与常见的曝光表现不符，也是造成各种死亡打光的元凶之一。这个预设对高亮度的饱和度进行了限制，使得高亮度的颜色更加自然，同时还解决了各种荧光棒武器坐骑和画面格格不入的问题。

2. FFXIV 的整体画面偏黄绿，这是很多人都感觉“偏暖”的原因，尤其一些室内光会因为这种调色显得有些不真实和塑料感。这个预设对整体的颜色进行了微调，让整体颜色更偏中性。

3. FFXIV 缺乏 GI，这个预设使用了一个非常高效的 GI Shader，可以让物体轻微的染上环境的色调使整体观感更加一致，可以有效缓解一些场景中人物和物体像是P上去的感觉。例如沙滩上的物体会略微偏向沙子黄色的色调，草地上的物体会有一些绿色的色调，室内会根据环境呈现略微偏暖或偏冷的色调。

4. FFXIV 的 AO 表现比较的微妙，强弱两档比较生硬，HBAO的半径又过大，没有细节表现。这个预设添加了一些额外的AO，让人物和环境更具有立体感，表现更真实。

5. 使用了改进过的 FFKeepUI，可以解决部分职业量普遮罩的问题，并不会引入 REST 的解决方案的各种问题。

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/2ee27864-05fc-417d-bb8f-f1ee060f5964)

除了上述改进，还进行了一些额外的调整使画面有些许“电影感”：

1. 略微压缩了黑白场，使得白色不会过亮（比如正午的海都地板，过场动画等），黑色对比度不会过高，中等亮度区域的整体对比度有所提升。

2. 轻微调整了红色与蓝色的平衡，类似常见影视作品，使得日出、黄昏等的偏场景更偏暖色，并使暗处、夜间略微偏向冷色调，从而增加些许氛围感。

3. 为过场剧情和轻度拍摄提供了自动和手动两个快捷的 DOF 预设，可以在不同场景下快速切换景深开关。

> 该预设是在校色过的sRGB色域的显示器上建立和调整的，这也是用于游戏本身制作与渲染的色域。根据显示设备的不同可能会出现一些不同的结果，但整体趋向应该是相同的。

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/c1f88868-d77a-401d-a2d0-93f7ebbcf369)

## 使用方法

### 安装

该预设基于原版 ReShade，单独提供了一些 ReShade 没有包含和来自或改进于 GShade 的 Shaders。 

1. 安装原版 ReShade，为简单起见你需要在安装时选择下载所有 ReShade 安装包提供的 Shader。当然你也可以使用 [ReShade-CN2 整合包](https://github.com/liuxd17thu/reshade/)

2. 将本预设中的文件复制到游戏目录下，合并 / 覆盖对应目录，一般情况下是 `reshade-shaders` 和 `reshade-presets` 两个目录。因为整合包里的一些 Shader 版本比较旧，所以需要覆盖。

3. 开启游戏，在 ReShade 的设置页中将`.\reshade-shaders\Shaders\Custom`加入Effect路径，如果你设置了`\reshade-shaders\Shaders\**`这种递归搜索路径，可以忽略这一步
   <br>![snipaste_20230815_133834](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/de16b0e0-8e45-40c7-a41e-997a206a1f78)

5. 在 ReShade 的设置页中将 `Load only enabled effects` 关闭，否则将无法在性能模式下快速切换功能，同时建议开启底下的 `Group effect files with tabs instead of a tree`，这样在调整效果时就不会所有东西都混在一起了。
   <br>![snipaste_20230815_133915](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/8b12d9f6-df09-446b-9579-50dee515c37e)
   <br>![snipaste_20230815_133944](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/b4a72dbb-d777-4224-8617-2da1158418fc)

7. 游戏画面设置：
   * `FXAA`：开启。用于解决UI遮罩的问题，由 ReShade 来提供锐化
   * `临边昏暗`：关闭。由 ReShade 在更恰当的时候插入
   * `辉光`：建议开启。所有的后期辉光类效果都无法准确区分游戏中真正发光的部分。对于注重日常游玩和泛用性来的预设来说，自带辉光是最自然舒适的。
   * `水下扭曲`：根据需要调整，水下扭曲主要会影响基于深度的 Shader 而造成伪影，但实际游玩中并不一定会非常明显
   * 其它设置根据电脑配置调整

8. 在 ReShade 的主页面中选择 `Enhanced_XIV_GamePlay` 作为预设，预设分为 `Max`，`Balance` 和 `Lite` 三种，分别对应不同的性能开销，具体见下文。

9. 如果你需要处理诗人、占星和武僧的职业量普遮罩问题，请参考下文的 FFKeepUIX 部分的使用方法。
   
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/0a4b95af-428d-4246-860d-d071ea176e88)

### 预置快捷键

可以按实际需求右键调整

1. <kbd>F10</kbd>：开关手动 DOF，用于偶尔拍摄，会根据鼠标位置自动调整焦点
2. <kbd>F11</kbd>：开关自动 DOF，用于为过场剧情提供自动景深
3. <kbd>Shift</kbd> + <kbd>F10</kbd>：开关 21:9 的黑边，不会遮挡 UI
4. <kbd>Shift</kbd> + <kbd>F11</kbd>：开关锐化和 AO 之外的所有效果
   
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/27217a63-9d1d-42cb-9c38-6884ff84cb87)

## 配置对比

考虑不同配置，提供了三种性能开销不同的预设，它们的主要区别在于 AO 和锐化的使用。

### Enhanced_XIV_GamePlay_0_Max：最高预设

* 使用 CAS 锐化
* 使用 MAXO 提供近距离，精细的 AO
* 使用 SSDO 提供中等距离的广泛的 AO

### Enhanced_XIV_GamePlay_1_Balance：平衡预设

性能开销为 Max 的 70% 左右

* 使用 Glamayre_Fast_Effects 锐化
* 使用 SSDO 所有 AO

### Enhanced_XIV_GamePlay_2_Lite：轻量预设

性能开销为 Max 的 45% 左右

* 使用 Glamayre_Fast_Effects 锐化
* 使用 Glamayre_Fast_Effects 提供 AO，效果不如上面的精细（不凑近看也还行嘛！）
* 不使用 AnamorphicFlare

## 改进过的Shaders

这个预设包含了一些改进过的Shaders，它们或多或少解决了一些原版Shader存在的问题，或者扩展了一些功能。

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
* 优化遮罩功能，原版的遮罩并不正常工作，这个 Shader 修复了这个问题，可以略微降低UI的亮度，减少对后续 Shader 的影响

> FFKeepUI 用于还原被滤镜处理过的 UI 元素以避免界面出现奇怪的阴影和颜色，原版的 FFKeepUI 在 ReShade 下存在部分职业量普不正常的问题，虽然现在有 REST 的解决方案，但它会导致切换功能异常，并无法监测性能开销，无法同时生成原始和处理后的截图，泛用性不佳。这个Shader针对大多数人的使用习惯增加了一个排除指定区域的功能，使得职业量表区可以和背景被一起调整，从而避免奇怪的边框问题，并对不同游戏UI主题进行了适配以缓解排除区域被其它 UI 遮挡时出现的问题。



![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/546f3e52-cd9b-4ecf-be8a-2459172e3f7e)

### ClipboardX

* 增加天空区域单独处理

> Clipboard 可以按比例混合原始画面和处理后的画面，从而达到减淡的效果。FFXIV 的一些地区和天气下的天空比较有特色，对于高饱和度的限制会影响一些天空的视觉表现。这个Shader在原版的基础上增加了对天空区域的单独处理，使得天空可以更接近原始的色调。

### PPFX_SSDO_X

* 增加了近距离淡出的选项。可以配合其它 AO Shader 针对不同距离使用。对于本预设，主要用于在最高配制下与 MXAO 搭配，MAXO 提供近距离，精细的AO，SSDO 提供中等距离的广泛的AO。

* 增加了高光减益，原版的 SSDO 没有对计算原始像素亮度，这会导致一些发光/高亮区域被错误的增加阴影。

### AnamorphicFlare

基于 BloomAndLensFlares 简化而来，提供电影中常见的横向光晕效果，为黑暗场景中的高光提供一些电影化的效果。这类效果其实在游戏中各过场动画。技能特效中被广泛应用。

## Effect 顺序以及作用说明

![snipaste_20230816_014623](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/846afbb7-3b83-4ff9-a804-c761e1b8b117)

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
<br>一个一些电影化效果的集合，本预设中主要用于调整红色和蓝色的平衡来的添加些许风格化效果

### 4. 遮罩，包括临边昏暗与黑边

## 一些对比

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/cc7ba18f-5f1e-438f-a22f-fbbdcde836fd)
▲ Before / After : 缓解特定关照下脸部奇怪的过渡色，高光部分的颜色更加自然。头发与衣服的 AO 增加了立体感。

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/a98b016e-e0fd-4ada-9360-1f8d7e6980f1)
▲ Before / After : 改善了室内灯光的奇怪的过于偏黄的色调。脸部的阴影表现更加真实。

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/0d5104b7-6fee-4668-8de5-dfb04ac6c175)
▲ Before / After : 动画城的光照有种微妙的上世代游戏的廉价感，调整后整体色调更和谐，同时保留了整体画面倾向。<del>优化了导随体验。</del>

## 一些随手拍

得益于 FFXIV 本身相对优秀的美术和场景设计，很多日常游玩经过的地方都具备一定的观赏性。虽然本预设不用于拍照，但些许电影化的处理对整体观感还是有帮助的。

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/d266395f-c743-4a67-b963-baaee474e768)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/ffa40337-eefd-47e6-9cf7-5e37e67c7be4)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/84af7237-fc73-4a2b-8b2c-e0bef180007d)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/05ff4c21-c3d4-4b7e-986d-c7e0712a684f)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/14fa666a-77b6-4190-b8bb-e8e55e59ca8d)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/6e741548-7b66-4f48-98e7-7653aac1c254)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/c32d80c3-8803-4569-9787-c1faf1d52a76)
![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/2856ce37-38c2-4c69-98c7-34a5e3c0d2c5)


