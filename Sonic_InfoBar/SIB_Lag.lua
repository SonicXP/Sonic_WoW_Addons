local frame = {};
local L = _G["SIB_Locale"];

frame.id = "Lag";
frame.ftype = "Frame";
frame.name = L.lag;
frame.icon = "Interface\\AddOns\\Sonic_InfoBar\\Texture\\uimemory.tga";
frame.text = "";
frame.update = function()
    local _, _, lag = GetNetStats();
    frame.text = lag.."ms";
end;

SIB:New(frame);
