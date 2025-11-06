-- Greater Blessing of Suppression

local enabled = true -- Enable/disable the script (true = enabled, false = disabled)

local aura = 600600 -- Replace with desired aura ID
local timer1 = 1000 -- Delay to trigger the event when using commands (ms)
local timer = 20000 -- Delay to trigger the event when using change map event (ms)
local itemID = 600600 -- Item needed to get aura

-- MAP IDs - Convert array to hash table for O(1) lookup
local MAP_IDs = {
    [409] = true, [249] = true, [533] = true, [37] = true, [531] = true, [36] = true,
    [33] = true, [34] = true, [43] = true, [47] = true, [48] = true, [70] = true,
    [90] = true, [109] = true, [129] = true, [209] = true, [229] = true, [230] = true,
    [329] = true, [349] = true, [389] = true, [429] = true, [1001] = true, [1004] = true,
    [1007] = true, [269] = true, [540] = true, [542] = true, [543] = true, [545] = true,
    [546] = true, [547] = true, [552] = true, [553] = true, [554] = true, [555] = true,
    [556] = true, [557] = true, [558] = true, [560] = true, [585] = true, [574] = true,
    [575] = true, [576] = true, [578] = true, [595] = true, [599] = true, [600] = true,
    [601] = true, [602] = true, [604] = true, [608] = true, [619] = true, [632] = true,
    [650] = true, [658] = true, [668] = true, [469] = true, [509] = true, [532] = true,
    [534] = true, [544] = true, [548] = true, [550] = true, [564] = true, [565] = true,
    [580] = true, [603] = true, [615] = true, [616] = true, [624] = true, [631] = true,
    [649] = true, [724] = true
}

-- DUNGEONS --
-- Classic: 33, 34, 36, 43, 47, 48, 70, 90, 109, 129, 209, 229, 230, 329, 349, 389, 429, 1001, 1004, 1007
-- Burning Crusade: 269, 540, 542, 543, 545, 546, 547, 552, 553, 554, 555, 556, 557, 558, 560, 585
-- Wrath of the Lich King: 574, 575, 576, 578, 595, 599, 600, 601, 602, 604, 608, 619, 632, 650, 658, 668
-- RAIDS --
-- Classic: 409, 469, 509, 531
-- Burning Crusade: 532, 534, 544, 548, 550, 564, 565, 580
-- Wrath of the Lich King: 249, 533, 603, 615, 616, 624, 631, 649, 724

-- Check if player is in a valid map
local function playerInCorrectMap(player)
    if not player then
        return false
    end
    local playerMapId = player:GetMapId()
    return MAP_IDs[playerMapId] == true
end

-- Generic function to apply aura to NPC bots
local function ApplyAuraToNpcBots(player, applyAura)
    if not player then
        return
    end
    
    local objects = player:GetNearObjects(60, 3)
    if not objects then
        return
    end
    
    for _, object in ipairs(objects) do
        local creature = object:ToCreature()
        if creature and creature:GetScriptName():match("_bot$") then
            creature:SetFacingToObject(player)
            if applyAura then
                creature:AddAura(aura, creature)
            else
                creature:RemoveAura(aura, creature)
            end
        end
    end
end

-- Generic function to apply aura to pet
local function ApplyAuraToPet(player, range, applyAura)
    if not player then
        return
    end
    
    local creatures = player:GetCreaturesInRange(range)
    if not creatures then
        return
    end
    
    for _, creature in ipairs(creatures) do
        if creature:GetOwner() == player then
            if applyAura then
                creature:AddAura(aura, creature)
            else
                creature:RemoveAura(aura, creature)
            end
            break -- Only one pet per player
        end
    end
end

-- Generic function to apply aura to player
local function ApplyAuraToPlayer(player, applyAura)
    if not player then
        return
    end
    
    if applyAura then
        player:AddAura(aura, player)
    else
        player:RemoveAura(aura, player)
    end
end

-- Apply all auras (to player, pet, and NPC bots)
local function ApplyAllAuras(playerGUID, applyAura)
    local player = GetPlayerByGUID(playerGUID)
    if not player then
        return
    end
    
    ApplyAuraToNpcBots(player, applyAura)
    ApplyAuraToPet(player, 30, applyAura)
    ApplyAuraToPlayer(player, applyAura)
end

-- Send status message to console and in-game
local function SendStatusMessage(playerGUID, isOn)
    local player = GetPlayerByGUID(playerGUID)
    if player then
        local playerName = player:GetName()
        if isOn then
            print("Greater Blessing of Suppression: " .. playerName .. " - turned ON.")
            player:SendBroadcastMessage("Greater Blessing of Suppression turned ON.")
        else
            print("Greater Blessing of Suppression: " .. playerName .. " - turned OFF.")
            player:SendBroadcastMessage("Greater Blessing of Suppression turned OFF.")
        end
    end
end

-- Command handler: Turn ON
local function OnPlayerCommandON(event, player, command)
    if command == "supON" then
        local playerName = player:GetName()
        if not player:HasItem(itemID) then
            print("Greater Blessing of Suppression: " .. playerName .. " - missing the needed item.")
            player:SendBroadcastMessage("Greater Blessing of Suppression: You are missing the needed item.")
            return false
        end
        
        if not playerInCorrectMap(player) then
            print("Greater Blessing of Suppression: " .. playerName .. " - not in the correct map.")
            player:SendBroadcastMessage("Greater Blessing of Suppression: You are not in the correct map.")
            return false
        end
        
        local playerGUID = player:GetGUIDLow()
        player:RegisterEvent(function()
            ApplyAllAuras(playerGUID, true)
            SendStatusMessage(playerGUID, true)
        end, timer1, 1)
        
        return false
    end
end

-- Command handler: Turn OFF
local function OnPlayerCommandOFF(event, player, command)
    if command == "supOFF" then
        local playerGUID = player:GetGUIDLow()
        player:RegisterEvent(function()
            ApplyAllAuras(playerGUID, false)
            SendStatusMessage(playerGUID, false)
        end, timer1, 1)
        
        return false
    end
end

-- Event handler: Player enters map
local function OnPlayerEnterMap(event, player)
    if not player then
        return
    end
    
    local playerName = player:GetName()
    if not player:HasItem(itemID) then
        print("Greater Blessing of Suppression: " .. playerName .. " - missing the needed item.")
        player:SendBroadcastMessage("Greater Blessing of Suppression: You are missing the needed item.")
        return
    end
    
    if not playerInCorrectMap(player) then
        print("Greater Blessing of Suppression: " .. playerName .. " - not in the correct map.")
        player:SendBroadcastMessage("Greater Blessing of Suppression: You are not in the correct map.")
        return
    end
    
    local playerGUID = player:GetGUIDLow()
    player:RegisterEvent(function()
        ApplyAllAuras(playerGUID, true)
        SendStatusMessage(playerGUID, true)
    end, timer, 1)
end

-- Event handler: Player leaves map
local function OnPlayerLeaveMap(event, player)
    if not player then
        return
    end
    
    -- Remove aura if player is no longer in a valid map (has left dungeon/raid)
    if not playerInCorrectMap(player) then
        local playerGUID = player:GetGUIDLow()
        player:RegisterEvent(function()
            ApplyAllAuras(playerGUID, false)
            SendStatusMessage(playerGUID, false)
        end, timer, 1)
    end
end

-- Register events
if enabled then
    RegisterPlayerEvent(42, OnPlayerCommandON)
    RegisterPlayerEvent(42, OnPlayerCommandOFF)
    RegisterPlayerEvent(28, OnPlayerEnterMap)
    RegisterPlayerEvent(28, OnPlayerLeaveMap)
end