local _G = _G
local grounded_achievement = CreateFrame("Frame")
_G.achievements.Grounded = grounded_achievement

-- Todo{Add portal detection}

-- General info
grounded_achievement.name = "Grounded"
grounded_achievement.title = "Grounded"
grounded_achievement.class = "All"
grounded_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_grounded.blp"
grounded_achievement.description =
	"Complete the Hardcore challenge without at any point using a mount, flight path, or portal. Zeppelins and ships can be used."

-- Registers
function grounded_achievement:Register(fail_function_executor)
	grounded_achievement:RegisterEvent("PLAYER_CONTROL_LOST")
	grounded_achievement:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	grounded_achievement.fail_function_executor = fail_function_executor
end

function grounded_achievement:Unregister()
	grounded_achievement:UnregisterEvent("PLAYER_CONTROL_LOST")
	grounded_achievement:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
end

-- Register Definitions
grounded_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	if event == "PLAYER_CONTROL_LOST" then
		C_Timer.After(5, function()
			if UnitOnTaxi("player") then
				Hardcore:Print("Player is on taxi")
				grounded_achievement.fail_function_executor.Fail(grounded_achievement.name)
			end
		end)
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		if IsMounted() then
			Hardcore:Print("Player is on mount")
			grounded_achievement.fail_function_executor.Fail(grounded_achievement.name)
		end
	end
end)
