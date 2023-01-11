local _G = _G
local _achievement = CreateFrame("Frame")
_G.passive_achievements.AgainstLordShalzaru = _achievement

-- General info
_achievement.name = "AgainstLordShalzaru"
_achievement.title = "Death to Shalrazu"
_achievement.class = "All"
_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_against_lord_shalrazu.blp"
_achievement.level_cap = 43
_achievement.quest_num = 2870
_achievement.quest_name = "Against Lord Shalrazu"
_achievement.faction = "Alliance"
_achievement.zone = "Feralas"
_achievement.kill_target = "Lord Shalrazu"
_achievement.description = HCGeneratePassiveAchievementKillDescription(_achievement.kill_target, _achievement.quest_name, _achievement.zone, _achievement.level_cap, "Alliance")
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
