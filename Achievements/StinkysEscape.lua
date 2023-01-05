local _G = _G
local _achievement = CreateFrame("Frame")
_G.passive_achievements.StinkysEscape = _achievement

-- General info
_achievement.name = "StinkysEscape"
_achievement.title = "Stinky's Escape"
_achievement.class = "All"
_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_stinkys_escape.blp"
_achievement.level_cap = 34
_achievement.quest_num = 1270
_achievement.quest_num_alt = 1222
_achievement.description =
	"Complete |cffffff00Stinky's Escape|r before reaching level " .. _achievement.level_cap .. "."
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
	if event == "QUEST_TURNED_IN" then
		if (arg[1] == _achievement.quest_num or arg[1] == quest_num_alt) and UnitLevel("player") <= _achievement.level_cap then
			Hardcore:Print("Congrats! You have achieved " .. _achievement.title)
			_achievement.succeed_function_executor.Succeed(_achievement.name)
		end
	end
end)
