local L = _G["SIB_Locale"];
local frame = {};

frame.id = "Money";
frame.ftype = "Frame";
frame.name = L.money;
frame.icon = "Interface\\Minimap\\Tracking\\Auctioneer";
frame.text = "";
frame.event = {
    "PLAYER_ENTERING_WORLD",
    "PLAYER_MONEY",
};
frame.onxx = {
    OnEvent = function(self, event, ...)
        local currentMoney = GetMoney();
        local moneytext = GetCoinTextureString(currentMoney, 0);
        if moneytext == "" then
            moneytext = L.nomoney;
        end;
        frame.text = moneytext;
    end,
};

SIB:New(frame);