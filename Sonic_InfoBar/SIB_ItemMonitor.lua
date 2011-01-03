local frame = {};
local L = _G["SIB_Locale"];
local C = _G["SIB_Color"];

local todayKill, todayHonor, totalKill = 0, 0, 0;
local currencyCount = {};

-- item functions
local function getItemName(bag, slot)
    local linktext = nil;

    if (bag == -1) then
        linktext = GetInventoryItemLink("player", slot);
      else
        linktext = GetContainerItemLink(bag, slot);
    end

    if linktext then
        local _,_,name = string.find(linktext, "^.*%[(.*)%].*$");
        return name;
    else
        return "";
    end;
end;

local function itemUpdate()
    for index in pairs(SIB_Config.ItemMonitor.Item) do
        SIB_Config.ItemMonitor.Item[index] = 0;
    end

    local bag,slot;
    for bag = 0, 4, 1 do
        for slot = 1, GetContainerNumSlots(bag), 1 do
            local name = getItemName(bag, slot);
            if (SIB_Config.ItemMonitor.Item[name]) then
                _, itemNumberCount = GetContainerItemInfo(bag, slot);
                SIB_Config.ItemMonitor.Item[name] = SIB_Config.ItemMonitor.Item[name] + itemNumberCount;
            end;
        end
    end
end

-- pvp functions
local function pvpUpdate()
    todayKill, todayHonor = GetPVPSessionStats();
    totalKill = GetPVPLifetimeStats();
end

-- currency functions
local function currencyUpdate()
    currencyCount = {};
    local currencyID = {395, 396, 392, 390, 81, 402, 61, 361, 241, 391, 384, 385, 393, 394, 397, 398, 399, 400, 401};
    for i=1, #currencyID do
        local name, count, icon = GetCurrencyInfo(currencyID[i]);
        if (name and name~="") then
            table.insert(currencyCount, {name = name, count = count, icon = icon});
        end
    end
end

local function Tooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT");
    GameTooltip:SetText("[Sonic InfoBar] "..L.imtip,0,1,0);

    GameTooltip:AddLine(" ");
    GameTooltip:AddLine(C.green.."----- "..L.impvp.." -----"..C.endc);
    GameTooltip:AddDoubleLine(C.gold..L.imtodaykill..C.endc, C.white..todayKill..C.endc);
    GameTooltip:AddDoubleLine(C.gold..L.imtodayhonor..C.endc, C.white..todayHonor..C.endc);
    GameTooltip:AddDoubleLine(C.gold..L.imtotalkill..C.endc, C.white..totalKill..C.endc);

    GameTooltip:AddLine(" ");
    GameTooltip:AddLine(C.green.."----- "..L.imcurrency.." -----"..C.endc);
    --[[local size;
    size = GetCurrencyListSize();
    i = 1;
    while (i <= size) do
        local name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon = GetCurrencyListInfo(i);
        if ( isHeader ) then
            ExpandCurrencyList(i, 1);
            size = GetCurrencyListSize();
        elseif ( name and name ~= "" and (not isHeader) and extraCurrencyType~=1 and extraCurrencyType~=2) then
            GameTooltip:AddDoubleLine("|T"..icon..":14:14:2:0|t "..C.gold..name..C.endc, C.white..count..C.endc);
        end;
        i = i + 1;
    end]]
    for i = 1, #currencyCount, 1 do
        local T = currencyCount[i];
        GameTooltip:AddDoubleLine("|TInterface\\Icons\\"..T.icon..":14:14:2:0|t "..C.gold..T.name..C.endc, C.white..T.count..C.endc);
    end

    GameTooltip:AddLine(" ");
    GameTooltip:AddLine(C.green.."----- "..L.imitem.." -----"..C.endc);
    for index, value in pairs(SIB_Config.ItemMonitor.Item) do
        local icon = GetItemIcon(index);
        if not icon then
            icon = "Interface\\Icons\\INV_Misc_QuestionMark";
        end
        GameTooltip:AddDoubleLine("|T"..icon..":14:14:2:0|t "..C.gold..index..C.endc,C.white..value..C.endc);
    end

    GameTooltip:Show();
end

local function showText()
    local text = SIB_Config.ItemMonitor.Text;
    text = string.gsub(text, "%[Xdh%]", todayHonor);
    text = string.gsub(text, "%[Xdk%]", todayKill);
    text = string.gsub(text, "%[Xtk%]", totalKill);
    for i = 1, #currencyCount, 1 do
        local T = currencyCount[i];
        text = string.gsub(text, "%["..T.name.."%]", T.count);
    end
    for k, v in pairs(SIB_Config.ItemMonitor.Item) do
        text = string.gsub(text, "%["..k.."%]", v);
    end
    frame.text = text;
end

-- Config Panel
local imfrm = CreateFrame("Frame");

local function OnEscapePressed_IM(self)
    self:ClearFocus();
end

local itext = CreateFrame("EditBox", "SIB_EDIT_IM001", imfrm, "InputBoxTemplate");
itext:SetHeight(23);
itext:SetWidth(200);
itext:SetAutoFocus(false);
itext:SetPoint("TOPLEFT", 20 , -20);
itext:SetScript("OnEscapePressed", OnEscapePressed_IM);

local function OnClick_IM_Add(self)
    local text = itext:GetText();
    if (not text) or (text == "") then
        return;
    end;
    SIB_Config.ItemMonitor.Item[text] = 0;
    itemUpdate();
end

local function OnClick_IM_Del(self)
    local text = itext:GetText();
    if (not text) or (text == "") then
        return;
    end;
    SIB_Config.ItemMonitor.Item[text] = nil;
    itemUpdate();
end

local imaddbutton = CreateFrame("Button", nil, imfrm, "OptionsButtonTemplate");
imaddbutton:SetText(L.imadditem);
imaddbutton:SetPoint("TOPLEFT", 10 , -50);
imaddbutton:SetScript("OnClick", OnClick_IM_Add);
local imdelbutton = CreateFrame("Button", nil, imfrm, "OptionsButtonTemplate");
imdelbutton:SetText(L.imdelitem);
imdelbutton:SetPoint("TOPLEFT", 130 , -50);
imdelbutton:SetScript("OnClick", OnClick_IM_Del);

local function OnShow_IM_Text(self)
    self:SetText(SIB_Config.ItemMonitor.Text);
end

local ttext = CreateFrame("EditBox", "SIB_EDIT_IM002", imfrm, "InputBoxTemplate");
ttext:SetHeight(23);
ttext:SetWidth(200);
ttext:SetAutoFocus(false);
ttext:SetPoint("TOPLEFT", 20 , -90);
ttext:SetScript("OnEscapePressed", OnEscapePressed_IM);
ttext:SetScript("OnShow", OnShow_IM_Text);

local function OnClick_IM_Text(self)
    local text = ttext:GetText();
    SIB_Config.ItemMonitor.Text = text;
    showText();
end

local imtxtbutton = CreateFrame("Button", nil, imfrm, "OptionsButtonTemplate");
imtxtbutton:SetText(L.imshowtext);
imtxtbutton:SetPoint("TOPLEFT", 10 , -120);
imtxtbutton:SetScript("OnClick", OnClick_IM_Text);

local imtxtlabel = imfrm:CreateFontString(nil,"ARTWORK","GameFontNormalSmall");
imtxtlabel:SetPoint("TOPLEFT", 10, -150);
imtxtlabel:SetJustifyH("LEFT");
imtxtlabel:SetText(C.white..L.imshowtexttip..C.endc);


-- Frame Properties
frame.id = "ItemMonitor";
frame.ftype = "Frame";
frame.name = L.itemmonitor;
frame.icon = "Interface\\PVPFrame\\PVP-ArenaPoints-Icon";
frame.text = "";
frame.event = {
    "PLAYER_ENTERING_WORLD",
    --item
    "BAG_UPDATE",
    "UNIT_INVENTORY_CHANGED",
    --battleground
    "PLAYER_PVP_KILLS_CHANGED",
    "PLAYER_PVP_RANK_CHANGED",
    --currency
    "CURRENCY_DISPLAY_UPDATE",
};
frame.onxx = {
    OnEvent = function(self, event, eventarg)
        if ( ((event == "UNIT_INVENTORY_CHANGED") and (eventarg == "player")) or (event == "BAG_UPDATE")) then
            itemUpdate();
        elseif ((event == "PLAYER_PVP_KILLS_CHANGED") or (event == "PLAYER_PVP_RANK_CHANGED")) then
            pvpUpdate();
        elseif (event == "CURRENCY_DISPLAY_UPDATE") then
            currencyUpdate();
        else
            itemUpdate();
            pvpUpdate();
            currencyUpdate();
        end;

        showText();
    end,
    OnEnter = Tooltip,
    OnLeave = function() GameTooltip:Hide(); end,
};
frame.panel = imfrm;
frame.config = {
    Text = L.imtext,
    Item = {
        [L.hearthstone] = 0,
    },
};

SIB:New(frame);
