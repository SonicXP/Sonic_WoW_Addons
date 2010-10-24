local L = _G["SIB_Locale"];
local frame = {};
local bagType = {
    [1] = L.quiver,
    [2] = L.ammopouch,
    [4] = L.soulbag,
    [8] = L.leatherworkingbag,
    [16] = L.inscriptionbag,
    [32] = L.herbbag,
    [64] = L.enchantingbag,
    [128] = L.engineeringbag,
    [256] = L.keyring,
    [512] = L.gembag,
    [1024] = L.miningbag,
};

--[[
bagType is a bitflag (a number usable with bitlib) 
0 = Unspecified (for bags it means any item, for items it means no special bag type) 
1 = Quiver 
2 = Ammo Pouch 
4 = Soul Bag 
8 = Leatherworking Bag 
16 = Inscription Bag 
32 = Herb Bag 
64 = Enchanting Bag 
128 = Engineering Bag 
256 = Keyring 
512 = Gem Bag 
1024 = Mining Bag 
2048 = Unknown 
4096 = Vanity Pets 
]]

local function bagInfoSpecial(index, type)
    if (type==1 or type==2) then
        local count = 0;
        local size = GetContainerNumSlots(index);
        for slot = 1, size, 1 do
            local exist, num = GetContainerItemInfo(index, slot);
            if exist then
                count = count + num;
            end
        end
        return size, count;
    else
        local size = GetContainerNumSlots(index);
        return size;
    end;
end

local function bagUpdate()
    local totalSlots = 0;
    local freeSlots = 0;
    local usedSlots = 0;
    local special = {};
    local hasSpecial = false;
    
    for index = 0, 4, 1 do
        if GetBagName(index) then
            local free, type = GetContainerNumFreeSlots(index);
            if not bagType[type] then
                totalSlots = totalSlots + GetContainerNumSlots(index);
                freeSlots = freeSlots + free;
            else
                hasSpecial = true;
                local size, count = bagInfoSpecial(index, type);
                if not special[type] then
                    special[type] = {
                        totalSlots = 0,
                        freeSlots = 0,
                        usedSlots = 0,
                        numCount = -1,
                    };
                end;
                special[type].totalSlots = special[type].totalSlots + size;
                special[type].freeSlots = special[type].freeSlots + free;
                if count then
                    if special[type].numCount == -1 then
                        special[type].numCount = 0;
                    end
                    special[type].numCount = special[type].numCount + count;
                end;
            end
        end
    end
    
    usedSlots = totalSlots - freeSlots;
    frame.text = usedSlots.."/"..totalSlots.."(-"..freeSlots..")";
    
    if (hasSpecial and SIB_Config.Bag.Special == 1) then
        local specText = "";
        for k,v in pairs(special) do
            if v.numCount == -1 then
                v.usedSlots = v.totalSlots - v.freeSlots;
                specText = specText .. " " .. bagType[k] .. ": " .. v.usedSlots .. "/" .. v.totalSlots .. "(-" .. v.freeSlots .. ")";
            else
                specText = specText .. " " .. bagType[k] .. ": " .. v.numCount;
            end;
        end;
        
        frame.text = frame.text .. specText;
    end;
end

-- Config Panel
local bagfrm = CreateFrame("Frame");

local function OnClick_Bag_Spec(self)
    if (self:GetChecked()) then
        SIB_Config.Bag.Special = 1;
    else
        SIB_Config.Bag.Special = 0;
    end;
    bagUpdate();
end

local function OnShow_Bag_Spec(self)
    if SIB_Config.Bag.Special == 1 then
        self:SetChecked(true);
    else
        self:SetChecked(nil);
    end;
end

local speccheck = CreateFrame("CheckButton", nil, bagfrm, "OptionsCheckButtonTemplate");
local specchecklabel = speccheck:CreateFontString(nil,"ARTWORK","GameFontNormal");
specchecklabel:SetPoint("LEFT",speccheck,"RIGHT");
specchecklabel:SetText(L.bagspecialcount);
speccheck:SetPoint("TOPLEFT", 10 , -20);
speccheck:SetScript("OnClick", OnClick_Bag_Spec);
speccheck:SetScript("OnShow", OnShow_Bag_Spec);

-- Frame properties
frame.id = "Bag";
frame.ftype = "Frame";
frame.name = L.bag;
frame.icon = "Interface\\Icons\\INV_Misc_Bag_07";
frame.text = "";
frame.event = {
    "BAG_UPDATE",
    "UNIT_INVENTORY_CHANGED",
};
frame.onxx = {
    OnEvent = function(self, event, who)
        if (event == "UNIT_INVENTORY_CHANGED" and who ~= "player") then
            return;
        end
        
        bagUpdate();
    end,
};
frame.panel = bagfrm;
frame.config = {
    Special = 1,
};

SIB:New(frame);
