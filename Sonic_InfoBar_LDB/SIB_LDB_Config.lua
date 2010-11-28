SIB_LDB_Config = {
    MinimapIcon = true;
};

local config = CreateFrame("Frame");

local function ConfigPanel()
    config.name = "LDB插件支持";
    config.parent = "Sonic InfoBar";
    InterfaceOptions_AddCategory(config);

    local l1 = config:CreateFontString(nil,"ARTWORK","GameFontNormalHuge");
    l1:SetPoint("TOPLEFT", 10, -17);
    l1:SetJustifyH("LEFT");
    l1:SetText("Sonic InfoBar LDB Display " .. SIB_LDB_Version);

    local function OnClick_Minimap(self)
        if (self:GetChecked()) then
            SIB_LDB_Launcher_Button:Show();
            SIB_LDB_Config.MinimapIcon = true;
        else
            SIB_LDB_Launcher_Button:Hide();
            SIB_LDB_Config.MinimapIcon = false;
        end;
    end

    local function OnShow_Minimap(self)
        if SIB_LDB_Config.MinimapIcon == true then
            self:SetChecked(true);
        else
            self:SetChecked(nil);
        end;
    end

    local mmapcheck = CreateFrame("CheckButton", nil, config, "OptionsCheckButtonTemplate");
    local mmapchecklabel = mmapcheck:CreateFontString(nil,"ARTWORK","GameFontNormal");
    mmapchecklabel:SetPoint("LEFT",mmapcheck,"RIGHT");
    mmapchecklabel:SetText("显示小地图 LDB Launcher 按钮");
    mmapcheck:SetPoint("TOPLEFT", 10 , -60);
    mmapcheck:SetScript("OnClick", OnClick_Minimap);
    mmapcheck:SetScript("OnShow", OnShow_Minimap);
end
ConfigPanel();

config:RegisterEvent("VARIABLES_LOADED");
config:SetScript("OnEvent", function()
    if (SIB_LDB_Config.MinimapIcon == false) then
        SIB_LDB_Launcher_Button:Hide();
    end;
end);
