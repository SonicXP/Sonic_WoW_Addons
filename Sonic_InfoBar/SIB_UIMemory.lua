local L = _G["SIB_Locale"];
local frame = {};

local maxEntry = 15;
local tipShown = false;
local start = 1;
local total;
local uimem;

local function UpdateMem()
    UpdateAddOnMemoryUsage();
    uimem = {};
    total = 0;
    for i=1, GetNumAddOns(), 1 do
        if IsAddOnLoaded(i) then
            if(IsAddOnLoaded(i)) then
                local temp = {GetAddOnInfo(i), GetAddOnMemoryUsage(i)};
                table.insert(uimem, temp);
                total = total + temp[2];
            end
        end
    end;
    table.sort(uimem, (function(a, b) return a[2] > b[2] end));

    start = 1;
end

local function Tooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT");
    GameTooltip:SetText("[Sonic InfoBar] "..L.memorytip,0,1,0);
    GameTooltip:AddLine(SIB_Color.white..L.memorycollecttip..SIB_Color.endc);

    if (SIB_Config.UIMemory.List == 1) then
        GameTooltip:AddLine(SIB_Color.white..L.memorywheeltip..SIB_Color.endc);
        GameTooltip:AddLine(" ");
        for i = start, min(#uimem, start + maxEntry - 1), 1 do
            GameTooltip:AddDoubleLine(SIB_Color.gold..uimem[i][1]..SIB_Color.endc, SIB_Color.white..math.floor(uimem[i][2]).."KB"..SIB_Color.endc);
        end
    end;
    GameTooltip:AddLine(" ");
    GameTooltip:AddDoubleLine(SIB_Color.green..L.memoryuitip..SIB_Color.endc, SIB_Color.white..string.format("%.2f", total/1024).."MB"..SIB_Color.endc);

    GameTooltip:Show();
end

local function Wheel(self, button)
    if not tipShown then
        return;
    end;

    if button > 0 then
        if start-maxEntry < 1 then
            return;
        end;
        start = start - maxEntry;
    elseif button < 0 then
        if start+maxEntry > #uimem then
            return;
        end;
        start = start + maxEntry;
    end;

    Tooltip(self);
end

-- Config Panel
local uifrm = CreateFrame("Frame");

local function OnClick_UI_List(self)
    if (self:GetChecked()) then
        SIB_Config.UIMemory.List = 1;
    else
        SIB_Config.UIMemory.List = 0;
    end;
end

local function OnShow_UI_List(self)
    if SIB_Config.UIMemory.List == 1 then
        self:SetChecked(true);
    else
        self:SetChecked(nil);
    end;
end

local listcheck = CreateFrame("CheckButton", nil, uifrm, "OptionsCheckButtonTemplate");
local listchecklabel = listcheck:CreateFontString(nil,"ARTWORK","GameFontNormal");
listchecklabel:SetPoint("LEFT",listcheck,"RIGHT");
listchecklabel:SetText(L.memorylist);
listcheck:SetPoint("TOPLEFT", 10 , -20);
listcheck:SetScript("OnClick", OnClick_UI_List);
listcheck:SetScript("OnShow", OnShow_UI_List);


-- FrameProperties
frame.id = "UIMemory";
frame.ftype = "Button";
frame.name = L.uimemory;
frame.icon = "Interface\\AddOns\\Sonic_InfoBar\\Texture\\uimemory.tga";
frame.text = "";
frame.onxx = {
    OnEnter = function(self)
        UpdateMem();
        Tooltip(self);
        tipShown = true;
    end,
    OnLeave = function()
        GameTooltip:Hide();
        tipShown = false;
    end,
    OnClick = function(self, button)
        if IsAltKeyDown() then
            local mem1 = gcinfo();
            collectgarbage('collect');
            local mem2 = gcinfo();
            local memx = string.format("%.2f", (mem1-mem2)/1024);
            SIB:Message(L.memorycollected..memx.." MB");
        end;
    end,
    OnMouseWheel = Wheel,
};
frame.update = function()
    local usedmem = gcinfo();
    local uimem = string.format("%.2f", usedmem/1024);
    frame.text = uimem.." MB";
end;
frame.panel = uifrm;
frame.config = {
    List = 1,
};

SIB:New(frame);
