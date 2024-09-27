# FFXIV Enhanced Game Play

| **中文** | [English](README_EN.md) |

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/1600a1f7-3f93-4f99-9a23-f980539e96ec)

一个相对温和的用于《最终幻想XIV》的ReShade预设，适合绝大多数日常游玩场景，包含了一些改进过的 Shaders。

与大多数用于摄影的预设的目的不同，这个预设的目的是优化日常游玩体验，所以将泛用性放在第一位，它几乎适用于任何游玩场景，接近于画面原始意图，并且不会造成视觉上的困扰（太亮/太黑/太鲜艳）。
本预设通过一些相对的克制改动来解决一些游戏常常被诟病的问题，并增加一些质感，同时针对剧情和轻量拍摄提供了一些快捷预设。

> 本文档中所有图片均为该预设下的截图，无任何其它额外调整

## 针对7.0的更新

7.0的光照有了不小的改进，相比以往高光过饱与死亡打光缓解了一些，所以整体改动为降低一些颜色相关效果的强度，整体风格并没有什么变化。
另外还更新了 AO 和 GI 的 Shader。

* 现在 Max 和 Balance 都使用更高效准确的 [MartysMods_MXAO](https://github.com/martymcmodding/iMMERSE/blob/main/Shaders/MartysMods_MXAO.fx)，现在两者效果非常接近了。而 Lite 则继续使用 [Glamayre_Fast_Effects](https://github.com/rj200/Glamarye_Fast_Effects_for_ReShade/blob/main/Shaders/Glamayre_Fast_Effects.fx) 的快速 AO。
* Max 新增了 [RadiantGI](https://github.com/BlueSkyDefender/AstrayFX/commits/master/Shaders/RadiantGI.fx) 作为 GI 补充，大部分地方并不会有非常明显的效果，但是开销非常大，建议在帧率不敏感的环境下使用。
* 考虑到 7.0 新增的 DLSS 和 FSR，现在统一使用 CAS 锐化，轻微提高了锐化的强度。

另外现在 REST 的 UI 屏蔽方案没有开关切换的问题了，所以 FFKeepUIX 的使用也不再是必须的，默认不再启用 FFKeepUIX。

关于 REST，可以手动安装 [REST](https://github.com/4lex4nder/ReshadeEffectShaderToggler) 或者直接使用 [ReShade-CN2 整合包](https://github.com/liuxd17thu/reshade/)。

使用 REST 方案还可以解决 AO 盖住半透明物体（如眼镜、发梢等）的问题，如果有需要可以使用 [ReshadeEffectShaderToggler.ini](reshade-addons/ReshadeEffectShaderToggler.ini) 覆盖 REST 的配置文件。

## 这个预设解决了什么问题？

因为游戏本身的限制，没有任何预设可以面面俱到，而这个预设主要是针对以下几个问题进行了改进：

1. FFXIV 没有对高亮度的饱和度进行限制，所以会出现很多又亮又艳的颜色，比如标志性的水晶蓝色。这与常见的曝光表现不符，也是造成各种死亡打光的元凶之一。这个预设对高亮度的饱和度进行了限制，使得高亮度的颜色更加自然，同时还解决了各种荧光棒武器坐骑和画面格格不入的问题。

2. FFXIV 的整体画面偏黄绿，这是很多人都感觉“偏暖”的原因，尤其一些室内光会因为这种调色显得有些不真实和塑料感。这个预设对整体的颜色进行了微调，让整体颜色更偏中性。

3. FFXIV 缺乏 GI，这个预设使用了一个非常高效的 GI Shader，可以让物体轻微的染上环境的色调使整体观感更加一致，可以有效缓解一些场景中人物和物体像是P上去的感觉。例如沙滩上的物体会略微偏向沙子黄色的色调，草地上的物体会有一些绿色的色调，室内会根据环境呈现略微偏暖或偏冷的色调。

4. FFXIV 的 AO 表现比较的微妙，强弱两档比较生硬，HBAO的半径又过大，没有细节表现。这个预设添加了一些额外的AO，让人物和环境更具有立体感，表现更真实。

5. <del>使用了改进过的 FFKeepUI，可以解决部分职业量普遮罩的问题，并不会引入 REST 的解决方案的各种问题。</del>

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/2ee27864-05fc-417d-bb8f-f1ee060f5964)

除了上述改进，还进行了一些额外的调整使画面有些许“电影感”：

1. 略微压缩了黑白场，使得白色不会过亮（比如正午的海都地板，过场动画等），黑色对比度不会过高，中等亮度区域的整体对比度有所提升。

2. 轻微调整了红色与蓝色的平衡，类似常见影视作品，使得日出、黄昏等的偏场景更偏暖色，并使暗处、夜间略微偏向冷色调，从而增加些许氛围感。

3. 为过场剧情和轻度拍摄提供了自动和手动两个快捷的 DOF 预设，可以在不同场景下快速切换景深开关。

> 该预设是在校色过的sRGB色域的显示器上建立和调整的，这也是用于游戏本身制作与渲染的色域。根据显示设备的不同可能会出现一些不同的结果，但整体趋向应该是相同的。

![image](https://github.com/MapleRecall/reshade-FFXIV-EnhancedGamePlay/assets/18360825/c1f88868-d77a-401d-a2d0-93f7ebbcf369)

## 预设详解

本预设使用了一些自定义的 Shaders，并按照一定的规则与顺序组合而成。如果你对这些细节感兴趣，可以参考[这个文档](Shaders&Effects.md)。

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

9. <del>如果你需要处理诗人、占星和武僧的职业量普遮罩问题，请参考[这个文档中 FFKeepUIX 部分的使用方法](Shaders&Effects.md)。</del>

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

* 使用 MartysMods_MXAO 提供高质量的 AO
* 使用 Glamayre_Fast_Effects 提供粗略的 GI
* 使用 RadiantGI 提供一些精细 GI （性能开销较大）

### Enhanced_XIV_GamePlay_1_Balance：平衡预设 【推荐】

性能开销为 Max 的 60% 左右

* 使用 MartysMods_MXAO 提供高质量的 AO
* 使用 Glamayre_Fast_Effects 提供粗略的 GI

### Enhanced_XIV_GamePlay_2_Lite：轻量预设

性能开销为 Max 的 35% 左右

* 使用 Glamayre_Fast_Effects 提供 AO，效果不如上面的精细（不凑近看也还行嘛！）
* 使用 Glamayre_Fast_Effects 提供粗略的 GI
* 不使用 AnamorphicFlare 提供的镜头炫光效果

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
