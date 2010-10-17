STTX_Version = "4.0 Beta";
STTX_Config = {
    ["targettarget"] = 1,
    ["targettargettarget"] = 0,
    ["mode"] = 1,
};
STTX_Info = {
    [1] = {
        t = "targettarget",
        frame = "Sonic_TT_Frame",
        name = "Sonic_TT_NameText",
        statue = "Sonic_TT_StatusBar",
        health = "Sonic_TT_HealthText",
        func =  function()
                    if (((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 1)) and (STTX_Config["mode"] ~= 0)) then
                        if not UnitPlayerControlled("target") then
                            if ((UnitName("targettarget") == UnitName("player")) and (UnitIsPlayer("targettarget")) and (STTX_Config["mode"] == 1)) then
                                STTX_MessageFrame:AddMessage("你OT了!", 0.92, 0.75, 0.05, 1.0, 0.05)
                            elseif ((UnitName("targettarget") ~= UnitName("player")) and (STTX_Config["mode"] == 2)) then
                                STTX_MessageFrame:AddMessage("你失去了对目标的仇恨 !", 0.92, 0.75, 0.05, 1.0, 0.05)
                            end;
                        end;
                    end;
                end
    },
    [2] = {
        t = "targettargettarget",
        frame = "Sonic_TTT_Frame",
        name = "Sonic_TTT_NameText",
        statue = "Sonic_TTT_StatusBar",
        health = "Sonic_TTT_HealthText"
    },
};

function Sonic_TOTX_OnDragStart(self)
    if(arg1 == "LeftButton") and (IsShiftKeyDown()) then
        self:StartMoving();
    end
end

function Sonic_TOTX_OnDragStop(self)
    if(arg1 == "LeftButton") then
        self:StopMovingOrSizing();
    end
end

function Sonic_TOTX_OnLoad(self)
    SlashCmdList["Sonic_TOTX"] = Sonic_TOTX_SlashCmdHandler;
    SLASH_Sonic_TOTX1 = "/sttx";

    STTX_MessageFrame:SetTimeVisible(0.05);

    self:RegisterEvent("VARIABLES_LOADED");
end;

function Sonic_TOTX_OnEvent(self, event)
    if (STTX_Config["targettargettarget"] == 1) then
        RegisterUnitWatch(Sonic_TTT_Frame);
    elseif (STTX_Config["targettarget"] == 1) then
        RegisterUnitWatch(Sonic_TT_Frame);
    end;

    self:UnregisterEvent("VARIABLES_LOADED");

    Sonic_TTT_Frame:Hide();
    Sonic_TT_Frame:Hide();
end;

function Sonic_TOTX_OnUpdate()
    for i in pairs(STTX_Info) do
        local frame = getglobal(STTX_Info[i].frame);
        if (STTX_Config[STTX_Info[i].t] == 1) then
            STTX_Update(i);
        end;
    end;
end;

function STTX_Update(x)
    local tclass = UnitClass(STTX_Info[x].t);
    local tname = UnitName(STTX_Info[x].t);
    local tnametext = getglobal(STTX_Info[x].name);
    local tstatue = getglobal(STTX_Info[x].statue);
    local thealth = getglobal(STTX_Info[x].health);
    local hpp;

    if UnitIsPlayer(STTX_Info[x].t) then
        tnametext:SetText(tclass.." "..tname);
    else
        tnametext:SetText(tname);
    end;

    if (STTX_Info[x].func) then
        STTX_Info[x].func();
    end;

    if (UnitHealthMax(STTX_Info[x].t) == 0) then
        hpp = 100;
    else
        hpp = ceil(UnitHealth(STTX_Info[x].t) / UnitHealthMax(STTX_Info[x].t) * 100);
    end;
    tstatue:SetValue(hpp);
    thealth:SetText(hpp.."%");
end;

function Sonic_TOTX_SlashCmdHandler(msg)
    if ( (not msg) or (strlen(msg) <= 0 ) or (msg == "help") ) then
        DEFAULT_CHAT_FRAME:AddMessage("==== Sonic TOTX 帮助信息 ====");
        DEFAULT_CHAT_FRAME:AddMessage("版本："..STTX_Version);
        DEFAULT_CHAT_FRAME:AddMessage("Shift+鼠标左键拖动Sonic TOTX框体（注意：请在选中自己为目标时再拖动！）");
        DEFAULT_CHAT_FRAME:AddMessage("/sttx help  --  显示本帮助信息 ");
        DEFAULT_CHAT_FRAME:AddMessage("/sttx on -- 启用 Sonic TOTX");
        DEFAULT_CHAT_FRAME:AddMessage("/sttx off -- 禁用 Sonic TOTX");
        DEFAULT_CHAT_FRAME:AddMessage("/sttx ttton -- 启用目标的目标的目标");
        DEFAULT_CHAT_FRAME:AddMessage("/sttx tttoff -- 禁用目标的目标的目标");
        DEFAULT_CHAT_FRAME:AddMessage("/sttx otoff -- 禁用OT报警");
        DEFAULT_CHAT_FRAME:AddMessage("/sttx ottank -- 设置OT报警为坦克模式");
        DEFAULT_CHAT_FRAME:AddMessage("/sttx otnormal -- 设置OT报警为普通模式");
    elseif (msg == "on") then
        STTX_Config["targettarget"] = 1;
        RegisterUnitWatch(Sonic_TT_Frame);
        DEFAULT_CHAT_FRAME:AddMessage("Sonic_TOTX 已开启 ");
    elseif (msg == "off") then
        STTX_Config["targettarget"] = 0;
        UnregisterUnitWatch(Sonic_TT_Frame);
        Sonic_TT_Frame:Hide();
        DEFAULT_CHAT_FRAME:AddMessage("Sonic_TOTX 已关闭 ");
    elseif (msg == "otoff") then
        STTX_Config["mode"] = 0;
        DEFAULT_CHAT_FRAME:AddMessage("OT报警已关闭 ");
    elseif (msg == "ottank") then
        STTX_Config["mode"] = 2;
        DEFAULT_CHAT_FRAME:AddMessage("OT报警设置为坦克模式 ");
    elseif (msg == "otnormal") then
        STTX_Config["mode"] = 1;
        DEFAULT_CHAT_FRAME:AddMessage("OT报警设置为普通模式 ");
    elseif (msg == "ttton") then
        STTX_Config["targettargettarget"] = 1;
        RegisterUnitWatch(Sonic_TTT_Frame);
        DEFAULT_CHAT_FRAME:AddMessage("目标的目标的目标已开启 ");
    elseif (msg == "tttoff") then
        STTX_Config["targettargettarget"] = 0;
        UnregisterUnitWatch(Sonic_TTT_Frame);
        Sonic_TTT_Frame:Hide();
        DEFAULT_CHAT_FRAME:AddMessage("目标的目标的目标已关闭 ");
    end
end
