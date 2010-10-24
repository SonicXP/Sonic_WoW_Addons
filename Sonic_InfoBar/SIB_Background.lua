local frame = {};
local L = _G["SIB_Locale"];
local blzFramesTop = {
    'PlayerFrame',
    'TargetFrame',
    'MinimapCluster',
    'PartyMemberFrame1',
    'TemporaryEnchantFrame',
};
local blzFramesBottom = {
    'MainMenuBar',
    'MultiBarRight',
    'GroupLootFrame1',
    'FramerateLabel',
    'CastingBarFrame',
};

local function AdjustBlzFrames(self, orig, curr)
    if (orig == curr) then
        return;
    end;

    if (orig == 1) then
        for _,f in pairs(blzFramesTop) do
            local frame = getglobal(f);
            point, relativeTo, relativePoint, xofs, yofs = frame:GetPoint();
            yofs = yofs + SIB_Config.Background.Y;
            frame:ClearAllPoints();
            frame:SetPoint(point, relativeTo, relativePoint, xofs, yofs);
        end;
    elseif (orig == 2) then
        for _,f in pairs(blzFramesBottom) do
            local frame = getglobal(f);
            point, relativeTo, relativePoint, xofs, yofs = frame:GetPoint();
            yofs = yofs - SIB_Config.Background.Y;
            frame:ClearAllPoints();
            frame:SetPoint(point, relativeTo, relativePoint, xofs, yofs);
        end;
    end;

    if (curr == 1) then
        for _,f in pairs(blzFramesTop) do
            local frame = getglobal(f);
            point, relativeTo, relativePoint, xofs, yofs = frame:GetPoint();
            yofs = yofs - SIB_Config.Background.Y;
            frame:ClearAllPoints();
            frame:SetPoint(point, relativeTo, relativePoint, xofs, yofs);
        end;
        self:ClearAllPoints();
        self:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
    elseif (curr == 2) then
        for _,f in pairs(blzFramesBottom) do
            local frame = getglobal(f);
            point, relativeTo, relativePoint, xofs, yofs = frame:GetPoint();
            yofs = yofs + SIB_Config.Background.Y;
            frame:ClearAllPoints();
            frame:SetPoint(point, relativeTo, relativePoint, xofs, yofs);
        end;
        self:ClearAllPoints();
        self:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0);
    else
        self:ClearAllPoints();
        self:SetPoint("TOPLEFT", "UIParent", "LEFT", 0, 0);
    end;
end

-- Config Panel
local bgfrm = CreateFrame("Frame");

local function OnShow_BG_X(self)
    self:SetText(tostring(SIB_Config.Background.X));
end

local function OnShow_BG_Y(self)
    self:SetText(tostring(SIB_Config.Background.Y));
end

local function OnEscapePressed_BG(self)
    self:ClearFocus();
end

local xtext = CreateFrame("EditBox", "SIB_EDIT_BG001", bgfrm, "InputBoxTemplate");
xtext:SetHeight(23);
xtext:SetWidth(60);
xtext:SetAutoFocus(false);
xtext:SetPoint("TOPLEFT", 20 , -20);
xtext:SetScript("OnShow", OnShow_BG_X);
xtext:SetScript("OnEscapePressed", OnEscapePressed_BG);
local ytext = CreateFrame("EditBox", "SIB_EDIT_BG002", bgfrm, "InputBoxTemplate");
ytext:SetHeight(23);
ytext:SetWidth(60);
ytext:SetAutoFocus(false);
ytext:SetPoint("TOPLEFT", 100 , -20);
ytext:SetScript("OnShow", OnShow_BG_Y);
ytext:SetScript("OnEscapePressed", OnEscapePressed_BG);

local function OnClick_BG_OK(self)
    SIB_Config.Background.X = tonumber(xtext:GetText());
    SIB_Config.Background.Y = tonumber(ytext:GetText());
    getglobal(SIB:GetFrameName(frame)):SetWidth(SIB_Config.Background.X);
    getglobal(SIB:GetFrameName(frame)):SetHeight(SIB_Config.Background.Y);
end

local bgokbutton = CreateFrame("Button", nil, bgfrm, "OptionsButtonTemplate");
bgokbutton:SetText(L.ok);
bgokbutton:SetPoint("TOPLEFT", 10 , -50);
bgokbutton:SetScript("OnClick", OnClick_BG_OK);

local function OnClick_BG_Top(self)
    local orig = SIB_Config.Background.Pos;
    SIB_Config.Background.Pos = 1;
    AdjustBlzFrames(getglobal(SIB:GetFrameName(frame)), orig, 1);
end

local function OnClick_BG_Bottom(self)
    local orig = SIB_Config.Background.Pos;
    SIB_Config.Background.Pos = 2;
    AdjustBlzFrames(getglobal(SIB:GetFrameName(frame)), orig, 2);
end

local function OnClick_BG_Cancel(self)
    local orig = SIB_Config.Background.Pos;
    SIB_Config.Background.Pos = 0;
    AdjustBlzFrames(getglobal(SIB:GetFrameName(frame)), orig, 0);
end

local bgtopbutton = CreateFrame("Button", nil, bgfrm, "OptionsButtonTemplate");
bgtopbutton:SetText(L.settotop);
bgtopbutton:SetPoint("TOPLEFT", 10 , -90);
bgtopbutton:SetScript("OnClick", OnClick_BG_Top);

local bgbtmbutton = CreateFrame("Button", nil, bgfrm, "OptionsButtonTemplate");
bgbtmbutton:SetText(L.settobottom);
bgbtmbutton:SetPoint("TOPLEFT", 120 , -90);
bgbtmbutton:SetScript("OnClick", OnClick_BG_Bottom);

local bgcclbutton = CreateFrame("Button", nil, bgfrm, "OptionsButtonTemplate");
bgcclbutton:SetText(L.cancelset);
bgcclbutton:SetPoint("TOPLEFT", 230 , -90);
bgcclbutton:SetScript("OnClick", OnClick_BG_Cancel);

-- Frame properties
frame.id = "Background";
frame.ftype = "Frame";
frame.name = L.background;
frame.text = "";
frame.onxx = {
    OnShow = function(self)
        self:SetWidth(SIB_Config.Background.X);
        self:SetHeight(SIB_Config.Background.Y);
        AdjustBlzFrames(self, 0, SIB_Config.Background.Pos);
    end,
    OnHide = function(self)
        AdjustBlzFrames(self, SIB_Config.Background.Pos, 0);
    end,
};
frame.svload = function(self)
    self:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Addons\\Sonic_InfoBar\\Texture\\BackgroundBorder",
        tile = true,
        tileSize = 16,
        edgeSize = 8,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    });
    self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
    self:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
    self:SetFrameStrata("BACKGROUND");
    getglobal(SIB:GetFrameTextName(frame)):Hide();

    self:SetWidth(SIB_Config.Background.X);
    self:SetHeight(SIB_Config.Background.Y);
    AdjustBlzFrames(self, 0, SIB_Config.Background.Pos);
end;
frame.panel = bgfrm;
frame.config = {
    X = 1024,
    Y = 20,
    Pos = 0, --1 for top, 2 for bottom, 0 for others
};

SIB:New(frame);
