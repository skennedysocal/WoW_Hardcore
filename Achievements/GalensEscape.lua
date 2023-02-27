local _G = _G
local _achievement = CreateFrame("Frame")
_G.passive_achievements.GalensEscape = _achievement

-- General info
_achievement.name = "GalensEscape"
_achievement.title = "Galen's Escape"
_achievement.class = "All"
_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_galens_escape.blp"
_achievement.level_cap = 38
_achievement.quest_num = 1393
_achievement.quest_name = "Galen's Escape"
_achievement.zone = "Swamp of Sorrows"
_achievement.bl_text = "Swamp of Sorrows Quest"
_achievement.pts = 10 
_achievement.description = HCGeneratePassiveAchievementBasicQuestDescription(_achievement.quest_name, _achievement.zone, _achievement.level_cap)
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
	HCCommonPassiveAchievementBasicQuestCheck(_achievement, event, arg)
end)
