if (GetLocale() ~= "zhTW") then return; end;

SIB_Locale = SIB_Locale or {};
local L = _G["SIB_Locale"];

--Base
L.loadedplugins = "已載入的插件: (使用Shift+滑鼠左鍵可拖動各插件)";
L.ok = "確定";
--Base Config
L.misc = "其他設置";
L.updaterate = "設置更新速率";
L.resetconfirm = "確定要重置插件設置？重置完成後將會重新載入UI。";
L.reset = "重置插件設置";
L.showname = "顯示模組名稱";
L.showicon = "顯示模組圖示";
--Background
L.background = "背景";
L.settotop = "置於螢幕頂部";
L.settobottom = "置於螢幕底部";
L.cancelset = "取消置頂置底";
--Clock
L.clock = "時鐘";
--Coord
L.coord = "座標";
L.coordplayer = "玩家";
L.coordmouse = "滑鼠";
--Durability
L.durability = "耐久度";
L.head = "頭部";
L.shoulder = "肩部";
L.chest = "胸部";
L.wrist = "腕部";
L.hand = "手部";
L.waist = "腰部";
L.legs = "腿部";
L.feet = "腳部";
L.mainhand = "主手";
L.offhand = "副手";
L.ranged = "遠程";
L.durabilitytip = "裝備耐久度";
L.nocost = "無";
L.repaircost = "修理費";
L.durabilitysupport = "如果耐久度資訊不正確，請選擇此項 (會佔用一定記憶體)";
--Font
L.font = "字體";
L.setfont = "設置字體";
L.setfontcolor = "設置字體顏色";
--FPS
L.fps = "幀數";
--Lag
L.lag = "延遲";
--ItemMonitor
L.itemmonitor = "PVP&物品計數";
L.imtip = "物品計數 & PVP統計";
L.impvp = "PVP統計";
L.imtodaykill = "今日殺敵";
L.imtodayhonor = "今日榮譽";
L.imtotalkill = "總計殺敵";
L.imtotalhonor = "當前榮譽";
L.imarena = "競技場得分統計";
L.imcurrency = "兌換通貨";
L.imitem = "物品統計";
L.imadditem = "添加物品";
L.imdelitem = "刪除物品";
L.imshowtext = "設置顯示文字";
L.imshowtexttip = "今日殺敵為[Xdk]\n今日榮譽為[Xdh]\n總計殺敵為[Xtk]\n[xxx]代表名為\"xxx\"的物品或兌換通貨的點數\n\n例如：“正義點數: [正義點數] / 榮譽點數: [榮譽點數]”\n显示为：“正義點數: 1234 / 榮譽點數: 2222”";
L.hearthstone = "爐石";
L.imtext = "[正義點數] / [榮譽點數]";
--Loot
L.loot = "拾取";
L.lootgroup = "隊伍分配";
L.needbeforegreed = "需求優先";
L.lootmaster = "隊長分配";
L.freeforall = "自由拾取";
L.roundrobin = "輪流拾取";
L.lootraid = "(團隊)";
L.lootparty = "(小隊)";
L.lootsolo = "無隊伍";
--Money
L.money = "金錢";
L.nomoney = "無";
--Time
L.time = "計時器";
L.hour = "小時";
L.minute = "分鐘";
L.second = "秒";
L.cleartime = "計數器清零";
L.clearonload = "每次上線後重設計時器";
--UIMemory
L.uimemory = "記憶體";
L.memorytip = "插件記憶體統計";
L.memorycollecttip = "Alt+左鍵點擊 回收記憶體";
L.memorywheeltip = "滑鼠滾輪滾動可查看其餘插件資訊";
L.memoryuitip = "插件記憶體佔用: ";
L.memorylist = "詳細記憶體佔用清單";
L.memorycollected = "已回收記憶體: ";
--Bag
L.bag = "背包";
L.bagspecialcount = "特殊背包統計";
L.quiver = "箭袋";
L.ammopouch = "彈藥包";
L.soulbag = "靈魂袋";
L.leatherworkingbag = "制皮袋";
L.inscriptionbag = "銘文袋";
L.herbbag = "草藥袋";
L.enchantingbag = "附魔包";
L.engineeringbag = "工程包";
L.keyring = "鑰匙鏈";
L.gembag = "寶石袋";
L.miningbag = "礦石袋";
