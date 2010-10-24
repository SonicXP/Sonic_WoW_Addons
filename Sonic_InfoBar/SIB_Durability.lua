local frame = {};
local L = _G["SIB_Locale"];
local Sonic_Durability_Slot = {
    [1] = {name = "headslot", text = L.head},
    [2] = {name = "shoulderslot", text = L.shoulder},
    [3] = {name = "chestslot", text = L.chest},
    [4] = {name = "wristslot", text = L.wrist},
    [5] = {name = "handsslot", text = L.hand},
    [6] = {name = "waistslot", text = L.waist},
    [7] = {name = "legsslot", text = L.legs},
    [8] = {name = "feetslot", text = L.feet},
    [9] = {name = "mainhandslot", text = L.mainhand},
    [10] = {name = "secondaryhandslot", text = L.offhand},
    [11] = {name = "rangedslot", text = L.ranged}
};
local Sonic_Durability_Stamp = string.gsub(DURABILITY_TEMPLATE, "%%d", "(%%d+)");
local SIBDurTip = "GameTooltip";


local function getColor(percent)
    if (percent > 30) then
        return SIB_Color.green;
    elseif (percent > 10) then
        return SIB_Color.yellow;
    else
        return SIB_Color.red;
    end;
end

local function getPercent()
    local itemnum, itemtotal, itempercent, lowest;
    itemnum = 0;
    itemtotal = 0;
    lowest = 100;

    for index in pairs(Sonic_Durability_Slot) do
        if Sonic_Durability_Slot[index].cost then
            itemnum = itemnum + 1;
            itemtotal = itemtotal + Sonic_Durability_Slot[index].percent;
            if (lowest > Sonic_Durability_Slot[index].percent) then
                lowest = Sonic_Durability_Slot[index].percent;
            end;
        end
    end

    if (itemnum == 0) then
        itempercent = 100;
    else
        itempercent = ceil(itemtotal / itemnum);
    end;
    local itemcolor = getColor(lowest);

    return itempercent, itemcolor;
end

local function durUpdate(self, tipname)
    local tooltip = getglobal(tipname);
    for index in pairs(Sonic_Durability_Slot) do
        local id, has, cost;
        id, _ = GetInventorySlotInfo(Sonic_Durability_Slot[index].name);
        Sonic_Durability_Slot[index].cost = nil;
        tooltip:SetOwner(self, "ANCHOR_RIGHT");
        has, _, cost = tooltip:SetInventoryItem("player", id);
        if (has and cost) then
            for i = 2, 30 do
                local current, max, text;
                local tipText = getglobal(tooltip:GetName().."TextLeft"..i);
                if (tipText) then
                    text = tipText:GetText();
                end;
                if (text) then
                    _, _, current, max = string.find(text, Sonic_Durability_Stamp);
                end
                if (current and max) then
                    Sonic_Durability_Slot[index].cost = cost;
                    Sonic_Durability_Slot[index].current = current;
                    Sonic_Durability_Slot[index].max = max;
                    Sonic_Durability_Slot[index].percent = math.floor(current / max * 100);
                    break;
                end
            end
        else
            tooltip:ClearLines();
        end
        tooltip:Hide();
    end

    local totalpercent, itemcolor = getPercent();
    frame.text = itemcolor..totalpercent.."%"..SIB_Color.endc;
end

local function Tooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT");
    GameTooltip:SetText("[Sonic InfoBar] "..L.durabilitytip,0,1,0);

    local totalcost = 0;

    --for index in pairs(Sonic_Durability_Slot) do
    for index = 1, 11 do
        if Sonic_Durability_Slot[index].cost then
            local color = getColor(Sonic_Durability_Slot[index].percent);
            totalcost = totalcost + Sonic_Durability_Slot[index].cost;
            local left = SIB_Color.white..Sonic_Durability_Slot[index].text..SIB_Color.endc;
            local right = color..Sonic_Durability_Slot[index].current.." / "..Sonic_Durability_Slot[index].max.."  ("..Sonic_Durability_Slot[index].percent.."%)"..SIB_Color.endc;
            GameTooltip:AddDoubleLine(left, right);
        end;
    end;

    local totalcosttip = GetCoinTextureString(totalcost);
    if totalcosttip == "" then
        totalcosttip = L.nocost;
    end;
    GameTooltip:AddLine(SIB_Color.green..L.repaircost..": "..SIB_Color.endc..totalcosttip);

    GameTooltip:Show();
end


-- Config Panel
local durfrm = CreateFrame("Frame");

local function OnClick_Support(self)
    if (self:GetChecked()) then
        SIB_Config.Durability.Support = 1;
        if not SIB_NewDurTip then
            SIB_NewDurTip = CreateFrame("GameTooltip", "SIB_NewDurTip", UIParent, "GameTooltipTemplate");
            SIB_NewDurTip:SetFrameStrata("TOOLTIP");
            SIB_NewDurTip:Hide();
        end;
        SIBDurTip = "SIB_NewDurTip";
    else
        SIB_Config.Durability.Support = 0;
        SIBDurTip = "GameTooltip";
    end;
    durUpdate(self, SIBDurTip);
end

local function OnShow_Support(self)
    if SIB_Config.Durability.Support == 1 then
        self:SetChecked(true);
    else
        self:SetChecked(nil);
    end;
end

local scheck = CreateFrame("CheckButton", nil, durfrm, "OptionsCheckButtonTemplate");
local schecklabel = scheck:CreateFontString(nil,"ARTWORK","GameFontNormal");
schecklabel:SetPoint("LEFT",scheck,"RIGHT");
schecklabel:SetText(L.durabilitysupport);
scheck:SetPoint("TOPLEFT", 10 , -20);
scheck:SetScript("OnClick", OnClick_Support);
scheck:SetScript("OnShow", OnShow_Support);


-- Frame Properties
frame.id = "Durability";
frame.ftype = "Frame";
frame.name = L.durability;
frame.icon = "Interface\\Minimap\\Tracking\\Repair";
frame.text = "";
frame.event = {
    "UPDATE_INVENTORY_DURABILITY",
    --[[
    "UPDATE_INVENTORY_ALERTS",
    "PLAYER_ENTERING_WORLD",
    "PLAYER_DEAD",
    "PLAYER_MONEY",
    "PLAYER_REGEN_ENABLED",
    "PLAYER_REGEN_DISABLED",
    "UNIT_INVENTORY_CHANGED",
    "PLAYER_UNGHOST",
    ]]
};
frame.onxx = {
    OnEvent = function(self, event, eventarg)
        if (event == "UNIT_INVENTORY_CHANGED" and eventarg ~= "player") then
            return;
        end;
        durUpdate(self, SIBDurTip);
    end,
    OnEnter = Tooltip,
    OnLeave = function() GameTooltip:Hide(); end,
};
frame.svload = function(self)
    --Sonic_Durability_Stamp = string.gsub(DURABILITY_TEMPLATE, "%%d", "(%%d+)");

    if SIB_Config.Durability.Support == 1 then
        if not SIB_NewDurTip then
            SIB_NewDurTip = CreateFrame("GameTooltip", "SIB_NewDurTip", UIParent, "GameTooltipTemplate");
            SIB_NewDurTip:SetFrameStrata("TOOLTIP");
            SIB_NewDurTip:Hide();
        end;
        SIBDurTip = "SIB_NewDurTip";
    end;
    durUpdate(self, SIBDurTip);
end;
frame.panel = durfrm;
frame.config = {
    Support = 0,
};

SIB:New(frame);
