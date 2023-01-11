local _G = _G
local _achievement = CreateFrame("Frame")
_G.passive_achievements.SpeedrunnerSixty = _achievement

-- General info
_achievement.name = "SpeedrunnerSixty"
_achievement.title = "Speedrunner (60)"
_achievement.class = "All"
_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_speedrunner.blp"
_achievement.category = "Miscellaneous"
_achievement.level_cap = 60
_achievement.description = "Reach level 60 by x time"
_achievement.restricted_game_versions = {
	["WotLK"] = 1,
}

-- Registers
function _achievement:Register(succeed_function_executor)
	_achievement.succeed_function_executor = succeed_function_executor 
end

function _achievement:Unregister()
end

-- Register Definitions
_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
end)

