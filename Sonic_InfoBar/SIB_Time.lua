-- Timer
local L = _G["SIB_Locale"];
local totalTime = 0;
local frame = {};

-- ConfigPanel
local timefrm = CreateFrame("Frame");

local function OnClick_Time_Clear(self)
    totalTime = 0;
    frame.text = "0" .. L.second;
end

local function OnClick_Time_LoadReset(self)
    if (self:GetChecked()) then
        SIB_Config.Time.LoadReset = 1;
    else
        SIB_Config.Time.LoadReset = 0;
    end;
end

local function OnShow_Time_LoadReset(self)
    if SIB_Config.Time.LoadReset == 1 then
        self:SetChecked(true);
    else
        self:SetChecked(nil);
    end;
end

local clearbutton = CreateFrame("Button", nil, timefrm, "OptionsButtonTemplate");
clearbutton:SetText(L.cleartime);
clearbutton:SetPoint("TOPLEFT", 10 , -20);
clearbutton:SetScript("OnClick", OnClick_Time_Clear);

local loadcheck = CreateFrame("CheckButton", nil, timefrm, "OptionsCheckButtonTemplate");
local loadchecklabel = loadcheck:CreateFontString(nil,"ARTWORK","GameFontNormal");
loadchecklabel:SetPoint("LEFT",loadcheck,"RIGHT");
loadchecklabel:SetText(L.clearonload);
loadcheck:SetPoint("TOPLEFT", 10 , -50);
loadcheck:SetScript("OnClick", OnClick_Time_LoadReset);
loadcheck:SetScript("OnShow", OnShow_Time_LoadReset);

-- Plugin properties
frame.id = "Time";
frame.ftype = "Frame";
frame.name = L.time;
frame.icon = "Interface\\Icons\\INV_Misc_PocketWatch_01";
frame.text = "";
frame.update = function()
    totalTime = totalTime + SIB_Config.Base.UpdateRate;
    SIB_Config.Time.Total = totalTime;

    local hour = math.floor(totalTime / 3600);
    local minute = math.floor((totalTime - hour * 3600) / 60);
    local second = math.floor(totalTime - hour * 3600 - minute * 60);

    if (hour == 0) and (minute == 0) then
        frame.text = second..L.second;
    elseif (hour == 0) then
        frame.text = minute..L.minute..second..L.second;
    else
        frame.text = hour..L.hour..minute..L.minute..second..L.second;
    end;
end;
frame.svload = function()
    if SIB_Config.Time.LoadReset == 1 then
        totalTime = 0;
    else
        totalTime = SIB_Config.Time.Total;
    end
end;
frame.panel = timefrm;
frame.config = {
    LoadReset = 1,
    Total = 0,
};

SIB:New(frame);
