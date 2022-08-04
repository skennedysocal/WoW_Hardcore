local _G = _G
local king_of_the_jungle_achievement = CreateFrame("Frame")
_G.achievements.KingOfTheJungle = king_of_the_jungle_achievement

-- General info
king_of_the_jungle_achievement.name = "KingOfTheJungle"
king_of_the_jungle_achievement.title = "King of the Jungle"
king_of_the_jungle_achievement.class = "All"
king_of_the_jungle_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_king_of_the_jungle.blp"
king_of_the_jungle_achievement.description =
	"Complete the Hardcore challenge after killing King Bangalash and having completed the Big Game Hunter quest before reaching level 40."

-- Registers
function king_of_the_jungle_achievement:Register(fail_function_executor)
	king_of_the_jungle_achievement:RegisterEvent("PLAYER_LEVEL_UP")
	king_of_the_jungle_achievement.fail_function_executor = fail_function_executor
end

function king_of_the_jungle_achievement:Unregister()
	king_of_the_jungle_achievement:UnregisterEvent("PLAYER_LEVEL_UP")
	king_of_the_jungle_achievement.fail_function_executor = nil
end

-- Register Definitions
king_of_the_jungle_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	if event == "PLAYER_LEVEL_UP" then
		if arg[1] > 39 then
			if C_QuestLog.IsQuestFlaggedCompleted(208) == false then -- 208 = big game hunter
				Hardcore:Print("Did not complete Big Game Hunter by level 40.")
				king_of_the_jungle_achievement.fail_function_executor.Fail(king_of_the_jungle_achievement.name)
			end
		end
	end
end)
