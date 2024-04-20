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
    max_rarity = 2, -- 0 grey, 1 white and quest items, 2 green, 3 blue, ...
    rarities = {[-1]="Nothing", [0]="Grey", [1]="White", [2]="Green", [3]="Blue", [4]="Purple"},
    text_if = table.concat{"r#w#Book:\n",
        "r#w#Recipe:\n",
        "r#w#Pattern:\n",
        "r#e#Onyxia Hide Backpack\n",
        "r#e#Tome of Tranquilizing Shot\n",
        "r#e#Fortitude of the Scourge\n",
        "r#e#Power of the Scourge\n",
        "r#e#Might of the Scourge\n",
        "r#e#Resilience of the Scourge"},
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
config.item_translate_table["Ring - Bonescythe"] = {"Bonescythe Ring"}
config.item_translate_table["Ring - Cryptstalker"] = {"Ring of the Cryptstalker"}
config.item_translate_table["Ring - Dreadnaught"] = {"Ring of the Dreadnaught"}
config.item_translate_table["Ring - Dreamwalker"] = {"Ring of the Dreamwalker"}
config.item_translate_table["Ring - Earthshatterer"] = {"Ring of the Earthshatterer"}
config.item_translate_table["Ring - Faith"] = {"Ring of Faith"}
config.item_translate_table["Ring - Frostfire"] = {"Frostfire Ring"}
config.item_translate_table["Ring - Plagueheart"] = {"Plagueheart Ring"}


config.text_ss = table.concat{
    "Lavashard Axe#Warrior Fury#All Ranks\n",
    "Core Forged Helmet#Paladin Tank#All Ranks\n",
    "Boots of Blistering Flames#Mage#All Ranks\n",
    "Ashskin Belt#Rogue#All Ranks\n",
    "Shoulderpads of True Flight#Shaman Enh/Hunter#All Ranks\n",
    "Lost Dark Iron Chain#Warrior Tank /Paladin Tank#All Ranks\n",
    "T1 Wrist#Class Specific#All Ranks\n",
    "T1 Belt#Class Specific#All Ranks\n",
    "Robe of Volatile Power#Holy Paladin> Caster DPS#Raider\n",
    "Salamander Scale Pants#Shaman/Druid/Paladin Healer#Raider\n",
    "Sorcerous Dagger#Caster Dps/Healers#All Ranks\n",
    "Wristguards of Stability#Feral Druid > Warrior Dps/Paladin Dps#All Ranks\n",
    "Choker of Enlightenment#Caster dps#All Ranks\n",
    "Crimson Shocker#Caster/Healers Wand#All Ranks\n",
    "Flamewalker Legplates#Warrior/Paladin  #All Ranks\n",
    "Heavy Dark Iron Ring#Druid Tank>Warrior Tank /Paladin Tank#All Ranks\n",
    "Helm of the Lifegiver#Shaman Healer /Paladin Healer#All Ranks\n",
    "Manastorm Leggings#Healers#All Ranks\n",
    "Ring of Spell Power#Caster Dps#All Ranks\n",
    "Tome of Tranquilizing Shot#Hunter#All Ranks\n",
    "T1 Boots#Class Specific#All Ranks\n",
    "T1 Gloves#Class Specific#All Ranks\n",
    "Quick Strike Ring#Fury/Ret>Feral Druid#Raider\n",
    "Talisman of Ephemeral Power#Caster Dps#Raider\n",
    "Striker's Mark#Rogue/Warrior Fury#Raider\n",
    "Mana Igniting Cord#Mage >Caster Dps#Raider\n",
    "Fire Runed Grimoire#Caster Dps#All Ranks\n",
    "Obsidian Edged Blade#Warrior 2H Fury/Paladin Ret#All Ranks\n",
    "Sabatons of the Flamewalker#Hunter/Enh Shaman#All Ranks\n",
    "Aged Core Leather Gloves#Rogue Dagger>Warrior Fury / Tank#All Ranks\n",
    "Deep Earth Spaulders#Shaman Elemental#All Ranks\n",
    "Earthshaker#Melee Dps #All Ranks\n",
    "Eskhandar's Right Claw#Melee Dps #All Ranks\n",
    "Flameguard Gauntlets#Warrior Fury/Paladin Ret#All Ranks\n",
    "Flamewalker Legplates#Warrior/Paladin  #All Ranks\n",
    "Magma Tempered Boots#Disenchant#All Ranks\n",
    "Medallion of Steadfast Might#Tank#All Ranks\n",
    "T1 Leggings#Class Specific#All Ranks\n",
    "Robe of Volatile Power#Holy Paladin> Caster DPS#Raider\n",
    "Salamander Scale Pants#Shaman/Druid/Paladin Healer#Raider\n",
    "Sorcerous Dagger#Caster Dps/Healers#All Ranks\n",
    "Wristguards of Stability#Feral Druid > Warrior Fury/Paladin Ret#All Ranks\n",
    "Crimson Shocker#Caster/Healers Wand#All Ranks\n",
    "Flamewalker Legplates#Warrior/Paladin  #All Ranks\n",
    "Heavy Dark Iron Ring#Druid Tank>Warrior Tank #All Ranks\n",
    "Helm of the Lifegiver#Shaman Healer /Paladin Healer#All Ranks\n",
    "Manastorm Leggings#Healers#All Ranks\n",
    "Ring of Spell Power#Caster Dps #All Ranks\n",
    "T1 Boots#Class Specific#All Ranks\n",
    "T1 Gloves#Class Specific#All Ranks\n",
    "Bindings of the Windseeker#Warrior Tank/Paladin Tank#Loot Council\n",
    "Brutality Blade#Rogue Sword>Warrior Fury > Hunter #Raider\n",
    "Mana Igniting Cord#Mage >Caster Dps#Raider\n",
    "Quick Strike Ring#Fury/Ret/Enh Shamans>Feral Druid#Raider\n",
    "Talisman of Ephemeral Power#Mage and Warlock#Raider\n",
    "Fire Runed Grimoire#Mage and Warlock#All Ranks\n",
    "Obsidian Edged Blade#Warrior 2H Fury/Paladin Ret#All Ranks\n",
    "Sabatons of the Flamewalker#Hunter/Enh Shaman#All Ranks\n",
    "Aged Core Leather Gloves#Dagger Rogue > Warrior#All Ranks\n",
    "Aurastone Hammer#Shaman/Druid/Pala Healers#All Ranks\n",
    "Deep Earth Spaulders#Shaman Elemental#All Ranks\n",
    "Drillborer Disk#Warrior Tank/Paladin Tank#All Ranks\n",
    "Flameguard Gauntlets#Warrior Fury/Paladin Ret#All Ranks\n",
    "Flamewalker Legplates#Warrior/Paladin  #All Ranks\n",
    "Gutgore Ripper#Rogue #All Ranks\n",
    "Magma Tempered Boots#Disenchant#All Ranks\n",
    "T1 Helm#Class Specific#All Ranks\n",
    "Bindings of the Windseeker#Warrior Tank/Paladin Tank#Loot Council\n",
    "Mana Igniting Cord#Caster Dps#Raider\n",
    "Quick Strike Ring#Fury/Ret/Enh Shamans>Feral Druid#Raider\n",
    "Talisman of Ephemeral Power#Caster Dps#Raider\n",
    "Fire Runed Grimoire#Caster Dps#All Ranks\n",
    "Obsidian Edged Blade#Warrior 2H Fury/Paladin Ret#All Ranks\n",
    "Sabatons of the Flamewalker#Hunter/Enh Shaman#All Ranks\n",
    "Aged Core Leather Gloves#Dagger Rogue > Warrior#All Ranks\n",
    "Deep Earth Spaulders#Shaman Elemental#All Ranks\n",
    "Flameguard Gauntlets#Warrior Fury/Paladin Ret#All Ranks\n",
    "Flamewalker Legplates#Warrior/Paladin  #All Ranks\n",
    "Magma Tempered Boots#Disenchant#All Ranks\n",
    "Seal of the Archmagus#Caster Dps #All Ranks\n",
    "T1 Shoulder#Class Specific#All Ranks\n",
    "Robe of Volatile Power#Holy Paladin> Caster DPS#Raider\n",
    "Salamander Scale Pants#Healer#Raider\n",
    "Sorcerous Dagger#Caster Dps/Healers#All Ranks\n",
    "Wristguards of Stability#Feral Druid > Warrior Dps/Paladin Dps#All Ranks\n",
    "Crimson Shocker#Caster/Healers Wand#All Ranks\n",
    "Flamewalker Legplates#Warrior/Paladin  #All Ranks\n",
    "Heavy Dark Iron Ring#Druid Tank>Warrior Tank /Paladin Tank#All Ranks\n",
    "Helm of the Lifegiver#Shaman Healer /Paladin Healer#All Ranks\n",
    "Manastorm Leggings#Healers#All Ranks\n",
    "Ring of Spell Power#Caster Dps #All Ranks\n",
    "T1 Boots#Class Specific#All Ranks\n",
    "T1 Gloves#Class Specific#All Ranks\n",
    "Robe of Volatile Power#Holy Paladin> Caster DPS#Raider\n",
    "Salamander Scale Pants#Shaman/Druid/Paladin Healer#Raider\n",
    "Sorcerous Dagger#Mage and Warlock#All Ranks\n",
    "Wristguards of Stability#Feral > Fury /Ret#All Ranks\n",
    "Crimson Shocker#Caster/Healers Wand#All Ranks\n",
    "Flamewalker Legplates#Warrior/Paladin  #All Ranks\n",
    "Heavy Dark Iron Ring#Tank#All Ranks\n",
    "Helm of the Lifegiver#Healer#All Ranks\n",
    "Manastorm Leggings#Healers#All Ranks\n",
    "Ring of Spell Power#Caster dps#All Ranks\n",
    "Shadowstrike#Vendor Roll#All Ranks\n",
    "T1 Shoulder#Class Specific#All Ranks\n",
    "Quick Strike Ring#Fury/Ret/Enh Shamans>Feral Druid#Raider\n",
    "Talisman of Ephemeral Power#Caster Dps#Raider\n",
    "Mana Igniting Cord#Mage>Other Casters#Raider\n",
    "Azuresong Mageblade#Caster Dps/Holy Paladin#Raider\n",
    "Fire Runed Grimoire#Caster Dps#All Ranks\n",
    "Staff of Dominance#Caster/Healers Wand#All Ranks\n",
    "Obsidian Edged Blade#Warrior 2H Fury/Paladin Ret#All Ranks\n",
    "Sabatons of the Flamewalker#Hunter/Enh Shaman#All Ranks\n",
    "Aged Core Leather Gloves#Dagger Rogue > Warrior#All Ranks\n",
    "Blastershot Launcher#Warrior Fury>Rogue#All Ranks\n",
    "Deep Earth Spaulders#Shaman Elemental#All Ranks\n",
    "Flameguard Gauntlets#Warrior Fury/Paladin Ret#All Ranks\n",
    "Flamewalker Legplates#Warrior/Paladin  #All Ranks\n",
    "Magma Tempered Boots#Disenchant#All Ranks\n",
    "T1 Chest#Class Specific#All Ranks\n",
    "Ancient Petrified Leaf#Hunter#Loot Council\n",
    "The Eye of Divinity#Priest#Loot Council\n",
    "Cauterizing Band#Healer#Raider\n",
    "Wild Growth Spaulders#Druid/Shaman/Paladin Healer#Raider\n",
    "Sash of Whispered Secrets#Warlock/Shadow Priest#All Ranks\n",
    "Wristguards of True Flight#Hunter/Shaman Enh/Paladin Ret#All Ranks\n",
    "Core Forged Greaves#Tank#All Ranks\n",
    "Core Hound Tooth#Rogue Dagger>Warrior>Hunter#All Ranks\n",
    "Finkle's Lava Dredger#Feral Druid#All Ranks\n",
    "Fireguard Shoulders#Tank Fire Resist#All Ranks\n",
    "Fireproof Cloak#Everyone#All Ranks\n",
    "Gloves of the Hypnotic Flame#Mage#All Ranks\n",
    "Eye of Sulfuras#Shaman Enh/Warrior 2h Fury/Ret Paladin#Loot Council\n",
    "Choker of the Firelord#Caster Dps#Core Raider \n",
    "Band of Accuria#Tank/Melee Dps>Hunters#Core Raider \n",
    "Onslaught Girdle#Warrior Fury/Paladin Ret#Raider\n",
    "Bonereaver's Edge#Warrior 2h fury > Paladin Ret#Raider\n",
    "Band of Sulfuras#Everyone#All Ranks\n",
    "Cloak of the Shrouded Mists#Hunter/Feral Druid/Rogue#All Ranks\n",
    "Crown of Destruction#Shaman Enh>Hunter>Ret Paladin#All Ranks\n",
    "Dragon's Blood Cape#Everyone#All Ranks\n",
    "Essence of the Pure Flame#Everyone#All Ranks\n",
    "Malistar's Defender#Shaman Healer/Paladin Healer#All Ranks\n",
    "Perdition's Blade#Dagger Rogue>Warrior Tank/Fury#All Ranks\n",
    "Shard of the Flame#Everyone#All Ranks\n",
    "Spinal Reaper#Shaman/Warrior 2H Fury/Paladin Ret#All Ranks\n",
    "T2 Leggings#Class Specific#Raider\n",
    "Vis'kag the Bloodletter#Rogue#Loot Council\n",
    "Ancient Cornerstone Grimoire#Everyone#All Ranks\n",
    "Deathbringer#Warriors Fury#Raider\n",
    "Eskhandar's Collar#Feral Druid Tank#All Ranks\n",
    "Head of Onyxia#Warrior/Rogue/Hunter/Feral Druid#All Ranks\n",
    "Mature Black Dragon Sinew#Hunter#Loot Council\n",
    "Ring of Binding#Tank#All Ranks\n",
    "Sapphiron Drape#Caster Dps#All Ranks\n",
    "Shard of the Scale#Healers#All Ranks\n",
    "T2 Helm#Class Specific#All Ranks\n",
    "Band of Dark Dominion#Warlock / Shadow Priest#All Ranks\n",
    "Boots of Pure Thought#Healer#All Ranks\n",
    "Cloak of Draconic Might#Fury Warrio/Enh Shaman/Cat Druid#All Ranks\n",
    "Doom's Edge#Warrior Dual Fury#All Ranks\n",
    "Draconic Avenger#Shaman/Warrior/Paladin Ret#All Ranks\n",
    "Draconic Maul#Feral Druid#All Ranks\n",
    "Essence Gatherer#Healer#All Ranks\n",
    "Interlaced Shadow Jerkin#Everyone#All Ranks\n",
    "Ringo's Blizzard Boots#Mage#All Ranks\n",
    "Mantle of the Blackwing Cabal#Shadow Priest > Caster Dps#Raider\n",
    "The Untamed Blade#Paladin Ret Prio#Raider\n",
    "Gloves of Rapid Evolution#All Healers#All Ranks\n",
    "Spineshatter#Warrior/Paladin Tank#All Ranks\n",
    "Arcane Infused Gem#Hunter#All Ranks\n",
    "The Black Book#Warlock#All Ranks\n",
    "T2 Wrist#Class Specific#Raider\n",
    "Mind Quickening Gem#Mage#Raider\n",
    "Red Dragonscale Protector#Shaman/Paladin Healers#Raider\n",
    "Helm of Endless Rage#Warrior/Paladin Dps#All Ranks\n",
    "Dragonfang Blade#Dagger Rogue#All Ranks\n",
    "Pendant of the Fallen Dragon#Healer#All Ranks\n",
    "Rune of Metamorphosis#Druid#All Ranks\n",
    "T2 Belt#Class Specific#Raider\n",
    "Maladath, Runed blade of the Black Flight#Tank Non Human>Rogue/Dual Fury#Loot Council\n",
    "Lifegiving Gem#Tank#Loot Council\n",
    "Bracers of Arcane Accuracy#Caster Dps#Core Raider \n",
    "Black Brood Pauldrons#Hunter/Enh Shaman#All Ranks\n",
    "Head of Broodlord Lashlayer#Everyone#All Ranks\n",
    "Heartstriker#Rogue and Fury PvP#All Ranks\n",
    "Venomous Totem#Rogue#All Ranks\n",
    "T2 Boots#Class Specific#Raider\n",
    "Rejuvenating Gem#All Healers#Core Raider \n",
    "Drake Talon Pauldrons#Warrior Fury#Raider\n",
    "Cloak of Firemaw#Rogue Prio#Raider\n",
    "Black Ash Robe#Everyone#All Ranks\n",
    "Claw of the Black Drake#Warrior Dual Fury/Rogue#All Ranks\n",
    "Drake Talon Cleaver#Shaman Enh>Paladin Ret>Warrior#All Ranks\n",
    "Firemaw's Clutch#Shadow Priest >Healer>Caster#All Ranks\n",
    "Natural Alignment Crystal#Shaman Elemental#All Ranks\n",
    "Scrolls of Blinding Light#Paladin Holy#All Ranks\n",
    "Primalist's Linked Legguards#Shaman Elemental#All Ranks\n",
    "Ring of Blackrock#Shaman>Everyone #All Ranks\n",
    "Shadow Wing Focus Staff#Caster Dps#All Ranks\n",
    "Taut Dragonhide Belt#Rogue/Hunter#All Ranks\n",
    "T2 Gloves#Class Specific#Raider\n",
    "Drake Fang Talisman#Fury, Rogue and Tank >Hunter #Core Raider \n",
    "Rejuvenating Gem#All Healers#Core Raider \n",
    "Band of Forced Concentration#Caster Dps#Raider\n",
    "Drake Talon Pauldrons#Warrior Fury#Raider\n",
    "Aegis of Preservation#Priest#All Ranks\n",
    "Dragonbreath Hand Cannon#Rogue, Hunter and Tank#All Ranks\n",
    "Drake Talon Cleaver#Shaman Enh>Paladin Ret>Warrior#All Ranks\n",
    "Ebony Flame Gloves#Warlock / Shadow Priest#All Ranks\n",
    "Malfurion's Blessed Bulwark#Feral Druid >Rogue#All Ranks\n",
    "Ring of Blackrock#Shaman>Everyone #All Ranks\n",
    "Shadow Wing Focus Staff#Caster Dps#All Ranks\n",
    "Taut Dragonhide Belt#Rogue/Feral Druid#All Ranks\n",
    "T2 Gloves#Class Specific#Raider\n",
    "Styleen's Impeding Scarab#Tank#Loot Council\n",
    "Rejuvenating Gem#All Healers#Core Raider \n",
    "Circle of Applied Force#Fury Prot>Feral Druid>Rogue#Raider\n",
    "Drake Talon Pauldrons#Warrior Fury#Raider\n",
    "Dragon's Touch#Caster Dps#All Ranks\n",
    "Drake Talon Cleaver#Shaman Enh>Paladin Ret>Warrior#All Ranks\n",
    "Emberweave Leggings#Tank FR /Off Tank FR#All Ranks\n",
    "Herald of Woe#Feral Druid#All Ranks\n",
    "Ring of Blackrock#Shaman>Everyone #All Ranks\n",
    "Shadow Wing Focus Staff#Caster Dps#All Ranks\n",
    "Shroud of Pure Thought#Healer#All Ranks\n",
    "Taut Dragonhide Belt#Rogue/Feral Druid#All Ranks\n",
    "T2 Gloves#Class Specific#Raider\n",
    "Elementium Reinforced Bulwark#Warrior Tank#Core Raider \n",
    "Ashjre'thul, Crossbow of Smiting#Hunter#Core Raider \n",
    "Chromatic Boots#Warrior Fury Prot /Warrior Fury#Core Raider \n",
    "Angelista's Grasp#Warlock/Shadow Priest#Raider\n",
    "Chromatically Tempered Sword#Sword Rogue and Dual Fury#Raider\n",
    "Claw of Chromaggus#Caster DPS>Healer#Raider\n",
    "Empowered Leggings#Priest/Druid/Paladin Healer#Raider\n",
    "Elementium Threaded Cloak#Druid Tank#All Ranks\n",
    "Girdle of the Fallen Crusader#Disenchant#All Ranks\n",
    "Primalist's Linked Waistguard#Shaman Elemental#All Ranks\n",
    "Shimmering Geta#Healer#All Ranks\n",
    "Taut Dragonhide Gloves#Druid/Shaman Caster#All Ranks\n",
    "Taut Dragonhide Shoulderpads#Feral Druid >Rogue#All Ranks\n",
    "T2 Shoulder#Class Specific#All Ranks\n",
    "Neltharion's Tear#Caster DPS#Core Raider \n",
    "Lok'amir il Romathis#Caster Dps>Healer#Core Raider \n",
    "Ashkandi, Greatsword of the Brotherhood#2H Fury >Hunter>Ret Pala#Raider\n",
    "Staff of the Shadow Flame#Caster dps#Raider\n",
    "Mish'undare, Circlet of the Mind Flayer#Mages>Paladin Healer>Casters#Raider\n",
    "Boots of the Shadow Flame#Rogue and Dual Fury/Feral Druid/Enh Shaman#Raider\n",
    "Cloak of the Brood Lord#Caster Dps #Raider\n",
    "Crul'shoruk, Edge of Chaos#Dual Fury and orc-Tanks#Raider\n",
    "Prestor's Talisman of Connivery#Rogue / Hunter / Feral Cat #Raider\n",
    "Pure Elementium Band#Healer#Raider\n",
    "Archimtiros' Ring of Reckoning#Tank#All Ranks\n",
    "Therazane's Link#Hunter/Enh Shaman#All Ranks\n",
    "Head of Nefarian#Rogue, Hunter and Warrior#All Ranks\n",
    "T2 Chest#Class Specific#Raider\n",
    "Garb of Royal Ascension#Warlock Shadow Resistance#Aspiring twins tank\n",
    "Gloves of the Immortal#Everyone#All Ranks\n",
    "Neretzek, The Blood Drinker#Everyone#All Ranks\n",
    "Anubisath Warhammer#Non Orc Tank / Dual Fury#All Ranks\n",
    "Ritssyn's Ring of Chaos#Casters Dps#All Ranks\n",
    "Shard of the Fallen Star#Everyone#All Ranks\n",
    "Breastplate of Annihilation#Warrior Fury Only #Raider\n",
    "Boots of the Unwavering Will#Tank#Raider\n",
    "Cloak of Concentrated Hatred#Tank/Fury/Rogue/Ret Paladin/Enh Shaman/Feral#Raider\n",
    "Amulet of Foul Warding#Tank/Melee Dps/Hunters Nature Resistance#All Ranks\n",
    "Barrage Shoulders#Hunter#All Ranks\n",
    "Beetle Scaled Wristguards#Everyone Leather Nature Resistance#All Ranks\n",
    "Boots of the Fallen Prophet#Shaman Enh#All Ranks\n",
    "Hammer of Ji'zhi#Shaman/Paladin / DE#All Ranks\n",
    "Leggings of Immersion#Druid /Shaman Caster#All Ranks\n",
    "Pendant of the Qiraji Guardian#Tank#All Ranks\n",
    "Ring of Swarming Thought#Casters Dps#All Ranks\n",
    "Staff of the Qiraji Prophets#Casters Dps#All Ranks\n",
    "Imperial Qiraji Armaments#Dagger/1h Axe/Shield#Raider\n",
    "Imperial Qiraji Regalia#Hit Staff/Healing Staff/Feral Mace#Raider\n",
    "Ukko's Ring of Darkness#Warlock Shadow Resistance#Aspiring twins tank\n",
    "Boots of the Fallen Hero#Warrior Fury Prot/Fury #Raider\n",
    "Ternary Mantle#Priest Healer Prio #Raider\n",
    "Angelista's Touch#Tank#Raider\n",
    "Guise of the Devourer#Druid Tank#Raider\n",
    "Mantle of the Desert Crusade#Paladin Holy#Raider\n",
    "Mantle of the Desert's Fury#Shaman Resto Or Elemental#Raider\n",
    "Vest of Swift Execution#Druid Cat/ Feral Tank > Rogue#Raider\n",
    "Angelista's Charm#Healers#All Ranks\n",
    "Bile-Covered Gauntlets#Everyone#All Ranks\n",
    "Cape of the Trinity#Casters Dps#All Ranks\n",
    "Gloves of Ebru#Shaman Elemental / Druid Boomkin#All Ranks\n",
    "Mantle of Phrenic Power#Mage#All Ranks\n",
    "Ooze-ridden Gauntlets#Nature Resist Gear#All Ranks\n",
    "Petrified Scarab#Everyone#All Ranks\n",
    "Ring of the Devoured#Druid /Shaman Caster#All Ranks\n",
    "Robes of the Triumvirate#Casters/Healers Nature Resistance#All Ranks\n",
    "Triad Girdle#Warrior Fury/Paladin Ret#All Ranks\n",
    "Wand of Qiraji Nobility#Casters Dps#Raider\n",
    "Imperial Qiraji Armaments#Dagger/1h Axe/Shield#Raider\n",
    "Imperial Qiraji Regalia#Hit Staff/Healing Staff/Feral Mace#Raider\n",
    "Sartura's Might#Priests/Druids > Shamans/Pallies (who get shields)#Core Raider \n",
    "Creeping Vine Helm#Paladin/Shamn/Druid Heal#Raider\n",
    "Gauntlets of Steadfast Determination#Tank#Raider\n",
    "Badge of the Swarmguard#Fury/Rogue/Hunter/Druid Feral/Enh Shaman#Raider\n",
    "Gloves of Enforcement#Rogue/Feral Cat/Enh Shaman#Raider\n",
    "Leggings of the Festering Swarm#Mage#Raider\n",
    "Silithid Claw#Hunter#Raider\n",
    "Thick Qirajihide Belt#Druid Tank#Raider\n",
    "Necklace of Purity#Everyone#All Ranks\n",
    "Recomposed Boots#Caster/Healer Nature Resistance#All Ranks\n",
    "Robes of the Battleguard#Casters Dps#All Ranks\n",
    "Scaled Leggings of Qiraji Fury#Shaman Elemental#All Ranks\n",
    "Imperial Qiraji Armaments#Dagger/1h Axe/Shield#Raider\n",
    "Imperial Qiraji Regalia#Hit Staff/Healing Staff/Feral Mace#Raider\n",
    "Cloak of Untold Secrets#Warlock Shadow Resistance#Aspiring twins tank\n",
    "Fetish of the Sand Reaver#Casters with threat problems#Raider\n",
    "Ancient Qiraji Ripper#Rogue Sword  Prio#Core Raider \n",
    "Barb of the Sand Reaver#Hunter#Raider\n",
    "Barbed Choker#Warrior Fury/Shaman Enh/Rogue/Pala Ret#Raider\n",
    "Totem of Life#Shaman Resto#Raider\n",
    "Hive Tunneler's Boots#Druid Tank#Raider\n",
    "Mantle of Wicked Revenge#Druid Tank#Raider\n",
    "Pauldrons of the Unrelenting#Warrior Tank#Raider\n",
    "Robes of the Guardian Saint#Healer Druid/Shaman/Paladin#Raider\n",
    "Scaled Sand Reaver Leggings#Shaman Enh #Raider\n",
    "Libram of Grace#Paladin Healer#All Ranks\n",
    "Silithid Carapace Chestguard#WarriorTank,Fury /Paladin Ret#All Ranks\n",
    "Imperial Qiraji Armaments#Dagger/1h Axe/Shield#Raider\n",
    "Imperial Qiraji Regalia#Hit Staff/Healing Staff/ 1H Feral Mace#Raider\n",
    "Sharpened Silithid Femur#Caster Dps#Core Raider \n",
    "Ring of the Qiraji Fury#Warrior Fury/Shaman Enh/Rogue/Pala Ret#Raider\n",
    "Gauntlets of Kalimdor#Shaman#All Ranks\n",
    "Gauntlets of the Righteous Champion#Ret Paladin#All Ranks\n",
    "Idol of Health#Druid#All Ranks\n",
    "Scarab Brooch#Healers#All Ranks\n",
    "Slime-coated Leggings#Shaman Enh#All Ranks\n",
    "Imperial Qiraji Armaments#Dagger/1h Axe/Shield#Raider\n",
    "Imperial Qiraji Regalia#Hit Staff/Healing Staff/Feral Mace#Raider\n",
    "Qiraji Bindings of Command#T 2.5 Shoulders & Boots#Raider\n",
    "Qiraji Bindings of Dominance#T 2.5 Shoulders & Boots#Raider\n",
    "Ring of the Martyr#Healers#Core Raider \n",
    "Cloak of the Golden Hive#Tank#Raider\n",
    "Hive Defiler Wristguards#Warrior Fury/Paladin Ret#Raider\n",
    "Wasphide Gauntlets#Druid/Shaman Resto#Raider\n",
    "Gloves of the Messiah#All Healers#All Ranks\n",
    "Huhuran's Stinger#Rogue#All Ranks\n",
    "Imperial Qiraji Armaments#Dagger/1h Axe/Shield#Raider\n",
    "Imperial Qiraji Regalia#Hit Staff/Healing Staff/Feral Mace#Raider\n",
    "Qiraji Bindings of Command#T 2.5 Shoulders & Boots#Raider\n",
    "Qiraji Bindings of Dominance#T 2.5 Shoulders & Boots#Raider\n",
    "Amulet of Vek'nilash#Caster Dps#Core Raider \n",
    "Royal Scepter of Vek'lor#Warlock / Mage#Core Raider \n",
    "Kalimdor's Revenge#Ret Paladin / 2H Fury#Raider\n",
    "Regenerating Belt of Vek'nilash#Paladin/Druid / Shaman Resto#Raider\n",
    "Belt of the Fallen Emperor#Paladin Healer#Raider\n",
    "Boots of Epiphany#Shadiw Priest >Caster Dps#Raider\n",
    "Bracelets of Royal Redemption#Priest/h pala/trees > 5/5 t2.5 + 3/8 t2 shaman/moonglow druids (which don't benefit from 8/9 t3)#Raider\n",
    "Gloves of the Hidden Temple#Feral Druid#Raider\n",
    "Qiraji Execution Bracers#Feral Druid > Enh Shaman#Raider\n",
    "Vek'lor's Gloves of Devastation#Shaman Enh#Raider\n",
    "Ring of Emperor Vek'lor#Bear Tank > Tank (armour count)#Raider\n",
    "Royal Qiraji Belt#Tank#Raider\n",
    "Grasp of the Fallen Emperor#Shaman Elemental#All Ranks\n",
    "Imperial Qiraji Armaments#Dagger/1h Axe/Shield#Raider\n",
    "Imperial Qiraji Regalia#Hit Staff/Healing Staff/Feral Mace#Raider\n",
    "Vek'lor's Diadem#T 2.5 Helm#Raider\n",
    "Vek'nilash's Circlet#T 2.5 Helm#Raider\n",
    "Jom Gabbar#Fury , Ret, Shaman Rogue and Hunter#Raider\n",
    "Don Rigoberto's Lost Hat#All Healers#Raider\n",
    "Burrower Bracers#Qurv > Caster DPS #Raider\n",
    "Larvae of the Great Worm#Hunter#Raider\n",
    "Wormscale Blocker#Shaman / Paladin Healers#Raider\n",
    "The Burrower's Shell#Everyone#All Ranks\n",
    "Imperial Qiraji Armaments#Dagger/1h Axe/Shield#Raider\n",
    "Imperial Qiraji Regalia#Hit Staff/Healing Staff/Feral Mace#Raider\n",
    "Ouro's Intact Hide#T 2.5 Legs#Raider\n",
    "Skin of the Great Sandworm#T 2.5 Legs#Raider\n",
    "Dark Edge of Insanity#Loot Council - prio to PvP enjoyers#Loot Council\n",
    "Belt of Never-ending Agony#Rogue/feral druid (Cat or bear) > enh shaman#Core Raider \n",
    "Cloak of Clarity#All Healers#Raider\n",
    "Cloak of the Devoured#Caster Dps#Core Raider \n",
    "Dark Storm Gauntlets#Caster DPS (usually lock > mage but check hit%)#Raider\n",
    "Death's Sting#Rogue Dagger#Core Raider \n",
    "Eyestalk Waist Cord#Caster DPS#Core Raider \n",
    "Gauntlets of Annihilation#Fury Warrior/Tank> Paladin Ret#Core Raider \n",
    "Grasp of the Old God#Priest Healer Prio #Core Raider \n",
    "Mark of C'Thun#Tank#Core Raider \n",
    "Ring of the Godslayer#Hunter#Core Raider \n",
    "Scepter of the False Prophet#Healers #Core Raider \n",
    "Vanquished Tentacle of C'Thun#Everyone#All Ranks\n",
    "Yshgo'lar, Cowl of Fanatical Devotion#Mage/Warlock#Core Raider \n",
    "Remnants of an Old God#Rogue#Raider\n",
    "Eye of C'Thun#Fury Tank/Caster Dps/Healers/Hunters#Core Raider \n",
    "Carapace of the Old God#T 2.5 Chest#Raider\n",
    "Husk of the Old God#T 2.5 Chest#Raider\n",
    "Ghoul Skin Tunic#Feral Cat/Druid / Shaman Enh > Fury Warrior#All Ranks\n",
    "Girdle of Elemental Fury#Elemental Shaman#All Ranks\n",
    "Harbinger of Doom#Dagger Rogue / Hunter#All Ranks\n",
    "Leggings of Elemental Fury#Elemental Shaman#All Ranks\n",
    "Misplaced Servo Arm#Dual Fury Warrior / Rogue#All Ranks\n",
    "Necro-Knight's Garb#Shadow Priest > Mage = Warlock#All Ranks\n",
    "Pauldrons of Elemental Fury#Elemental Shaman#All Ranks\n",
    "Ring of the Eternal Flame#Mage#All Ranks\n",
    "Stygian Buckler#Everyone#\n",
    "Band of Unanswered Prayers#Healer#Raider\n",
    "Cryptfiend Silk Cloak#Tank#Raider\n",
    "Gem of Nerubis#Caster DPS#Raider\n",
    "Touch of Frost#Everyone Cold Resistance#Raider\n",
    "Wristguards of Vengeance#Furry Warrior/Ret Paladin#Raider\n",
    "Desecrated Bindings#Warlock / Priest / Mage#Raider\n",
    "Desecrated Wristguards#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Bracers#Tank>Rogue#Raider\n",
    "Icebane Pauldrons#Plate Warrior / Ret Frost Resistance#Raider\n",
    "Malice Stone Pendant#Caster DPS#Raider\n",
    "Polar Shoulder Pads#Rogue#Raider\n",
    "The Widow's Embrace#Healer#Core Raider \n",
    "Widow's Remorse#Human Warr Tank/Tanks at hit cap > Dual Human Warr Fury > Sword Rogue#Core Raider \n",
    "Desecrated Bindings#Priest > Mage/Lock (have better options)#Raider\n",
    "Desecrated Wristguards#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Bracers#Tank>Rogue#Raider\n",
    "Crystal Webbed Robe#Shadow priest > Mage = Warlock#Raider\n",
    "Kiss of the Spider#Fury Warrior / Rogue / Enh Shaman / Ret Paladin#Core Raider \n",
    "Maexxna's Fang#Dagger Rogue#Raider\n",
    "Pendant of Forgotten Names#Healers#Raider\n",
    "Wraith Blade#Mage = Warlock#Core Raider \n",
    "Desecrated Gloves#Warlock / Priest#Raider\n",
    "Desecrated Handguards#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Gauntlets#Tank>Rogue#Raider\n",
    "Band of Reanimation#Hunter#Raider\n",
    "Cloak of Suturing#Healer#Core Raider \n",
    "Severance#Enh Shaman / 2H Fury Warrior#Raider\n",
    "The Plague Bearer#Tank#Core Raider \n",
    "Wand of Fates#Warlock = Shadow priest > Mage#Core Raider \n",
    "Desecrated Shoulderpads#Warlock / Priest > mages #Raider\n",
    "Desecrated Spaulders#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Pauldrons#Tank>Rogue#Raider\n",
    "Glacial Mantle#Caster/Healer Frost Resistance#Raider\n",
    "Icy Scale Spaulders#Warrior/Hunter/Enh Shaman #Raider\n",
    "Midnight Haze#Caster DPS#Raider\n",
    "The End of Dreams#Shadow priest#Raider\n",
    "Toxin Injector#Hunter / Rogue / Furry Warrior#Raider\n",
    "Desecrated Shoulderpads#Warlock / Priest#Raider\n",
    "Desecrated Spaulders#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Pauldrons#Tank>Rogue#Raider\n",
    "Claymore of Unholy Might#2H Fury Warrior / Hunter#Raider\n",
    "Death's Bargain#Paladin Healers > Shaman Healers#Core Raider \n",
    "Digested Hand of Power#Priest / Druid Healers#Raider\n",
    "Gluth's Missing Collar#Tank#Raider\n",
    "Rime Covered Mantle#Shadow priest = Mage > Warlock#Core Raider \n",
    "Desecrated Shoulderpads#Warlock / Priest#Raider\n",
    "Desecrated Spaulders#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Pauldrons#Tank>Rogue#Raider\n",
    "Desecrated Bindings#Warlock / Priest / Mage#Raider\n",
    "Desecrated Wristguards#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Bracers#Tank>Rogue#Raider\n",
    "Desecrated Sandals#Warlock / Priest / Mage#Raider\n",
    "Desecrated Boots#Hunter / Shaman / Druid#Raider\n",
    "Desecrated Sabatons#Tank > Rogue#Raider\n",
    "Desecrated Belt#Warlock / Priest / Mage#Raider\n",
    "Desecrated Girdle#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Waistguard#Tank > Rogue#Raider\n",
    "Eye of Diminution#Warlock = Mage#Core Raider \n",
    "Leggings of Polarity#Mage = Warlock > Shadow priest#Core Raider \n",
    "Plated Abomination Ribcage#Fury Warrior#Raider\n",
    "The Castigator#Non Orc - Dual Fury /Tank#Raider\n",
    "Spire of Twilight#Priest / Druid Healers#Raider\n",
    "Desecrated Circlet#Mage / Warlock / Priest#Raider\n",
    "Desecrated Headpiece#Hunter / Shaman / Druid /Paladin#Raider\n",
    "Desecrated Helmet#Tank > Rogue#Raider\n",
    "Band of the Inevitable#Warlock = Shadow priest > Mage#Core Raider \n",
    "Cloak of the Scourge#Warrior/Rogue/Enh Shaman/Ret Paladin#Raider\n",
    "Hailstone Band#Tank#Raider\n",
    "Hatchet of Sundered Bone#Orc dual wield warrior > dual wield warrior #Raider\n",
    "Noth's Frigid Heart#Priest / Druid Healers (pally/sham take shield)#Core Raider \n",
    "Totem of Flowing Water#Shaman Resto#Raider\n",
    "Desecrated Belt#Warlock / Priest / Mage#Raider\n",
    "Desecrated Girdle#Hunter / Shaman / Druid /Paladin#Raider\n",
    "Desecrated Waistguard#Tank > Rogue#Raider\n",
    "Icebane Helmet#Warrior Frost Resistance#Raider\n",
    "Icy Scale Coif#Hunter / Warrior Fury#Raider\n",
    "Legplates of Carnage#2 Hand Fury Warrior#Raider\n",
    "Necklace of Necropsy#Healer Without Cthun Neck > Healers with#Core Raider \n",
    "Preceptor's Hat#Shadow priest > Mage = Warlock#Core Raider \n",
    "Desecrated Belt#Warlock / Priest / Mage#Raider\n",
    "Desecrated Girdle#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Waistguard#Tank > Rogue#Raider\n",
    "Band of Unnatural Forces#Warrior Fury/Rogue/Enh/Ret/Hunter#Core Raider \n",
    "Brimstone Staff#Mage = Warlock > Shadow priest#Core Raider \n",
    "Loatheb's Reflection#Everyone#Raider\n",
    "Ring of Spiritual Fervor#Healer Druid/Shaman/Paladin#Raider\n",
    "The Eye of Nerub#Hunter / Druid #Raider\n",
    "Desecrated Leggings#Warlock / Priest > Mage#Raider\n",
    "Desecrated Legguards#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Legplates#Tank > Rogue#Raider\n",
    "Girdle of the Mentor#Warrior Fury/Tank / Ret Paladin#Core Raider \n",
    "Iblis, Blade of the Fallen Seraph#Sword Rogue/Dual Wield Fury > Tanks#Core Raider \n",
    "Idol of Longevity#Druid#Raider\n",
    "Signet of the Fallen Defender#Druid Tank Prio (MS or wannabe bear - many better rings for warriors)#Raider\n",
    "Veil of Eclipse#Caster DPS#Raider\n",
    "Wand of the Whispering Dead#Priest Healer#Raider\n",
    "Desecrated Sandals#Warlock / Priest / Mage#Raider\n",
    "Desecrated Boots#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Sabatons#Tank > Rogue#Raider\n",
    "Boots of Displacement#Rogue/bear tanks needing dodge#Raider\n",
    "Glacial Headdress#Caster DPS / Healers#Raider\n",
    "Polar Helmet#Rogue#Raider\n",
    "Sadist's Collar#Rogue / Fury / Hunter / Enh Shaman / Ret Pala#Raider\n",
    "The Soul Harvester's Bindings#Mage > Warlock > Shadow priest#Core Raider \n",
    "Desecrated Sandals#Warlock / Priest / Mage#Raider\n",
    "Desecrated Boots#Hunter / Shaman / Druid / Paladin#Raider\n",
    "Desecrated Sabatons#Tank > Rogue#Raider\n",
    "Corrupted Ashbringer#Ret Paladin > Warrior 2H Fury#Core Raider \n",
    "Leggings of Apocalypse#Feral/Enh Shaman > Rogue (t3 legs better/same)#Core Raider \n",
    "Maul of the Redeemed Crusader#Shaman Enh#Raider\n",
    "Seal of the Damned#Mage = Warlock > Shadow priest#Raider\n",
    "Soulstring#Hunter / Rogue / Fury#Raider\n",
    "Warmth of Forgiveness#Healer#Raider\n",
    "Desecrated Robe#Mage / Warlock / Priest#Core Raider \n",
    "Desecrated Tunic#Hunter / Shaman / Druid #Core Raider \n",
    "Desecrated Breastplate#MT prio > Tank > Rogue#Core Raider \n",
    "Claw of the Frost Wyrm#Hunter > Dual Fury Warrior#Raider\n",
    "Cloak of the Necropolis#Mage = Warlock > Shadow priest#Core Raider \n",
    "Eye of the Dead#Healer#Core Raider \n",
    "Glyph of Deflection#Tank#Core Raider \n",
    "Sapphiron's Left Eye#Mage = Warlock > Shadow priest#Core Raider \n",
    "Sapphiron's Right Eye#Druid / Priest Healers#Core Raider \n",
    "Shroud of Dominion#Rogue / Fury Warrior / Shaman Enh / Feral Cat#Core Raider \n",
    "Slayer's Crest#Rogue / Hunter / Fury Warrior / Shaman Enh /Cat/Ret Pala#Core Raider \n",
    "The Face of Death#Tank#Core Raider \n",
    "The Restrained Essence of Sapphiron#Shadow priest > Caster DPS#Core Raider \n",
    "Fortitude of the Scourge##Core Raider \n",
    "Power of the Scourge#Mage = Warlock > Shadow priest#Core Raider \n",
    "Might of the Scourge##Core Raider \n",
    "Resilience of the Scourge##Core Raider \n",
    "Doomfinger#Mage > Warlock > Shadow priest#Core Raider \n",
    "Gem of Trapped Innocents#Mage = Warlock > Shadow priest#Core Raider \n",
    "Gressil, Dawn of Ruin#Dual Fury Warrior / Rogue > Tank#Core Raider \n",
    "Hammer of the Twisting Nether#Healer#Core Raider \n",
    "Kingsfall#Dagger Rogue > Hunter#Core Raider \n",
    "Might of Menethil#Warrior 2H Furry > Shaman Enh/ Ret Paladin#Core Raider \n",
    "Nerubian Slavemaker#Hunter#Core Raider \n",
    "Shield of Condemnation#Shaman / Paladin Healers#Core Raider \n",
    "Soulseeker#Mage = Warlock > Shadow priest#Raider\n",
    "Stormrage's Talisman of Seething#Rogue / Hunter / Fury Warrior / Shaman Enh /Feral Cat#Core Raider \n",
    "The Hungering Cold#Tanks without weapon skill > Dual Fury Warrior/Rogue#Core Raider \n",
    "The Phylactery of Kel'Thuzad##Core Raider \n",
    "Mark of the Champion#DPS#Core Raider \n",
    "Mark of the Champion#Caster DPS#Core Raider \n",
    "Ring - Bonescythe#Rogue#Core Raider \n",
    "Ring - Cryptstalker#Hunter#Core Raider \n",
    "Ring - Dreadnaught#Tank#Core Raider \n",
    "Ring - Dreamwalker#Druid#Core Raider \n",
    "Ring - Earthshatterer#Shaman#Core Raider \n",
    "Ring - Faith#Priest#Core Raider \n",
    "Ring - Frostfire#Mage#Core Raider \n",
    "Ring - Plagueheart#Warlock#All Ranks\n",
    "Claw of Erennius#Quest turn in -  healer one hand > cat polearm > bear polearm > hunter/rogue fist weapon#\n",
    "Jadestone Skewer#Naxx attunement required#Raider\n",
    "Jadestone Mallet#Naxx attunement required#Raider\n",
    "Claw of Senthos#Naxx attunement required#Raider\n",
    "Head of Solnius#DPS > feral tank> all else#\n",
    "Ring of Nordrassil#Naxx attunement required#Raider\n",
    "The Heart of Dreams#Naxx attunement required#Raider\n",
    " Verdant Eye Necklace#Naxx attunement required#Raider\n",
    "Robe of the Dreamways#Caster DPS#Raider\n",
    "Sandals of Lucidity#Caster DPS#Raider\n",
    "Talonwind Gauntlets#Everyone#Raider\n",
    "Ancient Jade Leggings#Everyone#Raider\n",
    "Sanctum Bark Wraps#Everyone#Raider\n",
    "Mantle of the Wakener#Everyone#Raider\n",
    "Jadestone Helmet#Everyone#Raider\n",
    "Mallet of the Awakening#Everyone#Raider\n",
    "Scaleshield of Emerald Flight#Non stance swapping tanks#Raider\n",
    "Axe of Dormant Slumber#Orc fury warr prio#Raider\n",
    "Staff of the Dreamer#Healer#Raider\n",
    "Ring of Nature's Duality#Healer#Raider\n",
    "Shard of Nightmare#caster dps#Raider\n",
    "Veil of Nightmare#Melee dps#Raider\n",
    "Libram of the Dreamguard#Everyone#Raider\n",
    "Totem of the Stonebreaker#Everyone#Raider\n",
    "Idol of the Emerald Rot#Everyone#Raider\n",
    "Naturecaller's Tunic#Boomkin = ele > caster dps#Raider\n",
    "Choker of the Emerald Lord#Ret pally >#Raider\n",
    "Breath of Solnius#Everyone#Core Raider \n",
    "Crystal Sword of the Blossom#Everyone#Raider\n",
    "Nature's Call#Hunters>tank stat stick#Raider\n",
    "Jadestone Protector#Everyone#Raider\n",
    "Bag of Vast Conscious#Everyone#Raider\n",
}


-- ##########
-- # LAYOUT #
-- ##########

local function WindowLayout(window)
    window:SetBackdrop({bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background'})
    window:SetBackdropColor(0.2, 0.2, 0.2, 1)
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
    btn:SetBackdropColor(0, 0, 0, 1)
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

local function GetLootMaster()
    local loot_method, loot_master_id_party, loot_master_id_raid = GetLootMethod()
    if (loot_method == "master") then
        if loot_master_id_raid then
            if loot_master_id_raid == 0 then
                return UnitName("player")
            else
                return UnitName("raid"..loot_master_id_raid)
            end
        elseif loot_master_id_party then
            if loot_master_id_party == 0 then
                return UnitName("player")
            else
                return UnitName("party"..loot_master_id_party)
            end
        end
    else
        return ""
    end
end

local function GetItemStringFromItemlink(item_link)
    local _,_,item_string = string.find(item_link, "|H(.-)|h") -- extracts item string from link
    -- local printable = string.gsub(item_link, "\124", "\124\124"); -- makes item_link printable
    -- print("Here's what it really looks like: \"" .. printable .. "\"");
    return item_string
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

-- Thunderfury, Blessed Blade of the Windseeker#Warrior Fury#All Ranks
local function ParseLootSpreadsheet(text, data_ss) -- data from spreadsheet
    text = text..'\n' -- add \n so last line will be matched as well
    local pattern = '(.-)#(.-)#(.-)\n' -- modifier - gets 0 or more repetitions and matches the shortest sequence
    ResetData(data_ss)
    for item, prio, rank in string.gfind(text, pattern) do
        data_ss[item] = rank.." -> "..prio
        if config.item_translate_table[item] then -- Translate Spreadsheet if needed
            for _, item_translate in pairs(config.item_translate_table[item]) do
                data_ss[item_translate] = rank.." -> "..prio
            end
        end
    end
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

        -- if ((item_rarity > config.max_rarity) and LootSlotIsItem(idx_loot)) or item_filter then -- if rarity>=min and not gold
        if ((item_rarity > config.max_rarity) and item_quantity>0 and (not item_is_autolooted)) or item_is_rolled then -- if item_quantity=0 for gold; cloth maybe isnt a LootSlotItem, idk -> Test that
            local item_link = GetLootSlotLink(idx_loot) or ""
            local item_ss = data_ss[item_name] or ""
            local item_sr = ""
            if data_sr[item_name] then
                for _, player_name in pairs(data_sr[item_name]) do
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

window.button_sr = CreateFrame("Button", nil, window) -- Soft Reserve
ButtonLayout(window, window.button_sr, "SR", "Import SR", 0, 0, config.button_width, config.button_height)
window.import_sr = CreateFrame("EditBox", nil, UIParent)
EditBoxLayout(window, window.import_sr)

window.button_ss = CreateFrame("Button", nil, window) -- Loot Spreadsheet
ButtonLayout(window, window.button_ss, "SS", "Import Spreadsheet", config.button_width, 0, config.button_width, config.button_height)
window.import_ss = CreateFrame("EditBox", nil, UIParent)
EditBoxLayout(window, window.import_ss)

window.button_if = CreateFrame("Button", nil, window) -- Item Filter
ButtonLayout(window, window.button_if, "IF", "Import Item Filter (a/r#w/e#item: a..autoloot, r..roll, w..wildcard, e..exact)", 2*config.button_width, 0, config.button_width, config.button_height)
window.import_if = CreateFrame("EditBox", nil, UIParent)
EditBoxLayout(window, window.import_if)

window.button_ar = CreateFrame("Button", nil, window) -- Autoloot Rarity
window.button_ar.sub = {}
ButtonLayout(window, window.button_ar, config.rarities[config.max_rarity], "Select Autoloot Rarity", 3*config.button_width, 0, config.button_rarity_width, config.button_rarity_height)
for idx_rarity=-1,4 do
    local idx_rarity_f = idx_rarity
    local txt_rarity_f = config.rarities[idx_rarity_f]
    window.button_ar.sub[idx_rarity_f] = CreateFrame("Button", nil, window)
    ButtonLayout(window.button_ar, window.button_ar.sub[idx_rarity_f], txt_rarity_f, "Select Autoloot Rarity", 0, (idx_rarity_f+2)*config.button_rarity_height, config.button_rarity_width, config.button_rarity_height)
    
    window.button_ar.sub[idx_rarity_f]:SetScript("OnClick", function()
        config.max_rarity = idx_rarity_f
        window.button_ar.text:SetText(txt_rarity_f)
        for idx_btn, _ in pairs(config.rarities) do
            window.button_ar.sub[idx_btn]:Hide()
        end
    end)
    window.button_ar.sub[idx_rarity_f]:Hide()
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
    --     for _, player in pairs(data_sr[item]) do
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
window.import_ss:SetText(config.text_ss)
ParseLootSpreadsheet(config.text_ss, data_ss)

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
ParseItemFilter(config.text_if, data_if)

window.button_ar:SetScript("OnClick", function()
    for idx_rarity,_ in pairs(config.rarities) do
        if window.button_ar.sub[idx_rarity]:IsShown() then
            window.button_ar.sub[idx_rarity]:Hide()
        else
            window.button_ar.sub[idx_rarity]:Show()
        end
    end
end)

-- #######################
-- # ONUPDATE AND EVENTS #
-- #######################

window:RegisterEvent("LOOT_OPENED")
-- window:RegisterEvent("PLAYER_DEAD")
-- window:RegisterEvent("CHAT_MSG_PARTY")
-- window:RegisterEvent("CHAT_MSG_RAID_LEADER")
-- window:RegisterEvent("CHAT_MSG_RAID_WARNING")
window:SetScript("OnEvent", function()
    if UnitName("player")==GetLootMaster() then
        ShowLoot(data_sr, data_ss, data_if)
    end
end)


-- ###############
-- # Fun Machine #
-- ###############

-- local fun_machine =  CreateFrame("Frame", nil, UIParent)
-- local fun_machine_enabled = false
-- local fun_machine_cd = 5*60
-- local joke_machine_pattern ="tell me a joke, captain"
-- local joke_machine_punchline = nil
-- local joke_machine_punchline_delay = 5
-- local motivator_machine_pattern ="motivate me, captain"
-- local joke_machine = {{"A blind man walks into a bar.", "And a table. And a chair."},
--     {"What do wooden whales eat?", "Plankton"},
--     {"Two fish in a tank, one says to the other", "\"You man the guns, I'll drive!\""},
--     {"Two soldiers are in a tank, one says to the other", "\"BLURGBLBLURG!\""},
--     {"What do you call an alligator in a vest", "An Investigator"},
--     {"How many tickles does it take to get an octopus to laugh?", "Ten-tickles!"},
--     {"Did you hear about the midget fortune teller who kills his customers?", "He's a small medium at large"},
--     {"What's the best time to go to the dentist?", "2:30"},
--     {"Yo mama so fat, when she was interviewed on Channel 6 news", "you could see her sides on the channels 5 and 7"},
--     {"Yo mama so fat, i swerved to miss her in my car", "and ran out of gas"},
--     {"How many push ups can Chuck Norris do?", "All of them"},
--     {"How did the hacker get away from the police?", "He ransomware"},
--     {"I met a genie once. He gave me one wish. I said \"I wish i could be you\"", "the genie replued \"weurd wush but u wull grant ut\""},
--     {"i bought my daughter a refrigerator for her birthday", "i cant wait to see her face light up when she opens it"},
--     {"a call comes in to 911 \"come quick, my friend was bitten by a wolf!\", operator:\"Where?\"", "\"no, a regular one\""},
--     {"Did you hear about the french cheese factory explosion?", "da brie was everywhere"},
--     {"why do germans store their cheese together with their sausage?", "they're prepared for a wurst-kase scenario"},
--     {"why did the aztec owl not know what the other owls were saying to each other?", "they were inca hoots"}
-- }
-- local motivator_machine = {"It's never too late to give up",
--     "This is the worst day of my life",
--     "Don't follow your friends off a bridge; lead them",
--     "Just because you're special, doesn't mean you're useful",
--     "No one is as dumb as all of us together",
--     "It may be that the purpose of your life is to serve as a warning for others",
--     "If you ever feel alone, don't",
--     "Give up on your dreams and die",
--     "Trying is the first step to failure",
--     "Make sure to drink water so you can stay hydrated while you suffer",
--     "The Nail that sticks out gets hammered down",
--     "I got an ant farm. They didn't grow shit",
--     "They don't think it be like it is but it do",
--     "If Id agreed with you we'd both be wrong",
--     "Tutant meenage neetle teetle",
--     "When you want win but you receive lose",
--     "Get two birds stoned at once",
--     "Osteoporosis sucks",
--     "Success is just failure that hasn't happened yet",
--     "Never underestimate the power of stupid people in large groups",
--     "I hate everyone equally",
--     "Only dread one day at a time",
--     "Hope is the first step on the road to disappointment",
--     "The beatings will continue until morale improves",
--     "It's always darkest just before it goes pitch black",
--     "When you do bad, no one will forget",
--     "Life's a bitch, then you die",
--     "You suck",
--     "Fuck you",
--     "Not even Noah's ark can carry you, animals",
--     "Your mother buys you Mega Bloks instead of Legos",
--     "You look like you cut your hair with a knife and fork",
--     "You all reek of poverty and animal abuse",
--     "Your garden is overgrown and your cucumbers are soft"
-- }

-- fun_machine:SetScript("OnUpdate", function()
--     if not fun_machine.clock_machine then fun_machine.clock_machine = GetTime() end
--     if GetTime() > fun_machine.clock_machine + fun_machine_cd then
--         fun_machine_enabled = true
--         fun_machine.clock_machine = GetTime()
--     end
--     if not fun_machine.clock_punchline then fun_machine.clock_punchline = GetTime() end
--     if (GetTime() > fun_machine.clock_punchline) and joke_machine_punchline then
--         SendChatMessage(joke_machine_punchline, "RAID_WARNING", nil, nil)
--         joke_machine_punchline = nil
--     end
-- end)
-- fun_machine:RegisterEvent("CHAT_MSG_RAID")
-- fun_machine:RegisterEvent("CHAT_MSG_PARTY")
-- -- fun_machine:RegisterEvent("CHAT_MSG_RAID_LEADER")
-- fun_machine:SetScript("OnEvent", function()
--     if IsRaidLeader() then
--         if fun_machine_enabled then
--             for _ in string.gfind(arg1, joke_machine_pattern) do
--                 local idx = math.random(1, GetTableLength(joke_machine))
--                 SendChatMessage(joke_machine[idx][1] , "RAID_WARNING", nil, nil)
--                 joke_machine_punchline = joke_machine[idx][2]
--                 fun_machine.clock_machine = GetTime()
--                 fun_machine.clock_punchline = GetTime()+joke_machine_punchline_delay
--                 fun_machine_enabled = false
--             end
--         end
--         if fun_machine_enabled then
--             for _ in string.gfind(arg1, motivator_machine_pattern) do
--                 local idx = math.random(1, GetTableLength(motivator_machine))
--                 SendChatMessage(motivator_machine[idx] , "RAID_WARNING", nil, nil)
--                 fun_machine.clock_machine = GetTime()
--                 fun_machine_enabled = false
--             end
--         end
--     end
-- end)

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
18814,"Splintered Tusk",Ragnaros,Kikidora,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Splintered Tusk",Ragnaros,Bibbley,Warlock,Destruction,,"04/02/2024, 14:55:41"
18814,"Splintered Tusk",Ragnaros,Test,Warlock,Destruction,,"04/02/2024, 14:55:41"
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