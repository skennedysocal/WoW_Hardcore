local _G = _G
local homebound_achievement = CreateFrame("Frame")
_G.achievements.Homebound = homebound_achievement

local kalimdor_zones = {
	"Ashenvale",
	"Desolace",
	"Azshara",
	"The Barrens",
	"Dustwallow Marsh",
	"Un'Goro Crater",
	"Feralas",
	"Tanaris",
	"Onyxia's Lair",
	"Winterspring",
	"Felwood",
	"Stonetalon Mountains",
	"Moonglade",
	"Thousand Needles",
	"Silithus",
	"Darkshore",
	"Mulgore",
	"Durotar",
	"Teldrassil",
	"The Veiled Sea",
	"Caverns of Time",
}
local eastern_kingdoms_zones = {
	"Alterac Mountains",
	"Strangethorn Vale",
	"Hillsbrad Foothills",
	"The Hinterlands",
	"Searing Gorge",
	"Badlands",
	"Arathi Highlands",
	"Blasted Lands",
	"Duskwood",
	"Swamp of Sorrows",
	"Western Plaguelands",
	"Eastern Plaguelands",
	"Wetlands",
	"Burning Steppes",
	"Wetlands",
	"Redridge Mountains",
	"Silverpine Forest",
	"Loch Modan",
	"Tirisfal Glades",
	"Blackrock Mountain",
	"Deadwind Pass",
	"Dun Morogh",
	"Elwynn Forest",
}

-- General info
homebound_achievement.name = "Homebound"
homebound_achievement.title = "Homebound"
homebound_achievement.class = "All"
homebound_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_homebound.blp"
homebound_achievement.description =
	"Complete the Hardcore challenge without at any point leaving the continent on which your character has started. If you started in Kalimdor, you may at no point enter the Eastern Kingdoms. If you started in the Eastern Kingdoms, you may at no point enter Kalimdor."

-- Registers
function homebound_achievement:Register(fail_function_executor)
	homebound_achievement:RegisterEvent("ZONE_CHANGED")
	homebound_achievement.fail_function_executor = fail_function_executor
end

function homebound_achievement:Unregister()
	homebound_achievement:UnregisterEvent("ZONE_CHANGED")
end

-- Register Definitions
homebound_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	if event == "ZONE_CHANGED" then
		local current_zone = GetZoneText()
		local _, race_english = UnitRace("player")
		if
			race_english == "Human"
			or race_english == "Undead"
			or race_english == "Dwarf"
			or race_english == "Gnome"
		then
			for i, bad_zone in ipairs(kalimdor_zones) do
				if bad_zone == current_zone then
					Hardcore:Print("Detected entering zone " .. current_zone .. ".")
					homebound_achievement.fail_function_executor.Fail(homebound_achievement.name)
				end
			end
		end

		if
			race_english == "Orc"
			or race_english == "Night Elf"
			or race_english == "Tauren"
			or race_english == "Troll"
		then
			for i, bad_zone in ipairs(eastern_kingdoms_zones) do
				if bad_zone == current_zone then
					Hardcore:Print("Detected entering zone " .. current_zone .. ".")
					homebound_achievement.fail_function_executor.Fail(homebound_achievement.name)
				end
			end
		end
	end
end)
