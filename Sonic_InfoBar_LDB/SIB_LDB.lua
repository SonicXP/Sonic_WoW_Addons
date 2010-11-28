SIB_LDB_Version = "4.0";

local sibver = tonumber(_G["SIB_Version"] or 0);
if (sibver < 3.3) then
    message("Sonic InfoBar 版本太低或未加载！");
    return;
elseif (sibver < 3.41) then
    message("Sonic InfoBar 版本太低可能造成未知错误，建议您下载最新版本！");
end;

-- Get LibDataBroker Library
local ldb = LibStub:GetLibrary("LibDataBroker-1.1");

-- Minimap icon for LDB launcher
local buttonSize = 28;

local button = CreateFrame("Button", "SIB_LDB_Launcher_Button", Minimap);
button:SetFrameStrata("MEDIUM");
button:SetWidth(31);
button:SetHeight(31);
button:RegisterForClicks("anyUp");
button:SetMovable(true);
button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");
button:SetPoint("CENTER", Minimap, "CENTER", -16, -80);
local overlay = button:CreateTexture(nil, "OVERLAY");
overlay:SetWidth(53);
overlay:SetHeight(53);
overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder");
overlay:SetPoint("TOPLEFT");
local icon = button:CreateTexture(nil, "BACKGROUND");
icon:SetWidth(20);
icon:SetHeight(20);
icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
icon:SetTexCoord(0.05, 0.95, 0.05, 0.95);
icon:SetPoint("TOPLEFT", 7, -5);

local isShown = false;
local launcherNum = 0;
local container = CreateFrame("Button", nil, button);
container:SetWidth(buttonSize);
container:SetHeight(1);
container:SetPoint("TOP", button, "BOTTOM", 0, 0);
container:Hide();

button:SetScript("OnClick", function(self)
    if isShown then
        container:Hide();
        isShown = false;
    else
        container:Show();
        isShown = true;
    end;
end);
button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT");
    GameTooltip:SetText("Sonic InfoBar LDB Launcher",0,1,0);
    GameTooltip:AddLine(SIB_Color.white.."点击显示/隐藏 LDB Launcher 按钮"..SIB_Color.endc);
    GameTooltip:Show();
end);
button:SetScript("OnLeave", function(self)
    GameTooltip:Hide();
end);
button:SetScript("OnMouseDown", function(self, button)
    if(button == "LeftButton") and (IsShiftKeyDown()) then
        self:StartMoving();
    end
end);
button:SetScript("OnMouseUp", function(self, button)
    if(button == "LeftButton") then
        self:StopMovingOrSizing();
    end
end);

function container:New(obj)
    local frame = CreateFrame("Button", nil, container);
    frame:SetWidth(buttonSize);
    frame:SetHeight(buttonSize);
    frame:SetPoint("TOP", container, "TOP", 0, -(buttonSize + 2) * launcherNum);

    frame:SetScript("OnEnter", obj.OnEnter);
    frame:SetScript("OnLeave", obj.OnLeave);
    frame:SetScript("OnClick", obj.OnClick);
    frame:RegisterForClicks("anyUp");

    frame.texture = frame:CreateTexture();
    frame.texture:SetAllPoints();
    frame.texture:SetTexture(obj.icon);

    launcherNum = launcherNum + 1;
--[[
    local obj = {
        icon = "icon path",
        OnEnter = function() end,
        OnLeave = function() end,
        OnClick = function() end,
    }
]]
end

-- Create display of LDB plugin
local function DataObjectCreated(event, name, dataobj)
    local frame = {};

    if (dataobj.type == "data source") then
        frame.id = name;
        frame.ftype = "Button";
        frame.name = dataobj.label or name;
        frame.icon = dataobj.icon or "Interface\\Icons\\INV_Misc_QuestionMark";

        local ftext;
        if dataobj.text then
            ftext = dataobj.text;
        elseif dataobj.value then
            local su = dataobj.suffix or "";
            ftext = dataobj.value .. su;
        end;
        frame.text = ftext;

        local TooltipShow = function(self)
            if (dataobj.tooltip) then
                dataobj.tooltip:SetOwner(self, "ANCHOR_LEFT");
                dataobj.tooltip:Show();
            elseif (dataobj.OnTooltipShow) then
                GameTooltip:SetOwner(self, "ANCHOR_LEFT");
                dataobj.OnTooltipShow(GameTooltip);
                GameTooltip:Show();
            elseif (dataobj.OnEnter) then
                dataobj.OnEnter(self);
            end;
        end;

        local TooltipHide = function(self)
            if (dataobj.tooltip) then
                dataobj.tooltip:Hide();
            elseif (dataobj.OnTooltipShow) then
                GameTooltip:Hide();
            elseif (dataobj.OnLeave) then
                dataobj.OnLeave(self);
            end;
        end;

        local ButtonClicked = function(self, button)
            if (dataobj.OnClick) then
                dataobj.OnClick(self, button);
            end;
        end;

        frame.onxx = {
            OnClick = ButtonClicked,
            OnEnter = TooltipShow,
            OnLeave = TooltipHide,
        };

        SIB:New(frame);
    elseif (dataobj.type == "launcher") then
        frame.id = name;
        frame.icon = dataobj.icon;

        local TooltipShow = function(self)
            if (dataobj.tooltip) then
                dataobj.tooltip:SetOwner(self, "ANCHOR_LEFT");
                dataobj.tooltip:Show();
            elseif (dataobj.OnTooltipShow) then
                GameTooltip:SetOwner(self, "ANCHOR_LEFT");
                dataobj.OnTooltipShow(GameTooltip);
                GameTooltip:Show();
            elseif (dataobj.OnEnter) then
                dataobj.OnEnter(self);
            else
                GameTooltip:SetOwner(self, "ANCHOR_LEFT");
                local nameA, title, notes, _, _, reason  = GetAddOnInfo(dataobj.tocname or name);
                if reason == "MISSING" then
                    GameTooltip:AddLine(dataobj.label or dataobj.tocname or name);
                else
                    GameTooltip:AddLine(title or nameA);
                    GameTooltip:AddLine(notes, 1, 1, 1);
                end
                if (dataobj.text) then
                    GameTooltip:AddLine(ldb:GetDataObjectByName(name).text);
                end;
                GameTooltip:Show();
            end;
        end;

        local TooltipHide = function(self)
            if (dataobj.tooltip) then
                dataobj.tooltip:Hide();
            elseif (dataobj.OnTooltipShow) then
                GameTooltip:Hide();
            elseif (dataobj.OnLeave) then
                dataobj.OnLeave(self);
            else
                GameTooltip:Hide();
            end;
        end;

        local ButtonClicked = function(self, button)
            if (dataobj.OnClick) then
                dataobj.OnClick(self, button);
            end;
        end;

        frame.OnClick = ButtonClicked;
        frame.OnEnter = TooltipShow;
        frame.OnLeave = TooltipHide;

        container:New(frame);
    end;
end
ldb.RegisterCallback("Sonic_InfoBar", "LibDataBroker_DataObjectCreated", DataObjectCreated)

for name,dataobj in ldb:DataObjectIterator() do
    DataObjectCreated(nil, name, dataobj);
end

-- Data source text changed
local function AttributeChanged(event, name, key, value, dataobj)
    if (dataobj.type ~= "data source") then
        return;
    end;

    if (key == "OnEnter" or key == "OnLeave" or key == "OnClick") then
        return;
    end;

    if (key == "icon") then
        local obj = SIB:GetFrame(name);
        obj.icon = dataobj.icon or "Interface\\Icons\\INV_Misc_QuestionMark";
        return;
    end;

    local id = name;
    local frame = SIB:GetFrame(id);

    local ftext;
    if dataobj.text then
        ftext = dataobj.text;
    elseif dataobj.value then
        local su = dataobj.suffix or "";
        ftext = dataobj.value .. su;
    end;
    if (ftext) then
        frame.text = ftext;
    end;
end
ldb.RegisterCallback("Sonic_InfoBar", "LibDataBroker_AttributeChanged", AttributeChanged);
