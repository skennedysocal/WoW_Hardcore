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
local class_eng, _, _ = UnitClass("player")
if class_eng == "Druid" then
	grounded_achievement.forces = {
		"Naturalist",
	}
end
grounded_achievement.mouse_over_portal = false

-- Registers
function grounded_achievement:Register(fail_function_executor)
	grounded_achievement:RegisterEvent("PLAYER_CONTROL_LOST")
	grounded_achievement:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	grounded_achievement:RegisterEvent("CURSOR_UPDATE")
	grounded_achievement:RegisterEvent("GLOBAL_MOUSE_DOWN")
	grounded_achievement.fail_function_executor = fail_function_executor
	hooksecurefunc(StaticPopupDialogs["CONFIRM_SUMMON"], "OnAccept", function(self, button)
		grounded_achievement.fail_function_executor.Fail(grounded_achievement.name)
	end)
end

function grounded_achievement:Unregister()
	grounded_achievement:UnregisterEvent("PLAYER_CONTROL_LOST")
	grounded_achievement:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	grounded_achievement:UnregisterEvent("CURSOR_UPDATE")
	grounded_achievement:UnregisterEvent("GLOBAL_MOUSE_DOWN")
end

local function isMagePortal(...)
	for i = 1, select("#", ...) do
		local region = select(i, ...)
		if region and region:GetObjectType() == "FontString" then
			local text = region:GetText() -- string or nil
			if text ~= nil then
				if string.find(text, "Portal to") ~= nil then -- e.g. "Portal to Stormwind"
					return true
				else
				end
			end
		end
	end
	return false
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
	elseif event == "CURSOR_UPDATE" then
		C_Timer.After(0.01, function()
			if isMagePortal(GameTooltip:GetRegions()) then
				grounded_achievement.mouse_over_portal = not grounded_achievement.mouse_over_portal
			else
				grounded_achievement.mouse_over_portal = false
			end
		end)
	elseif event == "GLOBAL_MOUSE_DOWN" then
		if arg[1] == "RightButton" then
			if grounded_achievement.mouse_over_portal then
				grounded_achievement.fail_function_executor.Fail(grounded_achievement.name)
			end
		end
	end
end)
