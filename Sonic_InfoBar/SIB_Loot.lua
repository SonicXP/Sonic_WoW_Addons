local L = _G["SIB_Locale"];
local method = {
    ["group"] = L.lootgroup,
    ["needbeforegreed"] = L.needbeforegreed,
    ["master"] = L.lootmaster,
    ["freeforall"] = L.freeforall,
    ["roundrobin"] = L.roundrobin,
};
local color = {
    [0] = "|c00FFFFFF",
    [1] = "|c00FFFFFF",
    [2] = "|c0000FF00",
    [3] = "|c000000FF",
    [4] = "|c00800080",
};

local frame = {};

frame.id = "Loot";
frame.ftype = "Frame";
frame.name = L.loot;
frame.icon = "Interface\\Buttons\\UI-GroupLoot-Dice-Up";
frame.text = "";
frame.event = {
    "PARTY_LOOT_METHOD_CHANGED",
    "PARTY_MEMBERS_CHANGED",
    "RAID_ROSTER_UPDATE",
    "PLAYER_ENTERING_WORLD",
};
frame.onxx = {
    OnEvent = function(self, event, ...)
        local lootgroup, loottype, lootlevel;
        if (GetNumRaidMembers() > 1) then
            lootgroup = L.lootraid;
            local LootMethod = GetLootMethod();
            local LootThreshold = tonumber(GetLootThreshold());
            loottype = method[LootMethod];
            lootlevel = color[LootThreshold];
        elseif (GetNumPartyMembers() > 0) then
            lootgroup = L.lootparty;
            local LootMethod = GetLootMethod();
            local LootThreshold = tonumber(GetLootThreshold());
            loottype = method[LootMethod];
            lootlevel = color[LootThreshold];
        else
            lootgroup = L.lootsolo;
            loottype = "";
            lootlevel = "";
        end;
        frame.text = lootgroup..lootlevel..loottype..SIB_Color.endc;
    end,
};

SIB:New(frame);
