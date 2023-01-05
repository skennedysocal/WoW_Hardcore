local _G = _G
local of_forgotten_memories = CreateFrame("Frame")
_G.passive_achievements.OfForgottenMemories = of_forgotten_memories

-- General info
of_forgotten_memories.name = "OfForgottenMemories"
of_forgotten_memories.title = "of Forgotten Memories"
of_forgotten_memories.class = "All"
of_forgotten_memories.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_of_forgotten_memories.blp"
of_forgotten_memories.level_cap = 57
of_forgotten_memories.quest_num = 5781
of_forgotten_memories.description =
	"Awarded if player completes the `of Forgotten Memories` quest before reaching level " .. of_forgotten_memories.level_cap .. "."
of_forgotten_memories.restricted_game_versions = {
	["WotLK"] = 1,
}

-- Registers
function of_forgotten_memories:Register(succeed_function_executor)
	of_forgotten_memories:RegisterEvent("QUEST_TURNED_IN")
	of_forgotten_memories.succeed_function_executor = succeed_function_executor 
end

function of_forgotten_memories:Unregister()
	of_forgotten_memories:UnregisterEvent("QUEST_TURNED_IN")
end

-- Register Definitions
of_forgotten_memories:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	if event == "QUEST_TURNED_IN" then
		if arg[1] == of_forgotten_memories.quest_num and UnitLevel("player") <= of_forgotten_memories.level_cap then
			Hardcore:Print("Congrats! You have achieved " .. of_forgotten_memories.title)
			of_forgotten_memories.succeed_function_executor.Succeed(of_forgotten_memories.name)
		end
	end
end)
