local _G = _G
local _achievement = CreateFrame("Frame")
_G.passive_achievements.Tainted = _achievement


local dungeon_kill_trigger = {
  ["Ragefire Chasm"] = "Bazzalan",
  ["The Deadmines"] = "Edwin VanCleef",
  ["Wailing Caverns"] = "Lord Serpentis",
  ["Shadowfang Keep"] = "Archmage Arugal",
  ["Blackfathon Deeps"] = "Aku'mai",
  ["Stockades"] = "Dextren Ward",
  ["Razorfin Kraul"] = "Charlga Razorflank",
  ["Gnomeregan"] = "Mekgineer Thermaplugg",
  ["Razorfen Downs"] = "Amnennar the Coldbringer",
  ["Scarlet Monastery: Graveyard"] = "Bloodmage Thalnos",
  ["Scarlet Monastery: Library"] = "Herod",
  ["Scarlet Monastery: Cathedral"] = "High Inquisitor Whitemane",
  ["Uldaman"] = "Archaedas",
  ["Zul'Farrak"] = "Sergeant Bly",
  ["Maraudon"] = "Princess Theradras",
  ["Sunken Temple"] = "Shade of Eranikus",
  ["Blackrock Depths"] = "Princess Moira Bronzebeard",
  ["Lower Blackrock Spire"] = "Overlord Wyrmthalak",
  ["Upper Blackrock Spire"] = "General Drakkisath",
  ["Scholomance"] = "Darkmaster Gandling",
  ["Dire Maul: East"] = "Alzzin the Wildshaper",
  ["Dire Maul: North"] = "Captain Kromcrush",
  ["Dire Maul: West"] = "Prince Tortheldrin",
  ["Stratholme: Live"] = "Balnazzar",
  ["Stratholme: Undead"] = "Baron Rivendare",
}

-- General info
_achievement.name = "Tainted"
_achievement.title = "Tainted"
_achievement.class = "All"
_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_tainted.blp"
_achievement.level_cap = 59
_achievement.kill_targets = {}
_achievement.category = "Dungeons"
_achievement.description = "Complete 5 dungeons while solo before reaching level 60."
_achievement.restricted_game_versions = {
	["WotLK"] = 1,
}

-- Registers
function _achievement:Register(succeed_function_executor)
	_achievement.succeed_function_executor = succeed_function_executor 
end

function _achievement:Unregister()
end

function _achievement:HandleKillEvent(target_name)
  -- Handle kill event
  -- Check to make sure that all kill targets are killed; if so, award acheivement
end
