local frame = {};
local L = _G["SIB_Locale"];

-- Hide Minimap + - Button, Use mouse wheel instead
local function minimap()
    MinimapZoomIn:Hide();
    MinimapZoomOut:Hide();

    Minimap:EnableMouseWheel(true);
    Minimap:SetScript("OnMouseWheel", function(self, button)
        if button > 0 and self:GetZoom() < 5 then
            self:SetZoom(self:GetZoom() + 1);
            PlaySound("igMiniMapZoomIn");
        elseif button < 0 and self:GetZoom() > 0 then
            self:SetZoom(self:GetZoom() - 1);
            PlaySound("igMiniMapZoomOut");
        end;
    end);
end
minimap();

local function coordUpdate()
    local px, py = GetPlayerMapPosition("player");
    frame.text = format("%d.%d", px*100.0, py*100.0);
end

-- Frame Properties
frame.id = "Coord";
frame.ftype = "Frame";
frame.name = L.coord;
frame.icon = "Interface\\WorldMap\\WorldMap-Icon";
frame.text = "";
frame.event = {
    "ZONE_CHANGED",
    "ZONE_CHANGED_INDOORS",
    "ZONE_CHANGED_NEW_AREA",
    "MINIMAP_ZONE_CHANGED",
    "PLAYER_ENTERING_WORLD",
};
frame.onxx = {
    OnEvent = function(self, event, ...)
        if (event == "ZONE_CHANGED_NEW_AREA") then
            SetMapToCurrentZone();
        end;
        coordUpdate();
    end,
    OnUpdate = coordUpdate;
};

SIB:New(frame);

-- WorldMap Coordinate
local world = CreateFrame("Frame", nil, WorldMapFrame);
local label = world:CreateFontString(nil, "ARTWORK", "GameFontNormal");
label:SetPoint("BOTTOM", WorldMapFrame, "BOTTOM", -36, 10);

local function worldUpdate()
    if SIB_Config.Coord.Enable then
        local x, y = GetCursorPosition();
        local px, py = GetPlayerMapPosition("player");

        local scale = WorldMapButton:GetEffectiveScale();
        x = x / scale;
        y = y / scale;
        local width = WorldMapButton:GetWidth();
        local height = WorldMapButton:GetHeight();
        local centerX, centerY = WorldMapButton:GetCenter();
        local adjustedX = (x - (centerX - (width/2))) / width;
        local adjustedY = (centerY + (height/2) - y) / height;
        x = adjustedX * 100;
        y = adjustedY * 100;

        label:SetText(format(L.coordplayer..": %d.%d",px*100.0,py*100.0) .."     ".. format(L.coordmouse..": %d.%d",x,y));
    else
        label:SetText("");
    end;
end

world:SetScript("OnUpdate", worldUpdate);