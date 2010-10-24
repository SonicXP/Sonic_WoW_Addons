if (GetLocale() ~= "zhCN") then return; end;

SIB_Locale = SIB_Locale or {};
local L = _G["SIB_Locale"];

--Base
L.loadedplugins = "已加载的插件: (使用Shift+鼠标左键可拖动各插件)";
L.ok = "确定";
--Base Config
L.misc = "其他设置";
L.updaterate = "设置更新速率";
L.resetconfirm = "确定要重置插件设置？重置完成后将会重新载入UI。";
L.reset = "重置插件设置";
L.showname = "显示模块名称";
L.showicon = "显示模块图标";
--Background
L.background = "背景";
L.settotop = "置于屏幕顶部";
L.settobottom = "置于屏幕底部";
L.cancelset = "取消置顶置底";
--Clock
L.clock = "时钟";
--Coord
L.coord = "坐标";
L.coordplayer = "玩家";
L.coordmouse = "鼠标";
--Durability
L.durability = "耐久度";
L.head = "头部";
L.shoulder = "肩部";
L.chest = "胸部";
L.wrist = "腕部";
L.hand = "手部";
L.waist = "腰部";
L.legs = "腿部";
L.feet = "脚部";
L.mainhand = "主手";
L.offhand = "副手";
L.ranged = "远程";
L.durabilitytip = "装备耐久度";
L.nocost = "无";
L.repaircost = "修理费";
L.durabilitysupport = "如果耐久度信息不正确，请选择此项 (会占用一定内存)";
--Font
L.font = "字体";
L.setfont = "设置字体";
L.setfontcolor = "设置字体颜色";
--FPS
L.fps = "帧数";
--Lag
L.lag = "延迟";
--ItemMonitor
L.itemmonitor = "PVP&物品计数";
L.imtip = "物品计数 & PVP统计";
L.impvp = "PVP统计";
L.imtodaykill = "今日杀敌";
L.imtodayhonor = "今日荣誉";
L.imtotalkill = "总计杀敌";
L.imtotalhonor = "当前荣誉";
L.imarena = "竞技场得分统计";
L.imcurrency = "货币统计";
L.imitem = "物品统计";
L.imadditem = "添加物品";
L.imdelitem = "删除物品";
L.imshowtext = "设置显示文字";
L.imshowtexttip = "今日杀敌为[Xdk]\n今日荣誉为[Xdh]\n总计杀敌为[Xtk]\n[xxx]代表名为\"xxx\"的物品或货币的点数\n\n例如：“正义点数: [正义点数] / 荣誉点数: [荣誉点数]”\n显示为：“正义点数: 1234 / 荣誉点数: 2222”";
L.hearthstone = "炉石";
L.imtext = "[正义点数] / [荣誉点数]";
--Loot
L.loot = "拾取";
L.lootgroup = "队伍分配";
L.needbeforegreed = "需求优先";
L.lootmaster = "队长分配";
L.freeforall = "自由拾取";
L.roundrobin = "轮流拾取";
L.lootraid = "(团队)";
L.lootparty = "(小队)";
L.lootsolo = "无队伍";
--Money
L.money = "金钱";
L.nomoney = "无";
--Time
L.time = "计时器";
L.hour = "小时";
L.minute = "分钟";
L.second = "秒";
L.cleartime = "计数器清零";
L.clearonload = "每次上线后重设计时器";
--UIMemory
L.uimemory = "内存";
L.memorytip = "插件内存统计";
L.memorycollecttip = "Alt+左键点击 回收内存";
L.memorywheeltip = "鼠标滚轮滚动可查看其余插件信息";
L.memoryuitip = "插件内存占用: ";
L.memorylist = "详细内存占用列表";
L.memorycollected = "已回收内存: ";
--Bag
L.bag = "背包";
L.bagspecialcount = "特殊背包统计";
L.quiver = "箭袋";
L.ammopouch = "弹药包";
L.soulbag = "灵魂袋";
L.leatherworkingbag = "制皮袋";
L.inscriptionbag = "铭文袋";
L.herbbag = "草药袋";
L.enchantingbag = "附魔包";
L.engineeringbag = "工程包";
L.keyring = "钥匙链";
L.gembag = "宝石袋";
L.miningbag = "矿石袋";
