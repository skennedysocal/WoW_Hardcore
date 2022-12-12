local _G = _G
local no_hit_achievement = CreateFrame("Frame")
_G.achievements.NoHit = no_hit_achievement

-- General info
no_hit_achievement.name = "NoHit"
no_hit_achievement.title = "No Hit"
no_hit_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_felfire.blp"
no_hit_achievement.description =
	"[Experimental] Complete the hardcore challenge without taking a point of damage.  Environment damage applies."
no_hit_achievement.class = "All"

-- Registers
function no_hit_achievement:Register(fail_function_executor)
	no_hit_achievement:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	no_hit_achievement.fail_function_executor = fail_function_executor
end

function no_hit_achievement:Unregister()
	no_hit_achievement:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

-- Register Definitions
no_hit_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local combat_log_payload = { CombatLogGetCurrentEventInfo() }
		-- 2: subevent index, 8: dest_guid, 15: amount
		if not (combat_log_payload[8] == nil) then
			if combat_log_payload[8] == UnitGUID("player") then
				if string.find(combat_log_payload[2], "ENVIRONMENTAL_DAMAGE") ~= nil then
					-- 2 holy, 4 fire, 8 nature, 16 frost, 32 shadow, 64 arcane
					if combat_log_payload[13] > 0 then
						print("Failing NoHit Challenge, took " .. combat_log_payload[13] .. " environmental damage")
						no_hit_achievement.fail_function_executor.Fail(no_hit_achievement.name)
					end
				elseif string.find(combat_log_payload[2], "SWING_DAMAGE") ~= nil then
					-- 2 holy, 4 fire, 8 nature, 16 frost, 32 shadow, 64 arcane
					if combat_log_payload[12] > 0 then
						print("Failing NoHit Challenge, took " .. combat_log_payload[12] .. " swing damage")
						no_hit_achievement.fail_function_executor.Fail(no_hit_achievement.name)
					end
				elseif string.find(combat_log_payload[2], "_DAMAGE") ~= nil then
					-- 2 holy, 4 fire, 8 nature, 16 frost, 32 shadow, 64 arcane
					if combat_log_payload[15] > 0 then
						print("Failing NoHit Challenge, took " .. combat_log_payload[15] .. " cast damage")
						no_hit_achievement.fail_function_executor.Fail(no_hit_achievement.name)
					end
				end
			end
		end
	end
end)
