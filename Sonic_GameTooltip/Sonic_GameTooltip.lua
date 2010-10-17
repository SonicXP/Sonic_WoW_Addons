SGT_Version = "4.0 Beta";

local SGT_Color = {
    ["TargetText"] = "|c0000FF00",  --目标文字颜色 绿色
    ["Target"] = "|c00FFFFFF",  --目标名称颜色 白色
    ["TargetClass"] = "|c00FF9B00",  --目标职业颜色 橙色
};

local Old_SetDefaultAnchor = GameTooltip_SetDefaultAnchor;
GameTooltip_SetDefaultAnchor = function(tooltip, parent)
    Old_SetDefaultAnchor(tooltip, parent);
    tooltip:ClearAllPoints();
    tooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
    tooltip.default = nil;

    local x, y = GetCursorPosition();
    if (x and y) then
        if (x < tooltip:GetWidth()) then
            tooltip:ClearAllPoints();
            tooltip:SetOwner(UIParent, "ANCHOR_NONE");
            tooltip:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", x, y);
        end;
    end
end

local SGT_AddMouseoverTargetInfo = function(unit)
    if UnitIsVisible(unit.."target") then
        if UnitIsPlayer(unit.."target") then
            GameTooltip:AddLine(SGT_Color["TargetText"].."目标: "..SGT_Color["TargetClass"]..UnitClass(unit.."target").." "..SGT_Color["Target"]..UnitName(unit.."target").."|r");
        else
            GameTooltip:AddLine(SGT_Color["TargetText"].."目标: "..SGT_Color["Target"]..UnitName(unit.."target").."|r");
        end;
    end;
end

local OnEvent = function(self, event)
    if (event == "UPDATE_MOUSEOVER_UNIT") then
        if (UnitExists("mouseover")) then
            SGT_AddMouseoverTargetInfo("mouseover");
            GameTooltip:Show();
        end
    end
end

local frame = CreateFrame("Frame", "Sonic_GameTooltipFrame", UIParent);
-- 3.0.5 UPDATE_MOUSEOVER_UNIT fired when mouseover a unitframe
frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
frame:SetScript("OnEvent", OnEvent);