local frame = {};
local L = _G["SIB_Locale"];

frame.id = "Clock";
frame.ftype = "Frame";
frame.name = L.clock;
frame.icon = "Interface\\Icons\\INV_Misc_PocketWatch_02";
frame.text = "";
frame.update = function()
    local hour, minute = GetGameTime();
    frame.text = string.gsub(string.sub(format(TEXT(TIME_TWELVEHOURAM), hour, minute),1,5)," ","");
end;

SIB:New(frame);
