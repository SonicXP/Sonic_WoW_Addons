local frame = {};
local L = _G["SIB_Locale"];

local function FontApply()
    for _, v in SIB:Iterator() do
        local text = getglobal(SIB:GetFrameTextName(v));
        text:SetTextColor(SIB_Config.Font.r, SIB_Config.Font.g, SIB_Config.Font.b);
        text:SetFont(SIB_Config.Font.font, SIB_Config.Font.size);
        if (text:IsShown()) then
            local ff = getglobal(SIB:GetFrameName(v));
            ff:SetHeight(SIB_Config.Font.size+2);
            ff:SetWidth(text:GetStringWidth());
        end;
    end;
end

local function FontNormal()
    for _, v in SIB:Iterator() do
        local text = getglobal(SIB:GetFrameTextName(v));
        text:SetTextColor(frame.config.r, frame.config.g, frame.config.b);
        text:SetFont(GameFontNormal:GetFont(), frame.config.size);
        if (text:IsShown()) then
            local ff = getglobal(SIB:GetFrameName(v));
            ff:SetHeight(frame.config.size+2);
            ff:SetWidth(text:GetStringWidth());
        end;
    end;
end


-- Config Panel
local ffrm = CreateFrame("Frame");

local function OnEscapePressed_Font(self)
    self:ClearFocus();
end

local function OnShow_Font_Font(self)
    self:SetText(SIB_Config.Font.font);
end

local ftext = CreateFrame("EditBox", "SIB_EDIT_FONT001", ffrm, "InputBoxTemplate");
ftext:SetHeight(23);
ftext:SetWidth(240);
ftext:SetAutoFocus(false);
ftext:SetPoint("TOPLEFT", 20 , -20);
ftext:SetScript("OnEscapePressed", OnEscapePressed_Font);
ftext:SetScript("OnShow", OnShow_Font_Font);

local function OnShow_Font_Size(self)
    self:SetText(SIB_Config.Font.size);
end

local stext = CreateFrame("EditBox", "SIB_EDIT_FONT002", ffrm, "InputBoxTemplate");
stext:SetHeight(23);
stext:SetWidth(60);
stext:SetAutoFocus(false);
stext:SetPoint("TOPLEFT", 280 , -20);
stext:SetScript("OnEscapePressed", OnEscapePressed_Font);
stext:SetScript("OnShow", OnShow_Font_Size);

local function OnClick_FontOK(self)
    local font = ftext:GetText();
    local size = stext:GetText();
    if (not font) or (font == "") or (not size) or (size == "") then
        return;
    end;

    SIB_Config.Font.font = font;
    SIB_Config.Font.size = tonumber(size);
    FontApply();
end

local fontbutton = CreateFrame("Button", nil, ffrm, "OptionsButtonTemplate");
fontbutton:SetText(L.setfont);
fontbutton:SetPoint("TOPLEFT", 10 , -50);
fontbutton:SetScript("OnClick", OnClick_FontOK);

local function OnClick_FontColor(self)
    local setcolor = function()
        local R,G,B = ColorPickerFrame:GetColorRGB();
        SIB_Config.Font.r = R;
        SIB_Config.Font.g = G;
        SIB_Config.Font.b = B;
        FontApply();
    end

    local R,G,B;
    R = SIB_Config.Font.r;
    G = SIB_Config.Font.g;
    B = SIB_Config.Font.b;

    ColorPickerFrame.func = setcolor;
    ColorPickerFrame:Show();
    ColorPickerFrame:SetColorRGB(R, G, B);
end

local colorbutton = CreateFrame("Button", nil, ffrm, "OptionsButtonTemplate");
colorbutton:SetText(L.setfontcolor);
colorbutton:SetPoint("TOPLEFT", 200 , -50);
colorbutton:SetScript("OnClick", OnClick_FontColor);


-- Frame Properties
frame.id = "Font";
frame.ftype = "Frame";
frame.name = L.font;
frame.text = "";
frame.event = {
    "PLAYER_ENTERING_WORLD",
};
frame.onxx = {
    OnShow = function(self)
        FontApply();
    end,
    OnHide = function(self)
        FontNormal();
    end,
    OnEvent = function(self)
        FontApply();
    end,
};
frame.svload = function(self)
    self:SetWidth(0);
    self:SetHeight(0);
    self:SetFrameStrata("BACKGROUND");
    getglobal(SIB:GetFrameTextName(frame)):Hide();

    FontApply();
end;
frame.panel = ffrm;
frame.config = {
    font = "Fonts\\ZYKai_T.TTF",
    size = 12,
    r = 1.0,
    g = 0.82,
    b = 0,
};

SIB:New(frame);
