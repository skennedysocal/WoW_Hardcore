function GenerateDKToken(_hardcore_settings, _hardcore_character)
	if _hardcore_settings.dk_token ~= nil then
		Hardcore:Print("DK Token already exists; cannot generate another.")
		return
	end

	_hardcore_settings.dk_token = {
		party_mode = _hardcore_character.party_mode or "?",
		achievements = {},
		team = {},
		first_recorded = _hardcore_character.first_recorded,
		generated_time = GetServerTime(), -- since epoch
	}

	for idx, achievement in ipairs(_hardcore_character.achievements) do
		table.insert(_hardcore_settings.dk_token.achievements, achievement)
	end

	for idx, partner in ipairs(_hardcore_character.team) do
		table.insert(_hardcore_settings.dk_token.team, partner)
	end
	Hardcore:Print("Generated DK Token.")
end

function ApplyDKToken(_hardcore_settings, _hardcore_character)
	if _hardcore_settings.dk_token == nil then
		Hardcore:Print("DK Token does not exist.")
		return
	end

	_hardcore_character.team = {}
	_hardcore_character.party_mode = _hardcore_settings.dk_token.party_mode
	_hardcore_character.first_recorded = _hardcore_settings.dk_token.first_recorded

	for idx, achievement in ipairs(_hardcore_settings.dk_token.achievements) do
		table.insert(_hardcore_character.achievements, achievement)
	end

	for idx, partner in ipairs(_hardcore_settings.dk_token.team) do
		table.insert(_hardcore_character.team, partner)
	end
	Hardcore:Print("DK Token applied.")
	_hardcore_settings.dk_token = nil
end

function CheckForExpiredDKToken(_hardcore_settings)
	if _hardcore_settings.dk_token == nil then
		return
	end

	local current_time = GetServerTime()
	if current_time - _hardcore_settings.dk_token.generated_time > 24 * 60 * 60 then -- one day
		_hardcore_settings.dk_token = nil
		Hardcore:Print("DK Token expired.")
	end
end
