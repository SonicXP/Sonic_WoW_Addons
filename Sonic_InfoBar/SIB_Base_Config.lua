local L = _G["SIB_Locale"];

-- Misc Config Panel
local xfrm = CreateFrame("Frame");
xfrm.name = L.misc;
xfrm.parent = "Sonic InfoBar";
InterfaceOptions_AddCategory(xfrm);

local function OnEscapePressed_X(self)
    self:ClearFocus();
end

local function OnShow_X(self)
    self:SetText(SIB_Config.Base.UpdateRate);
end

local xtext = CreateFrame("EditBox", "SIB_EDIT_BASE001", xfrm, "InputBoxTemplate");
xtext:SetHeight(23);
xtext:SetWidth(100);
xtext:SetAutoFocus(false);
xtext:SetPoint("TOPLEFT", 20 , -60);
xtext:SetScript("OnEscapePressed", OnEscapePressed_X);
xtext:SetScript("OnShow", OnShow_X);

local function OnClick_Rate(self)
    local text = xtext:GetText();
    if (not text) or (text == "") then
        return;
    end;
    SIB_Config.Base.UpdateRate = tonumber(text);
    updateTime = tonumber(text);
end

local ratebutton = CreateFrame("Button", nil, xfrm, "OptionsButtonTemplate");
ratebutton:SetText(L.updaterate);
ratebutton:SetPoint("TOPLEFT", 10 , -90);
ratebutton:SetScript("OnClick", OnClick_Rate);

StaticPopupDialogs["SIB_ResetConfirm"] = {
    text = L.resetconfirm,
    button1 = TEXT(YES),
    button2 = TEXT(NO),
    OnAccept = function()
        SIB_Config = nil;
        SIB_FramePos = nil;
        ReloadUI();
    end,
    showAlert = 1,
    timeout = 0,
}

local function OnClick_Reset(self)
    StaticPopup_Show("SIB_ResetConfirm");
end

local resetbutton = CreateFrame("Button", nil, xfrm, "OptionsButtonTemplate");
resetbutton:SetText(L.reset);
resetbutton:SetPoint("TOPLEFT", 10 , -20);
resetbutton:SetScript("OnClick", OnClick_Reset);

local function OnClick_Title(self)
    if (self:GetChecked()) then
        SIB_Config.Base.ShowName = true;
        for _,v in SIB:Iterator() do
            SIB:TextChanged(v);
        end;
    else
        SIB_Config.Base.ShowName = false;
        for _,v in SIB:Iterator() do
            SIB:TextChanged(v);
        end;
    end;
end

local function OnShow_Title(self)
    if SIB_Config.Base.ShowName then
        self:SetChecked(true);
    else
        self:SetChecked(nil);
    end;
end

local ncheck = CreateFrame("CheckButton", nil, xfrm, "OptionsCheckButtonTemplate");
local nchecklabel = ncheck:CreateFontString(nil,"ARTWORK","GameFontNormal");
nchecklabel:SetPoint("LEFT",ncheck,"RIGHT");
nchecklabel:SetText(L.showname);
ncheck:SetPoint("TOPLEFT", 10 , -130);
ncheck:SetScript("OnClick", OnClick_Title);
ncheck:SetScript("OnShow", OnShow_Title);

local function OnClick_Icon(self)
    if (self:GetChecked()) then
        SIB_Config.Base.ShowIcon = true;
        for _,v in SIB:Iterator() do
            SIB:TextChanged(v);
        end;
    else
        SIB_Config.Base.ShowIcon = false;
        for _,v in SIB:Iterator() do
            SIB:TextChanged(v);
        end;
    end;
end

local function OnShow_Icon(self)
    if SIB_Config.Base.ShowIcon then
        self:SetChecked(true);
    else
        self:SetChecked(nil);
    end;
end

local icheck = CreateFrame("CheckButton", nil, xfrm, "OptionsCheckButtonTemplate");
local ichecklabel = ncheck:CreateFontString(nil,"ARTWORK","GameFontNormal");
ichecklabel:SetPoint("LEFT",icheck,"RIGHT");
ichecklabel:SetText(L.showicon);
icheck:SetPoint("TOPLEFT", 10 , -160);
icheck:SetScript("OnClick", OnClick_Icon);
icheck:SetScript("OnShow", OnShow_Icon);
