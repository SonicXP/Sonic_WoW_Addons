SBT_Version = "4.0 Beta";
SBT_Frame = {
    "PlayerFrameHealthBar",
    "PlayerFrameManaBar",
    "TargetFrameHealthBar",
    "TargetFrameManaBar",
    "PetFrameHealthBar",
    "PetFrameManaBar",
    "PartyMemberFrame1HealthBar",
    "PartyMemberFrame1ManaBar",
    "PartyMemberFrame2HealthBar",
    "PartyMemberFrame2ManaBar",
    "PartyMemberFrame3HealthBar",
    "PartyMemberFrame3ManaBar",
    "PartyMemberFrame4HealthBar",
    "PartyMemberFrame4ManaBar",
    "PartyMemberFrame1PetFrameHealthBar",
    "PartyMemberFrame2PetFrameHealthBar",
    "PartyMemberFrame3PetFrameHealthBar",
    "PartyMemberFrame4PetFrameHealthBar",
    "TargetofTargetHealthBar",
    "TargetofTargetManaBar",
};

function SBT_SetTexture()
    local tempBar;
    local v;
    for _,v in pairs(SBT_Frame) do
        tempBar = getglobal(v);
        if (tempBar) then
            tempBar:SetStatusBarTexture("Interface\\AddOns\\Sonic_BarTexture\\StatusBar");
        end;
    end;
end

local frame = CreateFrame("Frame", "Sonic_BarTextureFrame", UIParent);
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:SetScript("OnEvent", function(self)
    SBT_SetTexture();
    self:UnregisterEvent("PLAYER_ENTERING_WORLD");
end);
