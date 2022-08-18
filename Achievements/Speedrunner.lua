local _G = _G
local speedrunner_achievement = CreateFrame("Frame")
_G.achievements.Speedrunner = speedrunner_achievement

local in_game_limit_seconds = 100 * 60 * 60 -- seconds
local irl_time_limit = 8 * 7 * 24 * 60 * 60 -- 4838400 seconds
local max_num_xp_bars = 1.0 --

-- General info
speedrunner_achievement.name = "Speedrunner"
speedrunner_achievement.title = "Speedrunner"
speedrunner_achievement.class = "All"
speedrunner_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_speedrunner.blp"
speedrunner_achievement.description =
	"Complete the Hardcore challenge in less than 100 hours (4 days and 4 hours) of played time. Make sure to show your /played time when you hit 60. The run must be completed within eight weeks of real time. You are NOT allowed to log off in rested areas."

-- Registers
function speedrunner_achievement:Register(fail_function_executor, _hardcore_character)
	speedrunner_achievement.fail_function_executor = fail_function_executor
	if _hardcore_character.first_recorded == nil or _hardcore_character.first_recorded == -1 then
		Hardcore:Print("Could not register for Speedrunner achievement; invalid creation time")
		speedrunner_achievement.fail_function_executor = fail_function_executor
		return
	elseif GetServerTime() - _hardcore_character.first_recorded > irl_time_limit then
		Hardcore:Print("Exceeded IRL time limit of 8 weeks.")
		speedrunner_achievement.fail_function_executor.Fail(speedrunner_achievement.name)
	end

	if GetXPExhaustion() ~= nil then 
	  local num_xp_bars = (GetXPExhaustion() / UnitXPMax("player")) * 20
	  if num_xp_bars > max_num_xp_bars then
		  Hardcore:Print("Exceeded max rested xp bubble limit of 1.")
		  speedrunner_achievement.fail_function_executor.Fail(speedrunner_achievement.name)
	  end
	end
	RequestTimePlayed()
	speedrunner_achievement:RegisterEvent("PLAYER_LEVEL_UP")
	speedrunner_achievement:RegisterEvent("TIME_PLAYED_MSG")
end

function speedrunner_achievement:Unregister()
	speedrunner_achievement:UnregisterEvent("PLAYER_LEVEL_UP")
	speedrunner_achievement:UnregisterEvent("TIME_PLAYED_MSG")
end

-- Register Definitions
speedrunner_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	if event == "PLAYER_LEVEL_UP" then
		RequestTimePlayed()
	elseif event == "TIME_PLAYED_MSG" then
		local seconds_played = arg[1]
		if seconds_played > in_game_limit_seconds then
			Hardcore:Print("Exceeded game time limit of 100 hours.")
			speedrunner_achievement.fail_function_executor.Fail(speedrunner_achievement.name)
		end
	end
end)
