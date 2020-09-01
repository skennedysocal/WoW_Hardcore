--[[
Copyright 2020 Sean Kennedy
The Hardcore AddOn is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Hardcore.

The Hardcore AddOn is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The Hardcore AddOn is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the Hardcore AddOn. If not, see <http://www.gnu.org/licenses/>.
--]]

--[[ Global variables ]]--
Hardcore_Settings = {
	version = "0.2.3",
	enabled = true,
	notify = true,
	death_list = {}
}

--[[ Local variables ]]--
local debug = false
local update_count = 0
local Last_Attack_Source = nil
local PLAYER_NAME, _ = UnitName("player")
local CTL = _G.ChatThrottleLib
local COMM_NAME = "HardcoreAddon"
local COMM_UPDATE_BREAK = 4
local COMM_DELAY = 5
local COMM_BATCH_SIZE = 4
local COMM_COMMAND_DELIM = "$"
local COMM_FIELD_DELIM = "|"
local COMM_RECORD_DELIM = "^"
local COMM_COMMANDS = {"SYNC", "ADD", "UPDATE"}
local HARDCORE_REALMS = {"Bloodsail Buccaneers", "Hydraxian Waterlords"}
local GENDER_GREETING = {"guildmate", "brother", "sister"}
local Hardcore = CreateFrame("Frame", "Hardcore")
local SendAddonSuccess = C_ChatInfo.RegisterAddonMessagePrefix(COMM_NAME)

--[[ Command line handler ]]--

local function SlashHandler(msg, editbox)
	local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

	if cmd == "list" then
		Hardcore:List()
	elseif cmd == "enable" then
		Hardcore:Enable(true)
	elseif cmd == "disable" then
		Hardcore:Enable(false)
	elseif cmd == "show" then
		Hardcore_Frame:Show()
	elseif cmd == "hide" then
		Hardcore_Frame:Hide()
	elseif cmd == "debug" then
		debug = not debug
		Hardcore:Print("Debugging set to "..tostring(debug))
	elseif cmd == "notify" then
		Hardcore_Settings.notify = not Hardcore_Settings.notify
		if true == Hardcore_Settings.notify then
			Hardcore:Print("Notification enabled")
		else
			Hardcore:Print("Notification disabled")
		end
	elseif cmd == "sync" then
		if CTL then
			CTL:SendAddonMessage("NORMAL", COMM_NAME, COMM_COMMANDS[1]..COMM_COMMAND_DELIM, "GUILD")
		end
	else
		-- If not handled above, display some sort of help message
		Hardcore:Print("|cff00ff00Syntax:|r/hardcore [command]")
		Hardcore:Print("|cff00ff00Commands:|rlist enable disable show hide")
	end
end

SLASH_HARDCORE1, SLASH_HARDCORE2 = '/hardcore', '/hc'
SlashCmdList["HARDCORE"] = SlashHandler

--[[ Startup ]]--

function Hardcore:Startup()
	self:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

--[[ Events ]]--

function Hardcore:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	-- Register
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_UNGHOST")
	self:RegisterEvent("PLAYER_DEAD")
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("PLAYER_LEAVING_WORLD")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("MAIL_SHOW")
	self:RegisterEvent("AUCTION_HOUSE_SHOW")

	-- Disable addon if not in one of the offical hardcore realms
	Hardcore_Settings.enabled = false
	local realmName = GetRealmName()
	for k, v in pairs(HARDCORE_REALMS) do
		if v == realmName then
			Hardcore:Debug("Player realm, "..v..", is a hardcore server, enabling addon")
			Hardcore_Settings.enabled = true
			break
		end
	end

	if Hardcore_Settings.enabled == true then
		Hardcore:Print("Hardcore mode enabled, monitoring for death")
	else
		Hardcore:Print("Hardcore mode disabled, not monitoring for death")
		return
	end

	PLAYER_NAME, _ = UnitName("player")

	-- Send sync command to addon
	if SendAddonSuccess then
		if CTL then
			CTL:SendAddonMessage("NORMAL", COMM_NAME, COMM_COMMANDS[1]..COMM_COMMAND_DELIM, "GUILD")
		end
	end

	-- Show recording reminder
	Hardcore:RecordReminder()
end

function Hardcore:PLAYER_LEAVING_WORLD()
	self:UnregisterEvent("ADDON_LOADED")
	self:UnregisterEvent("PLAYER_UNGHOST")
	self:UnregisterEvent("PLAYER_DEAD")
	self:UnregisterEvent("CHAT_MSG_ADDON")
	self:UnregisterEvent("PLAYER_LEAVING_WORLD")
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("MAIL_SHOW")
	self:UnregisterEvent("AUCTION_HOUSE_SHOW")

	Hardcore:CleanData()
end

function Hardcore:ADDON_LOADED()
	-- Hardcore:Sort("tod")
end

function Hardcore:PLAYER_DEAD()
	if Hardcore_Settings.enabled == false then return end

	-- Get information
	local playerId = UnitGUID("player")
	local playerName, realmName = UnitName("player")
	local localizedClass, englishClass = UnitClass("player")
	local playerLevel = UnitLevel("player")
	local mapId = C_Map.GetBestMapForUnit("player")
	local mapName = C_Map.GetMapInfo(mapId).name
	local playerGreet = GENDER_GREETING[UnitSex("player")]

	-- Send message to guild
	local messageFormat = "Our brave %s, %s the %s, has died at level %d in %s"
	local messageString = string.format(messageFormat, playerGreet, playerName, localizedClass, playerLevel, mapName)
	if not (Last_Attack_Source == nil) then
		messageString = string.format("%s to a %s", messageString, Last_Attack_Source)
		Last_Attack_Source = nil
	end
	SendChatMessage(messageString, "GUILD", nil, nil)

	-- Send add command to addon for this death
	if true == SendAddonSuccess then
		local deathData = string.format("%s%s%s%s%s%s%s%s%s%s%s",
										playerId,
										COMM_FIELD_DELIM,
										playerName,
										COMM_FIELD_DELIM,
										localizedClass,
										COMM_FIELD_DELIM,
										playerLevel,
										COMM_FIELD_DELIM,
										mapId,
										COMM_FIELD_DELIM,
										time())

		local commMessage = COMM_COMMANDS[2]..COMM_COMMAND_DELIM..deathData
		if CTL then
			CTL:SendAddonMessage("BULK", COMM_NAME, commMessage, "GUILD")
		end
	end
end

function Hardcore:PLAYER_UNGHOST()
	if Hardcore_Settings.enabled == false then return end
	if UnitIsDeadOrGhost("player") == 1 then return end -- prevent message on ghost login or zone

	local playerName, _ = UnitName("player")
	local message = playerName.." has resurrected!"
	SendChatMessage(message, "GUILD", nil, nil)

	-- Screen notification
	Hardcore_Notification_Text:SetText(message)
	Hardcore_Notification_Frame:Show()
	PlaySound(8959)
	C_Timer.After(COMM_DELAY, function()
		Hardcore_Notification_Frame:Hide()
	end)
end

function Hardcore:MAIL_SHOW()
	if Hardcore_Settings.enabled == false then return end

	CloseMail()
end

function Hardcore:AUCTION_HOUSE_SHOW()
	if Hardcore_Settings.enabled == false then return end

	CloseAuctionHouse()
end

function Hardcore:CHAT_MSG_ADDON(prefix, datastr, scope, sender)
	if Hardcore_Settings.enabled == false then return end

	-- Ignore messages that are not ours
	if COMM_NAME == prefix then
		-- Get the command
		local command, data = string.split(COMM_COMMAND_DELIM, datastr)

		-- Determine what command was sent
		if command == COMM_COMMANDS[1] then
			Hardcore:Sync()
		elseif command == COMM_COMMANDS[2] then
			Hardcore:Add(data)
		elseif command == COMM_COMMANDS[3] then
			Hardcore:Update(data)
		else
			Hardcore:Debug("Unknown command :"..command)
		end
	end
end

function Hardcore:COMBAT_LOG_EVENT_UNFILTERED(...)
	-- local time, token, hidding, source_serial, source_name, caster_flags, caster_flags2, target_serial, target_name, target_flags, target_flags2, ability_id, ability_name, ability_type, extraSpellID, extraSpellName, extraSchool = CombatLogGetCurrentEventInfo()
	local _, _, _, _, source_name, _, _, _, _, _, _, _, _, _, _, _, _ = CombatLogGetCurrentEventInfo()

	if not (source_name == PLAYER_NAME) then
		if not (source_name == nil) then
			Last_Attack_Source = source_name
		end
	end
end

--[[ Utility Methods ]]--

function Hardcore:Print(msg)
	print("|cffed9121Hardcore|r: "..(msg or ""))
end

function Hardcore:Debug(msg)
	if true == debug then
		print("|cfffd9122HCDebug|r: "..(msg or ""))
	end
end

function Hardcore:Sync()
	if SendAddonSuccess then
		-- Don't send empty lists
		if 0 == #Hardcore_Settings.death_list then
			Hardcore:Debug("No records to sync")
			return
		end

		-- IMPORTANT NOTE: There is a max of 250 characters per message, so break into chunks.
		Hardcore:Debug("Syncing "..tostring(#Hardcore_Settings.death_list).." records")

		-- Build list of all deaths we have seen and broadcast chunks
		local sent = 0
		local data = ""
		for index = 1, #Hardcore_Settings.death_list do
			if 0 == index % COMM_BATCH_SIZE then
				Hardcore:Debug("Sending batch of "..COMM_BATCH_SIZE.." records")
				if CTL then
					CTL:SendAddonMessage("BULK", COMM_NAME, COMM_COMMANDS[3]..COMM_COMMAND_DELIM..data, "GUILD")
				end
				data = ""
				sent = sent + COMM_BATCH_SIZE
			else
				data = data..Hardcore_Settings.death_list[index]..COMM_RECORD_DELIM
			end
		end

		-- Broadcast the remaining records
		data = ""
		for index = sent + 1, #Hardcore_Settings.death_list do
			data = data..Hardcore_Settings.death_list[index]..COMM_RECORD_DELIM
		end
		Hardcore:Debug("Sending remaining "..tostring(#Hardcore_Settings.death_list - sent).." records")
		if CTL then
			CTL:SendAddonMessage("BULK", COMM_NAME, COMM_COMMANDS[3]..COMM_COMMAND_DELIM..data, "GUILD")
		end
	end
end

function Hardcore:Add(data)
	for i=1, #Hardcore_Settings.death_list do
		if Hardcore_Settings.death_list[i] == data then
			Hardcore:Debug("Not adding duplicate record "..data)
			return
		end
	 end

	 -- Add the record if needed
	 if true == Hardcore:ValidateEntry(data) then
		Hardcore:Debug("Adding new record "..data)
		table.insert(Hardcore_Settings.death_list, data)

		-- Display the death locally
		local _, name, class_name, level, map_id, _ = string.split(COMM_FIELD_DELIM, data)
		local class_color = Hardcore:GetClassColorText(class_name)
		local map_name = C_Map.GetMapInfo(tonumber(map_id)).name
		local messageFormat = "%s the %s%s|r has died at level %d in %s"
		local messageString = string.format(messageFormat, name, class_color, class_name, level, map_name)

		Hardcore_Notification_Text:SetText(messageString)
		Hardcore_Notification_Frame:Show()
		PlaySound(8959)
		C_Timer.After(COMM_DELAY, function()
			Hardcore_Notification_Frame:Hide()
		end)
	end
end

function Hardcore:Update(data)
	function Hardcore:Update(data)
		-- Check if we want this update
		update_count = update_count + 1
		if not (0 == update_count % COMM_UPDATE_BREAK) then
			return
		end

		-- Parse out the death rows
		local rows = {}
		for entry in string.gmatch(data, "[^"..COMM_RECORD_DELIM.."]+") do
			table.insert(rows, entry)
		end
		if 0 == #rows then
			return
		else
			-- Hardcore:Debug("Update received "..tostring(#rows).." rows of data")
		end

		-- Update local table with missing data
		for index = 1, #rows do
			local rowNeeded = true
			for i=1, #Hardcore_Settings.death_list do
				if Hardcore_Settings.death_list[i] == rows[index] then 
				   rowNeeded = false
				   -- Hardcore:Debug("Row exists, not adding "..string.split(COMM_FIELD_DELIM, rows[index]))
				end
			 end

			 if rowNeeded == true then
				Hardcore:Debug("Adding new row for "..string.split(COMM_FIELD_DELIM, rows[index]))
				-- Throttle inserts to help with lag
				C_Timer.After(COMM_DELAY, function()
					table.insert(Hardcore_Settings.death_list, rows[index]) 
				end)
			 end
		end

		-- Update the UI
		if #Hardcore_Settings.death_list > 0 then
			Hardcore_SubTitle:SetText("We honor the "..tostring(#Hardcore_Settings.death_list).." who have fallen")
			Hardcore_Deathlist_ScrollBar_Update()
		end
	end
end

function Hardcore:Enable(setting)
	-- Check if we are attempting to set the existing state
	if Hardcore_Settings.enabled == setting then
		if setting == false then
			Hardcore:Print("Already disabled")
		else
			Hardcore:Print("Already enabled")
		end

		return
	end

	Hardcore_Settings.enabled = setting
	if setting == false then
		Hardcore:Print("Disabled")
	else
		Hardcore:Print("Enabled")
	end
end

function Hardcore:List()
	if 0 == #Hardcore_Settings.death_list then
		Hardcore:Print("No deaths recorded")
		return
	end

	Hardcore:Print("List of deaths:")
	Hardcore:Print("\n")
	Hardcore:Print("|cff00ff00Name            Class     Level Location            Time")
	for index = 1, #Hardcore_Settings.death_list do
		local row = Hardcore:FormatRow(Hardcore_Settings.death_list[index])
		if row then
			Hardcore:Print(row)
		end
	end
end

function Hardcore:FormatRow(row, fullcolor)
	local row_str = ""

	if false == Hardcore:ValidateEntry(row) then return nil end

	local _, name, classname, level, mapId, tod = string.split(COMM_FIELD_DELIM, row)
	local mapName = C_Map.GetMapInfo(mapId).name
	local color = Hardcore:GetClassColorText(classname)
	if fullcolor then
		row_str = string.format("%s%-17s%-10s%-10s%-25s%-s|r", color, name, classname, level, mapName, date("%Y-%m-%d %H:%M:%S", tod))
	else
		row_str = string.format("%-17s%s%-10s|r%-10s%-25s%-s", name, color, classname, level, mapName, date("%Y-%m-%d %H:%M:%S", tod))
	end

	return row_str
end

function Hardcore:GetValue(row, value)
	local playerid, name, classname, level, mapid, tod = string.split(COMM_FIELD_DELIM, row)
	if "playerid" == value then
		return playerid
	elseif "class" == value then
		return classname
	elseif "name" == value then
		return name
	elseif "level" == value then
		return level
	elseif "zone" == value then
		return mapid
	elseif "tod" == value then
		return tod
	else
		-- Default to returning everything
		return playerid, name, classname, level, mapid, tod
	end

	return nil
end

function Hardcore:GetClassColorText(classname)
	if "Druid" == classname then
		return "|c00ff7d0a"
	elseif "Hunter" == classname then
		return "|c00a9d271"
	elseif "Mage" == classname then
		return "|c0040c7eb"
	elseif "Paladin" == classname then
		return "|c00f58cba"
	elseif "Priest" == classname then
		return "|c00ffffff"
	elseif "Rogue" == classname then
		return "|c00fff569"
	elseif "Shaman" == classname then
		return "|c000070de"
	elseif "Warlock" == classname then
		return "|c008787ed"
	elseif "Warrior" == classname then
		return "|c00c79c6e"
	end

	Hardcore:Debug("ERROR: classname not found")
	return "|c00c41f3b" -- Red
end

function Hardcore:ValidateEntry(data)
	local playerId, name, classname, level, mapId, tod = string.split(COMM_FIELD_DELIM, data)

	if nil == playerId then
		Hardcore:Debug("ERROR: 'playerId' field is nil")
		return false
	end

	if nil == name then
		Hardcore:Debug("ERROR: 'name' field is nil")
		return false
	end

	if nil == classname then
		Hardcore:Debug("ERROR: 'class' field is nil")
		return false
	end

	if nil == level then
		Hardcore:Debug("ERROR: 'level' field is nil")
		return false
	elseif 1 == tonumber(level) then
		Hardcore:Debug("WARN: Ignoring level 1 death")
		return false
	end

	if nil == mapId then
		Hardcore:Debug("ERROR: 'mapId' field is nil")
		return false
	end

	if nil == tod then
		Hardcore:Debug("ERROR: 'tod' field is nil")
		return false
	end

	return true
end

function Hardcore:CleanData()
	local new_list = {}

	for index = 1, #Hardcore_Settings.death_list do
		local valid = Hardcore:ValidateEntry(Hardcore_Settings.death_list[index])
		if true == valid then table.insert(new_list, Hardcore_Settings.death_list[index]) end
	end

	Hardcore_Settings.death_list = new_list
end

function Hardcore:DeDupe()
	local list, dup, c, NaN = {}, {}, 1, {}
	for i=1, #Hardcore_Settings.death_list do
	  local e = Hardcore_Settings.death_list[i]
	  local k = e~=e and NaN or e
	  if k~=nil and not dup[k] then
		c, list[c], dup[k]= c+1, e, true
	  end
	end

	Hardcore_Settings.death_list = list
end

function Hardcore:Sort(column)
	Hardcore:CleanData()
	Hardcore:DeDupe()
	table.sort(Hardcore_Settings.death_list, function(a, b)
		local first = Hardcore:GetValue(a, column)
		local second = Hardcore:GetValue(b, column)

		if "playerid" == column then
			return string.lower(first) < string.lower(second)
		elseif "name" == column then
			return string.lower(first) < string.lower(second)
		elseif "class" == column then
			return string.lower(first) < string.lower(second)
		elseif "level" == column then
			return tonumber(first) < tonumber(second)
		elseif "zone" == column then
			return tonumber(first) < tonumber(second)
		elseif "tod" == column then
			return tonumber(first) < tonumber(second)
		end
	end)
end

--[[ UI Methods ]]--

function Hardcore_Frame_OnLoad()
	Hardcore_Deathlist_ScrollBar_Update()
end

function Hardcore_Frame_OnShow()
	if #Hardcore_Settings.death_list > 0 then
		Hardcore_SubTitle:SetText("We honor the "..tostring(#Hardcore_Settings.death_list).." who have fallen")
	end
	Hardcore_Deathlist_ScrollBar_Update()
end

function Hardcore_Deathlist_ScrollBar_Update()
	local lineplusoffset
	FauxScrollFrame_Update(MyModScrollBar, #Hardcore_Settings.death_list, 20, 16)
	for line=1, 20 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(MyModScrollBar)
		local button = getglobal("DeathListEntry"..line)
		if lineplusoffset <= #Hardcore_Settings.death_list then
			local row = Hardcore:FormatRow(Hardcore_Settings.death_list[lineplusoffset], true)
			if row then
				button:SetText(row)
				button:Show()
			else
				button:Hide()
			end
		else
			button:Hide()
		end
	end
end

function Hardcore:RecordReminder()
	if Hardcore_Settings.enabled == false then return end
	if Hardcore_Settings.notify == false then return end

	Hardcore_Notification_Text:SetText("Hardcore Reminder:\n START RECORDING")
	Hardcore_Notification_Frame:Show()
	PlaySound(8959)
	C_Timer.After(10, function()
		Hardcore_Notification_Frame:Hide()
	end)
end

--[[ Start Addon ]]--
Hardcore:Startup()
