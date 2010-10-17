STAX_Version = "4.0 Beta";

function Sonic_TargetX_OnLoad(self)
    self:RegisterEvent("PLAYER_TARGET_CHANGED");
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("UNIT_HEALTH");
	self:RegisterEvent("UNIT_POWER");

	PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite.blp");
end

local shortClass = nil;

if (GetLocale() == "zhCN") then
	shortClass = {
		["MAGE"] = "法",
		["WARLOCK"] = "术",
		["PRIEST"] = "牧",
		["ROGUE"] = "贼",
		["DRUID"] = "德",
		["HUNTER"] = "猎",
		["SHAMAN"] = "萨",
		["PALADIN"] = "圣",
		["WARRIOR"] = "战",
		["DEATHKNIGHT"] = "死",
	};
elseif (GetLocale() == "zhTW") then
	shortClass = {
		["MAGE"] = "法",
		["WARLOCK"] = "術",
		["PRIEST"] = "牧",
		["ROGUE"] = "賊",
		["DRUID"] = "德",
		["HUNTER"] = "獵",
		["SHAMAN"] = "薩",
		["PALADIN"] = "圣",
		["WARRIOR"] = "戰",
		["DEATHKNIGHT"] = "死",
	};
else
	shortClass = {
		["MAGE"] = "Mage",
		["WARLOCK"] = "WL",
		["PRIEST"] = "Priest",
		["ROGUE"] = "Rogue",
		["DRUID"] = "Dru",
		["HUNTER"] = "Hunter",
		["SHAMAN"] = "Shaman",
		["PALADIN"] = "Pal",
		["WARRIOR"] = "Warrior",
		["DEATHKNIGHT"] = "DK",
	};
end;

local shortCreature = {
	["未指定"] = "未知",
	["小动物"] = "动物",
    ["小動物"] = "動物",
};

function Sonic_TargetX_OnEvent(self, event, arg1)
	local tname = UnitName("target");
	if ( not tname ) then
	    Sonic_TargetHPP:SetText(nil);
		Sonic_TargetMPP:SetText(nil);
	    return;
	end;

    if ( event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD") then
	    local _, engClass = UnitClass("target");

	    if ( not engClass ) then
	    	return;
	    end

    	if UnitIsPlayer("target") then
    	    TargetFrameTextureFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite.blp");
		    TargetFrameTextureFrameName:SetText(shortClass[engClass].." "..tname)
        elseif UnitPlayerControlled("target") then
	        TargetFrameTextureFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare.blp");
		    petFamily = UnitCreatureFamily("target");
		    if (petFamily) then
		        TargetFrameTextureFrameName:SetText(petFamily.." "..tname);
		    else
	    	    TargetFrameTextureFrameName:SetText("宠物 "..tname);
		    end;
	    elseif not (UnitIsFriend("player","target")) then
	        local type = UnitCreatureType("target");
	    	if (type ~= nil) then
				if (shortCreature[type]) then
					TargetFrameTextureFrameName:SetText(shortCreature[type].." "..tname)
				else
					TargetFrameTextureFrameName:SetText(string.sub(type,1,6).." "..tname)
				end;
	    	else
		    	TargetFrameTextureFrameName:SetText("未知 "..tname)
		    end
	    end

        Sonic_TargetX_UpdateHealth();
        Sonic_TargetX_UpdateMana();
	elseif (event == "UNIT_HEALTH") and (arg1 == "target") then
        Sonic_TargetX_UpdateHealth();
	elseif (event == "UNIT_POWER") and (arg1 == "target") then
        Sonic_TargetX_UpdateMana();
	end;

end

function Sonic_TargetX_UpdateHealth()
    targethp = UnitHealth("target");
	targethpm = UnitHealthMax("target");
	targethpp = ceil(targethp / targethpm * 100);
	Sonic_TargetHPP:SetText(targethpp.."%");
end;

function Sonic_TargetX_UpdateMana()
	targetmp = UnitPower("target");
	targetmpm = UnitPowerMax("target");
	if (targetmpm < 1) then
	    Sonic_TargetMPP:SetText(nil);
	  else
	    targetmpp = ceil(targetmp / targetmpm * 100);
	    Sonic_TargetMPP:SetText(targetmpp.."%");
	end;
end;
