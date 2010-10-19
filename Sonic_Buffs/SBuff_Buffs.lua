SBuff_Version = "4.0 Beta2";

local SBuff_MAX_PARTY_BUFFS = 12;
local SBuff_MAX_PARTY_DEBUFFS = 8;
local SBuff_MAX_PET_BUFFS = 8;
local SBuff_MAX_PET_DEBUFFS = 8;

local function CreatePartyBuffs()
    local i;
    for i = 1,4,1 do
        local buff;
        local party = "PartyMemberFrame"..i;
        local db;
        --Buff
        for j = 1, SBuff_MAX_PARTY_BUFFS, 1 do
            buff = CreateFrame("Button", party.."Buff"..j, getglobal(party), "PartyBuffFrameTemplate");
            buff:SetID(j);
            buff:ClearAllPoints();
            if j == 1 then
                buff:SetPoint("TOPLEFT", party, "TOPLEFT", 48, -32);
            else
                buff:SetPoint("LEFT", party.."Buff"..j-1, "RIGHT", 2, 0);
            end;
        end
        --Debuff
        db = getglobal(party.."Debuff1");
        db:ClearAllPoints();
        db:SetPoint("LEFT", party, "RIGHT", -5, 5);
        for j = 5, SBuff_MAX_PARTY_DEBUFFS, 1 do
            buff = CreateFrame("Button", party.."Debuff"..j, getglobal(party), "PartyDebuffFrameTemplate");
            buff:SetID(j);
            buff:ClearAllPoints();
            buff:SetPoint("LEFT", party.."Debuff"..j-1, "RIGHT", 2, 0);
        end
    end
end

local function PetDebuffOnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip:SetUnitDebuff(PetFrame.unit, self:GetID());
end

local function PetBuffOnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip:SetUnitBuff(PetFrame.unit, self:GetID());
end

local function CreatePetBuffs()
    --Buff
    for j = 1, SBuff_MAX_PET_BUFFS, 1 do
        buff = CreateFrame("Button", "PetFrameBuff"..j, PetFrame, "PartyBuffFrameTemplate");
        buff:SetID(j);
        buff:ClearAllPoints();
        buff:SetScript("OnEnter",PetBuffOnEnter);
        if j == 1 then
            buff:SetPoint("TOPLEFT", "PetFrame", "TOPLEFT", 48, -42);
        else
            buff:SetPoint("LEFT", "PetFrameBuff"..j-1, "RIGHT", 2, 0);
        end;
    end
    --Debuff
    PetFrameDebuff1:ClearAllPoints();
    --PetFrameDebuff1:SetPoint("LEFT", "PetFrame", "RIGHT", -7, -5);
    PetFrameDebuff1:SetPoint("TOP", "PetFrameBuff1", "BOTTOM", 0, -2);
    for j = 5, SBuff_MAX_PET_DEBUFFS, 1 do
        buff = CreateFrame("Button", "PetFrameDebuff"..j, PetFrame, "PartyDebuffFrameTemplate");
        buff:SetID(j);
        buff:ClearAllPoints();
        buff:SetScript("OnEnter",PetDebuffOnEnter);
        buff:SetPoint("LEFT", "PetFrameDebuff"..j-1, "RIGHT", 2, 0);
    end
end

--Create BuffFrame and DebuffFrame
CreatePartyBuffs();
CreatePetBuffs();

--Hide BuffTooltip
PartyMemberBuffTooltip_Update = function(self)
    return;
end

local is_refresh_hook_func_working = false;
hooksecurefunc("RefreshDebuffs", function(frame, unit, numDebuffs, suffix, checkCVar)
    if (is_refresh_hook_func_working) then
        return;
    end;

    is_refresh_hook_func_working = true;
    local name = frame:GetName();
    if string.find(name, "^PartyMemberFrame%d$") then
        RefreshDebuffs(frame, unit, SBuff_MAX_PARTY_DEBUFFS);
        RefreshBuffs(frame, unit, SBuff_MAX_PARTY_BUFFS);
    elseif (name == "PetFrame") then
        RefreshDebuffs(frame, unit, SBuff_MAX_PET_DEBUFFS);
        RefreshBuffs(frame, unit, SBuff_MAX_PET_BUFFS);
    end;
    is_refresh_hook_func_working = false;
end)