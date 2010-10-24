local frame = {};
local L = _G["SIB_Locale"];

frame.id = "FPS";
frame.ftype = "Frame";
frame.name = L.fps;
frame.icon = "Interface\\AddOns\\Sonic_InfoBar\\Texture\\uimemory.tga";
frame.text = "";
frame.update = function()
    local fps = GetFramerate();
    local frameRate = string.format("%.1f", fps);
    frame.text = frameRate.."fps";
end;

SIB:New(frame);
