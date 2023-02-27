local _G = _G
local nudist_achievement = CreateFrame("Frame")
_G.achievements.Nudist = nudist_achievement

-- General info
nudist_achievement.name = "Nudist"
nudist_achievement.title = "Nudist"
nudist_achievement.class = "All"
nudist_achievement.pts = 25
nudist_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_nudist.blp"
nudist_achievement.description =
	"Complete the Hardcore challenge naked (no armor, no amulets, no rings, and no trinkets). Weapons, shields, and bags are allowed. Upon logging in, unequip every armor piece."

-- Registers
function nudist_achievement:Register(fail_function_executor)
	nudist_achievement:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	nudist_achievement:RegisterEvent("PLAYER_LEVEL_UP")
	nudist_achievement.fail_function_executor = fail_function_executor
end

function nudist_achievement:Unregister()
	nudist_achievement:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
	nudist_achievement:UnregisterEvent("PLAYER_LEVEL_UP")
end

-- Register Definitions
nudist_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	if event == "PLAYER_EQUIPMENT_CHANGED" then
		if arg[1] > 1 and arg[1] < 16 then -- 1 ammo, 16+ weapons
			if arg[2] ~= true then
				nudist_achievement.fail_function_executor.Fail(nudist_achievement.name)
			end
		end
	elseif event == "PLAYER_LEVEL_UP" then
		for i = 2, 15 do
			if GetInventoryItemID("player", i) then
				nudist_achievement.fail_function_executor.Fail(nudist_achievement.name)
			end
		end
	end
end)
