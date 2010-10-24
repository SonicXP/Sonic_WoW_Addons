SIB_Version = "4.0";

SIB_Config = {};
SIB_FramePos = {};
SIB_Color = {
    green = "|c0000FF00",
    white = "|c00FFFFFF",
    yellow = "|c00FFFF00",
    red = "|c00FF0000",
    gold = "|cffCEA208",
    endc = "|r",
};
local L = _G["SIB_Locale"];

---------- SIB Library ----------
local x0,y0,xx,yy,upd0,xscr,yscr,curmove;
local uiScale = 1;

local function frameMoving(self)
    local x,y = GetCursorPosition();
    x = x/uiScale;
    y = y/uiScale;
    local xdif = x - x0;
    local ydif = y - y0;
    if (xdif == 0) and (ydif == 0) then
        return;
    end;

    local left = self:GetLeft() + xdif;
    local top = self:GetTop() + ydif;
    local right = left + self:GetWidth();
    local bottom = top - self:GetHeight();
    local newx,newy;

    if left >= -15 and left <= 15 then
        newx = 0;
    elseif right >= xscr-15 and right <= xscr+15 then
        newx = xscr - self:GetWidth();
    else
        newx = left;
    end;

    if yscr-top >= -10 and yscr-top <= 10 then
        newy = yscr;
    elseif bottom >= -10 and bottom <= 10 then
        newy = self:GetHeight();
    else
        newy = top;
    end;

    self:ClearAllPoints();
    self:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", newx, newy);
    x0 = newx + xx;
    y0 = newy - yy;
end

local function DragStart(frame, button)
    if (button == "LeftButton") and (IsShiftKeyDown()) then
        upd0 = frame:GetScript("OnUpdate");
        xscr = GetScreenWidth();
        yscr = GetScreenHeight();
        uiScale = UIParent:GetScale();
        x0, y0 = GetCursorPosition();
        x0 = x0 / uiScale;
        y0 = y0 / uiScale;
        xx = x0 - frame:GetLeft();
        yy = frame:GetTop() - y0;
        frame:SetScript("OnUpdate", frameMoving);
        curmove = frame:GetName();
    end;
end

local function DragStop(frame, button)
    if (button == "LeftButton") and (frame:GetName() == curmove) then
        frame:SetScript("OnUpdate", upd0);
        upd0 = nil;
        curmove = nil;
        uiScale = 1;

        local x = frame:GetLeft();
        local y = frame:GetTop();
        local n = frame:GetName();
        if not (SIB_FramePos[n]) then
            SIB_FramePos[n] = {};
        end;
        SIB_FramePos[n].x = x;
        SIB_FramePos[n].y = y;
    end;
end

SIB = {};
local frameNum = 0;
local config = CreateFrame("Frame");
SIB.frames = {};
SIB.text = {};
SIB.update = {};
SIB.mt = {
    __metatable = "access denied",
    __index = function(self, key)
        if (key == "text") then
            return SIB.text[self.id];
        end;
    end,
    __newindex = function(self, key, value)
        if (key == "text") then
            SIB.text[self.id] = value;
            SIB:TextChanged(self);
        end;
    end,
};

function SIB:New(frame)
    local id = frame.id;

    -- Plugin already exists
    if (self.frames[id]) then
        return;
    end;

    -- Define properties of frame
    self.text[id] = "<Text Not Defined>";
    if (frame.text) then
        self.text[id] = frame.text;
    end;
    frame.text = nil;
    setmetatable(frame, self.mt);
    self.frames[id] = frame;

    -- Create frame
    local fname = "SIB_"..id.."_Frame";
    local tname = "SIB_"..id.."_Text";
    local _, fheight = GameFontNormalSmall:GetFont();
    local ff = CreateFrame(frame.ftype, fname, UIParent);
    ff:SetWidth(100);
    ff:SetHeight(fheight+2);
    local tt = ff:CreateFontString(tname, "ARTWORK", "GameFontNormalSmall");
    tt:SetPoint("LEFT", 0, 0);
    if (SIB_FramePos[ff:GetName()]) then
        ff:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", SIB_FramePos[ff:GetName()].x, SIB_FramePos[ff:GetName()].y);
    else
        ff:SetPoint("TOPLEFT", "UIParent", "TOP", 0, -100 + frameNum*(-20));
    end;
    if (frame.ftype == "Button") then
        ff:RegisterForClicks("AnyUp");
    end;
    ff:EnableMouse(true);
    ff:EnableMouseWheel(true);
    ff:SetScript("OnMouseDown", function(self, button) DragStart(self, button); end);
    ff:SetScript("OnMouseUp", function(self, button) DragStop(self, button); end);
    SIB:TextChanged(frame);

    -- Register Event
    if (frame.event) then
        for _,v in pairs(frame.event) do
            ff:RegisterEvent(v);
        end;
    end;
    if (frame.update) then
        self.update[id] = true;
    end;

    -- Register OnXX Event
    if (frame.onxx) then
        for k,v in pairs(frame.onxx) do
            ff:SetScript(k, function(...) frame.onxx[k](...) end);
        end;
    end;

    -- Config
    if (not SIB_Config[id]) or (type(SIB_Config[id]) ~= "table") then
        SIB_Config[id] = {};
        SIB_Config[id].Enable = true;
        if (frame.config) then
            for k,v in pairs(frame.config) do
                SIB_Config[id][k] = v;
            end;
        end;
    end;

    -- Config panel
    config:AddToPanel(frame);

    ff:Show();
    frameNum = frameNum + 1;

    return frame;
end

function SIB:GetFrame(id)
    if self.frames[id] then
        return self.frames[id];
    else
        return nil;
    end;
end

function SIB:GetFrameName(frame)
    local id = frame.id;
    return "SIB_"..id.."_Frame";
end

function SIB:GetFrameTextName(frame)
    local id = frame.id;
    return "SIB_"..id.."_Text";
end

function SIB:Enable(frame)
    if (not frame) or (type(frame)~="table") then
        return;
    end;

    local id = frame.id;
    local ff = getglobal("SIB_"..id.."_Frame");

    if (frame.event) then
        for _,v in pairs(frame.event) do
            ff:RegisterEvent(v);
            if (frame.onxx.OnEvent) then
                frame.onxx.OnEvent(v);
            end;
        end;
    end;
    if (frame.update) then
        self.update[id] = true;
    end;

    ff:Show();
end

function SIB:Disable(frame)
    if (not frame) or (type(frame)~="table") then
        return;
    end;

    local id = frame.id;
    local ff = getglobal("SIB_"..id.."_Frame");

    if (frame.event) then
        for _,v in pairs(frame.event) do
            ff:UnregisterEvent(v);
        end;
    end;
    if (frame.update) then
        self.update[id] = nil;
    end;

    ff:Hide();
end

function SIB:Iterator()
    return pairs(self.frames);
end

function SIB:GetPluginNumber()
    return frameNum;
end

function SIB:TextChanged(frame)
    local id = frame.id;
    local ff = getglobal("SIB_"..id.."_Frame");
    local tt = getglobal("SIB_"..id.."_Text");
    local text = "";

    if (SIB_Config.Base.ShowIcon) and (frame.icon) then
        text = text .. "|T" .. frame.icon .. ":0:0:2:0|t ";
    end
    if (SIB_Config.Base.ShowName) then
        text = text .. frame.name .. ": ";
    end
    text = text .. frame.text;

    tt:SetText(text);
    ff:SetWidth(tt:GetStringWidth());
end

function SIB:Message(msg, color, stamp)
    local msgadd;

    if not stamp then
        stamp = 1;
    end;
    if not color then
        color = "white";
    end;

    if msg then
        if (stamp == 1) then
            msgadd = SIB_Color.gold.."[Sonic InfoBar]"..SIB_Color[color]..msg..SIB_Color.endc;
        else
            msgadd = SIB_Color[color]..msg..SIB_Color.endc;
        end;
    end;

    DEFAULT_CHAT_FRAME:AddMessage(msgadd);
end


-- SIB_Base_Config
local function BaseDefault()
    SIB_Config["Base"] = {
        UpdateRate = 1;
        ShowName = false;
        ShowIcon = true;
    };
end
BaseDefault();


-- SIB_Frame
local lastTime, updateTime;
local function Update(self, elapsed)
    lastTime = lastTime + elapsed;
    if (lastTime >= updateTime) then
        for k,v in pairs(SIB.update) do
            if v then
                local frame = SIB:GetFrame(k);
                local h = frame.update;
                h();
            end;
        end;

        lastTime = lastTime - updateTime;
    end;
end

local function FrameInitialize(self, event)
    if event == "VARIABLES_LOADED" then
        self:UnregisterEvent("VARIABLES_LOADED");

        updateTime = SIB_Config.Base.UpdateRate;
        lastTime = 0;
        self:SetScript("OnUpdate", function(self, elapsed) Update(self, elapsed); end);

        for id,frame in SIB:Iterator() do
            local framename = SIB:GetFrameName(frame);
            if (SIB_FramePos[framename]) then
                getglobal(framename):SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", SIB_FramePos[framename].x, SIB_FramePos[framename].y);
            end;

            if frame.svload then
                local h = frame.svload;
                h(getglobal(SIB:GetFrameName(frame)));
            end;

            if not SIB_Config[id] then
                SIB_Config[id] = {};
                SIB_Config[id].Enable = true;
            end;
        end;
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD");

        for k,v in pairs(SIB_Config) do
            if (k ~= "Base") then
                if not (v.Enable) then
                    SIB:Disable(SIB:GetFrame(k));
                end;
            end;
        end;
    end;
end

local sibframe = CreateFrame("Frame", "SIB_Frame", UIParent);
sibframe:SetScript("OnEvent", FrameInitialize);
sibframe:RegisterEvent("PLAYER_ENTERING_WORLD");
sibframe:RegisterEvent("VARIABLES_LOADED");


-- Slash Command Handler
local function Cmd(msg)
    InterfaceOptionsFrame_OpenToCategory("Sonic InfoBar");
end

SlashCmdList["Sonic_InfoBar"] = Cmd;
SLASH_Sonic_InfoBar1 = "/sib";


-- Config panel
local function OnClick(self)
    if (self:GetChecked()) then
        SIB:Enable(SIB:GetFrame(self.var));
        SIB_Config[self.var]["Enable"] = true;
    else
        SIB:Disable(SIB:GetFrame(self.var));
        SIB_Config[self.var]["Enable"] = false;
    end
end

local function OnShow(self)
    if SIB_Config[self.var]["Enable"] == true then
        self:SetChecked(true);
    else
        self:SetChecked(nil);
    end;

    local ntext = SIB:GetFrame(self.var).name or "Unnamed Plugin";
    if (string.find(ntext, "|T")) then
        ntext = ntext .. "(" .. SIB:GetFrame(self.var).id .. ")";
    end;
    self.lbl:SetText(ntext);
end

function config:AddToPanel(frame)
    local check = CreateFrame("CheckButton", nil, self, "OptionsCheckButtonTemplate");
    local label = check:CreateFontString(nil,"ARTWORK","GameFontNormalSmall");
    label:SetPoint("LEFT",check,"RIGHT");
    label:SetText(frame.id);
    local x,y;
    x = math.floor(frameNum/20);
    y = frameNum - 20 * x;
    check:SetPoint("TOPLEFT", 10 + x*185 , -65 - y*18);
    check.var = frame.id;
    check.lbl = label;
    check:SetScript("OnClick", OnClick);
    check:SetScript("OnShow", OnShow);

    if (frame.panel) then
        local f = frame.panel;
        f.name = frame.name;
        f.parent = "Sonic InfoBar";
        InterfaceOptions_AddCategory(f);
    end;
end

local function ConfigPanel()
    config.name = "Sonic InfoBar";
    InterfaceOptions_AddCategory(config);

    local l1 = config:CreateFontString(nil,"ARTWORK","GameFontNormalHuge");
    l1:SetPoint("TOPLEFT", 10, -17);
    l1:SetJustifyH("LEFT");
    l1:SetText("Sonic InfoBar " .. SIB_Version);

    local l2 = config:CreateFontString(nil,"ARTWORK","GameFontNormalSmall");
    l2:SetPoint("TOPLEFT", 10, -45);
    l2:SetJustifyH("LEFT");
    l2:SetText(SIB_Color.white .. L.loadedplugins .. SIB_Color.endc);
end
ConfigPanel();
