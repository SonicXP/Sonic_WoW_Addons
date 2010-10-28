-- show timer as xx:yy format
local SecondsToTimeAbbrev = function(seconds)
    local m,s;
    if ( seconds > 6000 ) then
        m = floor(seconds / 60);
        s = floor(seconds-(m)*60);
        return format("|cff00ff00%03d:%02d|r", m, s);
    elseif ( seconds > 600 ) then
        m = floor(seconds / 60);
        s = floor(seconds-(m)*60);
        return format("|cff00ff00%02d:%02d|r", m, s);
    elseif ( seconds > 60 ) then
        m = floor(seconds / 60);
        s = floor(seconds-(m)*60);
        return format("|cff00ff00%01d:%02d|r", m, s);
    elseif ( seconds >1 ) then
        m = floor(seconds / 60);
        s = floor(seconds-(m)*60);
        return format("|cffff0000%01d:%02d|r", m, s);
    end
    return "N/A";
end;

hooksecurefunc("AuraButton_UpdateDuration", function(auraButton, timeLeft)
	local duration = auraButton.duration;
	if ( SHOW_BUFF_DURATIONS == "1" and timeLeft ) then
		duration:SetFormattedText(SecondsToTimeAbbrev(timeLeft));
	end
end);

-- change buff timer font
local fontPath = "Fonts\\ARIALN.TTF";
local fontSize = 12;
local fontOutline = "OUTLINE";

local timer_font_frame = CreateFrame("Frame", "SBuff_BuffTimerFrame", UIParent);
timer_font_frame:RegisterEvent("UNIT_AURA");
timer_font_frame:RegisterEvent("PLAYER_ENTERING_WORLD");

local SBuff_SetBuffFont = function(self, event, ...)

    local unit = ...;
    if (event == "UNIT_AURA" and unit ~= "player") then
        return;
    end;

    if (event == "PLAYER_ENTERING_WORLD") then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD");
    end;

    local i;
    local tmpDur;
    --BUFF
    for i=1,32,1 do
        tmpDur = getglobal("BuffButton"..i.."Duration");
        if tmpDur then
            tmpDur:SetFont(fontPath, fontSize, fontOutline);
        end;
    end;
    --DEBUFF
    for i=1,16,1 do
        tmpDur = getglobal("DebuffButton"..i.."Duration");
        if tmpDur then
            tmpDur:SetFont(fontPath, fontSize, fontOutline);
        end;
    end;
    --ENCHANT
    for i=1,2,1 do
        tmpDur = getglobal("TempEnchant"..i.."Duration");
        if tmpDur then
            tmpDur:SetFont(fontPath, fontSize, fontOutline);
        end;
    end;
end;

timer_font_frame:SetScript("OnEvent", SBuff_SetBuffFont);

--[[
--show N/A
hooksecurefunc("AuraButton_Update", function(buttonName, index, filter)
    local unit = PlayerFrame.unit;
    local name, _, _, _, _, _, expirationTime = UnitAura(unit, index, filter);

    if (name) and (expirationTime == 0) and (SHOW_BUFF_DURATIONS == "1") then
        local buffName = buttonName..index;
        local buff = _G[buffName];
        local buffDuration = _G[buffName.."Duration"];

        buffDuration:SetText("|cff00ff00N/A|r");
        buffDuration:Show();
    end;
end);
]]
