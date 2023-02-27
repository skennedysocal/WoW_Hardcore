local _G = _G
local _achievement = CreateFrame("Frame")
_G.passive_achievements.TestOfEndurance = _achievement

-- General info
_achievement.name = "TestOfEndurance"
_achievement.title = "Army of the Harpies"
_achievement.class = "All"
_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_test_of_endurance.blp"
_achievement.level_cap = 30
_achievement.quest_num = 1150
_achievement.quest_name = "Test of Endurance"
_achievement.zone = "Thousand Needles"
_achievement.kill_target = "Grenka Bloodscreech"
_achievement.faction = "Horde"
_achievement.bl_text = "Thousand Needles Quest"
_achievement.pts = 10 
_achievement.description = HCGeneratePassiveAchievementKillDescription(_achievement.kill_target, _achievement.quest_name, _achievement.zone, _achievement.level_cap, "Horde")
_achievement.restricted_game_versions = {
	["WotLK"] = 1,
}

-- Registers
function _achievement:Register(succeed_function_executor)
	_achievement:RegisterEvent("QUEST_TURNED_IN")
	_achievement.succeed_function_executor = succeed_function_executor 
end

function _achievement:Unregister()
	_achievement:UnregisterEvent("QUEST_TURNED_IN")
end

-- Register Definitions
_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	HCCommonPassiveAchievementKillCheck(_achievement, event, arg)
end)
