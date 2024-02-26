-- +button for rarity selection
-- +button for Spreadsheet import
-- +button for SR import
-- +button for ignore list import (items that are being rolled and not autolooted)
-- +post all items in /ra
-- +fun machine only raid leader (assist can do /rw as well)
-- +make T1 Boots,... work

-- look at pfui and find range check (edit 40yards)
    -- pfui uses inRange = IsActionInRange(actionSlot);


-- ##############
-- # PARAMETERS #
-- ##############

local config = {
    min_rarity = 2, -- 0 grey, 1 white and quest items, 2 green, 3 blue, ...
    rarities = {"Grey", "White", "Green", "Blue", "Purple"},
    text_if = "r#w#Book:\nr#w#Recipe:\nr#w#Pattern:\nr#e#Onyxia Hide Backpack\nr#e#Tome of Tranquilizing Shot\nr#e#Fortitude of the Scourge\nr#e#Power of the Scourge\nr#e#Might of the Scourge\nr#e#Resilience of the Scourge",
    refresh_time = 5,
    channel = "RAID",
    window_height = 20,
    window_width = 125,
    button_width = 20,
    button_height = 20,
    button_rarity_width = 40,
    button_rarity_height = 20,
    text_size = 9,
    item_translate_table = {}
}

-- https://vanilla-wow-archive.fandom.com/wiki/Tier_1
config.item_translate_table["T1 Helm"] = {"Cenarion Helm", "Giantstalker's Helmet", "Arcanist Crown", "Lawbringer Helm", "Circlet of Prophecy", "Nightslayer Cover",
    "Earthfury Helmet", "Felheart Horns", "Helm of Might"}
config.item_translate_table["T1 Leggings"] = {"Cenarion Leggings", "Giantstalker's Leggings", "Arcanist Leggings", "Lawbringer Legplates", "Pants of Prophecy", "Nightslayer Pants",
    "Earthfury Legguards", "Felheart Pants", "Legplates of Might"}
config.item_translate_table["T1 Wrist"] = {"Cenarion Bracers", "Giantstalker's Bracers", "Arcanist Bindings", "Lawbringer Bracers", "Vambraces of Prophecy", "Nightslayer Bracelets",
    "Earthfury Bracers", "Felheart Bracers", "Bracers of Might"}
config.item_translate_table["T1 Belt"] = {"Cenarion Belt", "Giantstalker's Belt", "Arcanist Belt", "Lawbringer Belt", "Girdle of Prophecy", "Nightslayer Belt",
    "Earthfury Belt", "Felheart Belt", "Belt of Might"}
config.item_translate_table["T1 Boots"] = {"Cenarion Boots", "Giantstalker's Boots", "Arcanist Boots", "Lawbringer Boots", "Boots of Prophecy", "Nightslayer Boots",
    "Earthfury Boots", "Felheart Slippers", "Sabatons of Might"}
config.item_translate_table["T1 Gloves"] = {"Cenarion Gloves", "Giantstalker's Gloves", "Arcanist Gloves", "Lawbringer Gauntlets", "Gloves of Prophecy", "Nightslayer Gloves",
    "Earthfury Gauntlets", "Felheart Gloves", "Gauntlets of Might"}
config.item_translate_table["T1 Shoulder"] = {"Cenarion Spaulders", "Giantstalker's Epaulets", "Arcanist Mantle", "Lawbringer Spaulders", "Mantle of Prophecy", "Nightslayer Shoulder Pads",
    "Earthfury Epaulets", "Felheart Shoulder Pads", "Pauldrons of Might"}
config.item_translate_table["T1 Chest"] = {"Cenarion Vestments", "Giantstalker's Breastplate", "Arcanist Robes", "Lawbringer Chestguard", "Robes of Prophecy", "Nightslayer Chestpiece",
    "Earthfury Vestments", "Felheart Robes", "Breastplate of Might"}

-- https://vanilla-wow-archive.fandom.com/wiki/Tier_2
config.item_translate_table["T2 Helm"] = {"Stormrage Cover", "Dragonstalker's Helm", "Netherwind Crown", "Judgement Crown", "Halo of Transcendence", "Bloodfang Hood",
    "Helmet of Ten Storms", "Nemesis Skullcap", "Helm of Wrath"}
config.item_translate_table["T2 Leggings"] = {"Stormrage Legguards", "Dragonstalker's Legguards", "Netherwind Pants", "Judgement Legplates", "Leggings of Transcendence", "Bloodfang Pants",
    "Legplates of Ten Storms", "Nemesis Leggings", "Legplates of Wrath"}
config.item_translate_table["T2 Wrist"] = {"Stormrage Bracers", "Dragonstalker's Bracers", "Netherwind Bindings", "Judgement Bindings", "Bindings of Transcendence", "Bloodfang Bracers",
    "Bracers of Ten Storms", "Nemesis Bracers", "Bracelets of Wrath"}
config.item_translate_table["T2 Belt"] = {"Stormrage Belt", "Dragonstalker's Belt", "Netherwind Belt", "Judgement Belt", "Belt of Transcendence", "Bloodfang Belt",
    "Belt of Ten Storms", "Nemesis Belt", "Waistband of Wrath"}
config.item_translate_table["T2 Boots"] = {"Stormrage Boots", "Dragonstalker's Greaves", "Netherwind Boots", "Judgement Sabatons", "Boots of Transcendence", "Bloodfang Boots",
    "Greaves of Ten Storms", "Nemesis Boots", "Sabatons of Wrath"}
config.item_translate_table["T2 Gloves"] = {"Stormrage Handguards", "Dragonstalker's Gauntlets", "Netherwind Gloves", "Judgement Gauntlets", "Handguards of Transcendence", "Bloodfang Gloves",
    "Gauntlets of Ten Storms", "Nemesis Gloves", "Gauntlets of Wrath"}
config.item_translate_table["T2 Shoulder"] = {"Stormrage Pauldrons", "Dragonstalker's Spaulders", "Netherwind Mantle", "Judgement Spaulders", "Pauldrons of Transcendence", "Bloodfang Spaulders",
    "Epaulets of Ten Storms", "Nemesis Spaulders", "Pauldrons of Wrath"}
config.item_translate_table["T2 Chest"] = {"Stormrage Chestguard", "Dragonstalker's Breastplate", "Netherwind Robes", "Judgement Breastplate", "Robes of Transcendence", "Bloodfang Chestpiece",
    "Breastplate of Ten Storms", "Nemesis Robes", "Breastplate of Wrath"}

-- https://vanilla-wow-archive.fandom.com/wiki/Tier_3
-- config.item_translate_table["T3 Head"] = {"Desecrated Headpiece", "Desecrated Circlet", "Desecrated Helmet"}
-- config.item_translate_table["T3 Legs"] = {"Desecrated Legguards", "Desecrated Leggings", "Desecrated Legplates"}
-- config.item_translate_table["T3 Bracers"] = {"Desecrated Wristguards", "Desecrated Bindings", "Desecrated Bracers"}
-- config.item_translate_table["T3 Belt"] = {"Desecrated Girdle", "Desecrated Belt", "Desecrated Waistguard"}
-- config.item_translate_table["T3 Boots"] = {"Desecrated Boots", "Desecrated Sandals", "Desecrated Sabatons"}
-- config.item_translate_table["T3 Hands"] = {"Desecrated Handguards", "Desecrated Gloves", "Desecrated Gauntlets"}
-- config.item_translate_table["T3 Shoulders"] = {"Desecrated Spaulders", "Desecrated Shoulderpads", "Desecrated Pauldrons"}
-- config.item_translate_table["T3 Chest"] = {"Desecrated Tunic", "Desecrated Robe", "Desecrated Breastplate"}
-- config.item_translate_table["T3 Ring"] = {"Ring of the Dreamwalker", "Ring of the Cryptstalker", "Frostfire Ring", "Ring of Redemption", "Ring of Faith", "Bonescythe Ring", "Ring of the Earthshatterer",
--     "Plagueheart Ring", "Ring of the Dreadnaught"}


-- ##########
-- # LAYOUT #
-- ##########

local function WindowLayout(window)
    window:SetBackdrop({bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background'})
    window:SetBackdropColor(0, 0, 0, 1)
    window:SetPoint('CENTER', UIParent)
    window:SetWidth(config.window_width)
    window:SetHeight(config.window_height)
    window:EnableMouse(true) -- needed for it to be movable
    window:RegisterForDrag("LeftButton")
    window:SetMovable(true)
    window:SetUserPlaced(true) -- saves the place the user dragged it to
    window:SetScript("OnDragStart", function() window:StartMoving() end)
    window:SetScript("OnDragStop", function() window:StopMovingOrSizing() end)
    window:SetClampedToScreen(true) -- so the window cant be moved out of screen
end

local function ButtonLayout(parent, btn, txt, tooltip, ofs_x, ofs_y, width, height)
    btn:ClearAllPoints()
    btn:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", ofs_x, ofs_y)
    btn:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2}})
    btn:SetWidth(width)
    btn:SetHeight(height)
    btn:Show()
    if not btn.text then
        btn.text = btn:CreateFontString("Status", "OVERLAY", "GameFontNormal")
    end
    btn.text:SetFont(STANDARD_TEXT_FONT, config.text_size, "THINOUTLINE")
    btn.text:SetFontObject(GameFontWhite)
    btn.text:ClearAllPoints()
    btn.text:SetPoint("CENTER", btn, "CENTER")
    btn.text:SetText(txt)
    btn.text:Show()
    btn:SetBackdropColor(1, 1, 1, 1)
    btn:SetBackdropBorderColor(0, 0, 0, 1)
    btn:SetScript("OnEnter", function()
        btn:SetBackdropBorderColor(1, 1, 1, 1)
        GameTooltip:SetOwner(btn, "ANCHOR_TOP")
        GameTooltip:AddLine(tooltip)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function()
        btn:SetBackdropBorderColor(0, 0, 0, 1)
        GameTooltip:Hide()
    end)
end

local function EditBoxLayout(parent, edb)
    edb:ClearAllPoints()
    edb:SetPoint("TOPRIGHT", parent, "TOPLEFT")
    edb:SetMultiLine(true)
    edb:SetFont(STANDARD_TEXT_FONT, 8, "THINOUTLINE")
    edb:SetFontObject(GameFontWhite)
    edb:SetWidth(500)
    edb:SetHeight(100)
    edb:SetBackdrop({bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background'})
    edb:Hide()
end

-- ####################
-- # HELPER FUNCTIONS #
-- ####################

local function print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local function ResetData(data)
    if data then
        for idx,_ in pairs(data) do data[idx] = nil end
    end
end

function GetTableLength(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

-- 21110,"Thunderfury, Blessed Blade of the Windseeker",Ragnaros,Malgoni,Warrior,Protection,,"04/02/2024, 14:53:38"
local function ParseRaidres(text, data_sr) -- SR data
    text = text..'\n' -- add \n so last line will be matched as well
    local pattern = '(%d+),"(.-)",(.-),(.-),(.-),(.-),"(.-)"\n' -- modifier - gets 0 or more repetitions and matches the shortest sequence
    ResetData(data_sr)
    for id, item, boss, attendee, class, specialization, comment, date in string.gfind(text, pattern) do
        if not data_sr[item] then
            data_sr[item] = {}
        end
        table.insert(data_sr[item], attendee)
    end
end

local function TranslateSpreadsheet(data_ss)
    for item, info in pairs(data_ss) do
        if config.item_translate_table[item] then
            for _, item_translate in ipairs(config.item_translate_table[item]) do
                data_ss[item_translate] = info
            end
        end
    end
end

-- Thunderfury, Blessed Blade of the Windseeker#Warrior Fury#All Ranks
local function ParseLootSpreadsheet(text, data_ss) -- data from spreadsheet
    text = text..'\n' -- add \n so last line will be matched as well
    local pattern = '(.-)#(.-)#(.-)\n' -- modifier - gets 0 or more repetitions and matches the shortest sequence
    ResetData(data_ss)
    for item, prio, rank in string.gfind(text, pattern) do
        data_ss[item] = rank.." -> "..prio
    end
    TranslateSpreadsheet(data_ss)
end

-- Thunderfury, Blessed Blade of the Windseeker
local function ParseItemFilter(text, data_if) -- item filter (items in this table will not be autolooted)
    text = text..'\n' -- add \n so last line will be matched as well
    local pattern = '(.-)#(.-)#(.-)\n' -- modifier - gets 0 or more repetitions and matches the shortest sequence
    ResetData(data_if)
    for option, modifier, item in string.gfind(text, pattern) do
        data_if[item] = {option=option, modifier=modifier}
    end
end

local function GetPlayerIndex()
    for idx_loop = 1, GetNumRaidMembers() do
        if (GetMasterLootCandidate(idx_loop) == UnitName("player")) then
            return idx_loop -- get master loot candidate index for player
        end
    end
end

local function ItemIsAutolooted(item_name, data_if)
    for item, info in pairs(data_if) do
        if info.option == "a" then
            if info.modifier == "e" then
                if item_name == item then -- if item_filter equals item_name (Onyxia Hide Backpack)
                    return true
                end
            elseif info.modifier == "w" then
                if string.find(item_name, item) then -- if item_filter is in item_name (Pattern:, Recipe:)
                    return true
                end
            end
        end
    end
end

local function ItemIsRolled(item_name, data_if)
    for item, info in pairs(data_if) do
        if info.option == "r" then
            if info.modifier == "e" then
                if item_name == item then -- if item_filter equals item_name (Onyxia Hide Backpack)
                    return true
                end
            elseif info.modifier == "w" then
                if string.find(item_name, item) then -- if item_filter is in item_name (Pattern:, Recipe:)
                    return true
                end
            end
        end
    end
end

-- ##################
-- # LOOT FUNCTIONS #
-- ##################

local function ShowLoot(data_sr, data_ss, data_if)
    for idx_loot = 1, GetNumLootItems() do
        local item_icon, item_name, item_quantity, item_rarity, item_locked = GetLootSlotInfo(idx_loot)
        local item_is_autolooted = ItemIsAutolooted(item_name, data_if)
        local item_is_rolled = ItemIsRolled(item_name, data_if)
        
        -- if ((item_rarity >= config.min_rarity) and LootSlotIsItem(idx_loot)) or item_filter then -- if rarity>=min and not gold
        if ((item_rarity >= config.min_rarity) and item_quantity>0 and (not item_is_autolooted)) or item_is_rolled then -- if item_quantity=0 for gold; cloth maybe isnt a LootSlotItem, idk -> Test that
            local item_link = GetLootSlotLink(idx_loot) or ""
            local item_ss = data_ss[item_name] or ""
            local item_sr = ""
            if data_sr[item_name] then
                for _, player_name in ipairs(data_sr[item_name]) do
                    item_sr = item_sr..player_name.." "
                end
            end
            local text = item_link..": "..item_ss.." ("..item_sr..")"
            SendChatMessage(text , config.channel, nil, nil)
        else
            local idx_mlc = GetPlayerIndex()
            GiveMasterLoot(idx_loot, idx_mlc)
        end
    end
end

-- ########
-- # INIT #
-- ########

local window = CreateFrame("Frame", "Kikiloot", UIParent)
WindowLayout(window)
local loot_master = ""
local data_sr = {}
local data_ss = {}
local data_if = {}

window.button_sr = CreateFrame("Button", nil, window)
ButtonLayout(window, window.button_sr, "SR", "Import SR", 0, 0, config.button_width, config.button_height)
window.import_sr = CreateFrame("EditBox", nil, UIParent)
EditBoxLayout(window, window.import_sr)

window.button_ss = CreateFrame("Button", nil, window)
ButtonLayout(window, window.button_ss, "SS", "Import Spreadsheet", config.button_width, 0, config.button_width, config.button_height)
window.import_ss = CreateFrame("EditBox", nil, UIParent)
EditBoxLayout(window, window.import_ss)

window.button_if = CreateFrame("Button", nil, window)
ButtonLayout(window, window.button_if, "IF", "Import Item Filter (a/r#w/e#item: a..autoloot, r..roll, w..wildcard, e..exact)", 2*config.button_width, 0, config.button_width, config.button_height)
window.import_if = CreateFrame("EditBox", nil, UIParent)
EditBoxLayout(window, window.import_if)

window.button_mr = CreateFrame("Button", nil, window)
window.button_mr.sub = {}
ButtonLayout(window, window.button_mr, config.rarities[config.min_rarity+1], "Select Rarity (below will be autolooted)", 3*config.button_width, 0, config.button_rarity_width, config.button_rarity_height)
for idx_rarity, txt_rarity in ipairs(config.rarities) do
    local idx_rarity_f = idx_rarity
    local num_rarity_f = idx_rarity-1
    local txt_rarity_f = txt_rarity
    window.button_mr.sub[idx_rarity_f] = CreateFrame("Button", nil, window)
    ButtonLayout(window.button_mr, window.button_mr.sub[idx_rarity_f], txt_rarity_f, "Select Rarity (below will be autolooted)", 0, idx_rarity_f*config.button_rarity_height, config.button_rarity_width, config.button_rarity_height)
    
    window.button_mr.sub[idx_rarity_f]:SetScript("OnClick", function()
        config.min_rarity = num_rarity_f
        window.button_mr.text:SetText(txt_rarity_f)
        for idx_rar, _ in ipairs(config.rarities) do
            window.button_mr.sub[idx_rar]:Hide()
        end
    end)
    window.button_mr.sub[idx_rarity_f]:Hide()
end

-- #################
-- # INTERACTIVITY #
-- #################

window.button_sr:SetScript("OnClick", function()
    window.import_ss:Hide()
    window.import_if:Hide()
    if window.import_sr:IsShown() then
        window.import_sr:Hide()
    else
        window.import_sr:Show()
    end
end)
window.import_sr:SetScript("OnTextChanged", function()
    ParseRaidres(this:GetText(), data_sr)
    -- for item, _ in data_sr do
    --     for _, player in ipairs(data_sr[item]) do
    --         print(item..": "..player)
    --     end
    -- end
end)

window.button_ss:SetScript("OnClick", function()
    window.import_sr:Hide()
    window.import_if:Hide()
    if window.import_ss:IsShown() then
        window.import_ss:Hide()
    else
        window.import_ss:Show()
    end
end)
window.import_ss:SetScript("OnTextChanged", function()
    ParseLootSpreadsheet(this:GetText(), data_ss)
    -- for item, info in data_ss do
    --     print(item..": "..info)
    -- end
end)

window.button_if:SetScript("OnClick", function()
    window.import_ss:Hide()
    window.import_sr:Hide()
    if window.import_if:IsShown() then
        window.import_if:Hide()
    else
        window.import_if:Show()
    end
end)
window.import_if:SetScript("OnTextChanged", function()
    ParseItemFilter(this:GetText(), data_if)
    -- for item, info in pairs(data_if) do
    --     print(item..": "..info.option.."_"..info.modifier)
    -- end
end)
window.import_if:SetText(config.text_if)
ParseItemFilter(window.import_if:GetText(), data_if)

window.button_mr:SetScript("OnClick", function()
    for idx_rarity,_ in ipairs(config.rarities) do
        if window.button_mr.sub[idx_rarity]:IsShown() then
            window.button_mr.sub[idx_rarity]:Hide()
        else
            window.button_mr.sub[idx_rarity]:Show()
        end
    end
end)

-- #######################
-- # ONUPDATE AND EVENTS #
-- #######################

window:RegisterEvent("LOOT_OPENED")
window:SetScript("OnEvent", function()
    if UnitName("player")==loot_master then
        ShowLoot(data_sr, data_ss, data_if)
    end
end)

-- check loot master
window:SetScript("OnUpdate", function()
    if not window.clock then window.clock = GetTime() end
    if GetTime() > window.clock + config.refresh_time then
        local loot_method, loot_master_id_party, loot_master_id_raid = GetLootMethod()
        if (loot_method == "master") then
            if loot_master_id_raid then
                if loot_master_id_raid == 0 then
                    loot_master = UnitName("player")
                else
                    loot_master = UnitName("raid"..loot_master_id_raid)
                end
            elseif loot_master_id_party then
                if loot_master_id_party == 0 then
                    loot_master = UnitName("player")
                else
                    loot_master = UnitName("party"..loot_master_id_party)
                end
            end
        end
        window.clock = GetTime()
    end
end)




-- stupid shit
local fun_machine =  CreateFrame("Frame", nil, UIParent)
local fun_machine_enabled = false
local fun_machine_cd = 5
local joke_machine_pattern ="tell me a joke, captain"
local joke_machine_punchline = nil
local joke_machine_punchline_delay = 5
local motivator_machine_pattern ="motivate me, captain"
local joke_machine = {{"A blind man walks into a bar.", "And a table. And a chair."},
    {"What do wooden whales eat?", "Plankton"},
    {"What's better than winning the silver medal at the Paralympics?", "Having legs."},
    {"Two fish in a tank, one says to the other", "\"You man the guns, I'll drive!\""},
    {"Two soldiers are in a tank, one says to the other", "\"BLURGBLBLURG!\""},
    {"What do you call an alligator in a vest", "An Investigator"},
    {"How many tickles does it take to get an octopus to laugh?", "Ten-tickles!"},
    {"Did you hear about the midget fortune teller who kills his customers?", "He's a small medium at large"},
    {"What's the best time to go to the dentist?", "2:30"},
    {"Yo mama so fat, when she was interviewed on Channel 6 news", "you could see her sides on the channels 5 and 7"},
    {"Yo mama so fat, i swerved to miss her in my car", "and ran out of gas"},
    {"How many push ups can Chuck Norris do?", "All of them"},
    {"How did the hacker get away from the police?", "He ransomware"},
    {"I met a genie once. He gave me one wish. I said \"I wish i could be you\"", "the genie replued \"weurd wush but u wull grant ut\""},
    {"i bought my daughter a refrigerator for her birthday", "i cant wait to see her face light up when she opens it"},
    {"a call comes in to 911 \"come quick, my friend was bitten by a wolf!\", operator:\"Where?\"", "\"no, a regular one\""},
    {"Did you hear about the french cheese factory explosion?", "da brie was everywhere"},
    {"why do germans store their cheese together with their sausage?", "they're prepared for a wurst-kase scenario"},
    {"why did the aztec owl not know what the other owls were saying to each other?", "they were inca hoots"}
}
local motivator_machine = {"It's never too late to give up",
    "This is the worst day of my life",
    "Don't follow your friends off a bridge; lead them",
    "Just because you're special, doesn't mean you're useful",
    "No one is as dumb as all of us together",
    "It may be that the purpose of your life is to serve as a warning for others",
    "If you ever feel alone, don't",
    "Give up on your dreams and die",
    "Trying is the first step to failure",
    "Make sure to drink water so you can stay hydrated while you suffer",
    "The Nail that sticks out gets hammered down",
    "I got an ant farm. They didn't grow shit",
    "They don't think it be like it is but it do",
    "If Id agreed with you we'd both be wrong",
    "Tutant meenage neetle teetle",
    "When you want win but you receive lose",
    "Get two birds stoned at once",
    "Osteoporosis sucks",
    "Success is just failure that hasn't happened yet",
    "Never underestimate the power of stupid people in large groups",
    "I hate everyone equally",
    "Only dread one day at a time",
    "Hope is the first step on the road to disappointment",
    "The beatings will continue until morale improves",
    "It's always darkest just before it goes pitch black",
    "When you do bad, no one will forget",
    "Life's a bitch, then you die",
    "You suck",
    "Fuck you",
    "Not even Noah's ark can carry you, animals",
    "Your mother buys you Mega Bloks instead of Legos",
    "You look like you cut your hair with a knife and fork",
    "You all reek of poverty and animal abuse",
    "Your garden is overgrown and your cucumbers are soft"
}

fun_machine:SetScript("OnUpdate", function()
    if not fun_machine.clock_machine then fun_machine.clock_machine = GetTime() end
    if GetTime() > fun_machine.clock_machine + fun_machine_cd then
        fun_machine_enabled = true
        fun_machine.clock_machine = GetTime()
    end
    if not fun_machine.clock_punchline then fun_machine.clock_punchline = GetTime() end
    if (GetTime() > fun_machine.clock_punchline) and joke_machine_punchline then
        SendChatMessage(joke_machine_punchline, "RAID_WARNING", nil, nil)
        joke_machine_punchline = nil
    end
end)
fun_machine:RegisterEvent("CHAT_MSG_RAID")
fun_machine:RegisterEvent("CHAT_MSG_PARTY")
-- fun_machine:RegisterEvent("CHAT_MSG_RAID_LEADER")
fun_machine:SetScript("OnEvent", function()
    if IsRaidLeader() then
        for _ in string.gfind(arg1, joke_machine_pattern) do
            if fun_machine_enabled then
                local idx = math.random(1, GetTableLength(joke_machine))
                SendChatMessage(joke_machine[idx][1] , "RAID_WARNING", nil, nil)
                joke_machine_punchline = joke_machine[idx][2]
                fun_machine.clock_machine = GetTime()
                fun_machine.clock_punchline = GetTime()+joke_machine_punchline_delay
                fun_machine_enabled = false
            else
                SendChatMessage("No." , "RAID_WARNING", nil, nil)
            end
        end
        for _ in string.gfind(arg1, motivator_machine_pattern) do
            if fun_machine_enabled then
                local idx = math.random(1, GetTableLength(motivator_machine))
                SendChatMessage(motivator_machine[idx] , "RAID_WARNING", nil, nil)
                fun_machine.clock_machine = GetTime()
                fun_machine_enabled = false
            else
                SendChatMessage("No." , "RAID_WARNING", nil, nil)
            end
        end
    end
end)

-- #########
-- # Tests #
-- #########

--[[
ID,Item,Boss,Attendee,Class,Specialization,Comment,Date
21110,"Thunderfury",Ragnaros,Malgoni,Warrior,Protection,,"04/02/2024, 14:53:38"
21110,"Thunderfury",Ragnaros,Kikidora,Warrior,Protection,,"04/02/2024, 14:53:38"
18814,"Splintered Tusk",Ragnaros,Asdf,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Spider's Silk",Ragnaros,Bibbley,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Spider's Silk",Ragnaros,Aldiuss,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Spider's Silk",Ragnaros,Kikidora,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Ruined Pelt",Ragnaros,Kikidora,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Ruined Pelt",Ragnaros,Bibbley,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Ruined Pelt",Ragnaros,Test,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Stringy Vulture Meat",Ragnaros,Kikidora,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Gooey Spider Leg",Ragnaros,Pestilentia,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Spider Ichor",Ragnaros,Grizzlix,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Rough Vulture Feathers",Ragnaros,Asterixs,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Linen Cloth",Ragnaros,Baldnic,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Spider Palp",Ragnaros,Baldnic,Warlock,Destruction,,"04/02/2024, 14:55:41"
--]]

--[[
Lavashard Axe#Warrior Fury#All Ranks
Core Forged Helmet#Paladin Tank#All Ranks
Boots of Blistering Flames#Mage#All Ranks
Ruined Pelt#Rogue#All Ranks
asdf#Rogue#All Ranks
Spider Ichor#Shaman Enh/Hunter#All Ranks
##
##
Test#Warrior Tank /Paladin Tank#All Ranks
T1 Bracers#Class Specific#All Ranks
Spider Palp#Class Specific#All Ranks
--]]

--[[
a#w#Recipe
a#w#Pattern
a#e#Onyxia Hide Backpack
]]