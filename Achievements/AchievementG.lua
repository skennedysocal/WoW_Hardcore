local _G = _G
_G.achievements = {}
_G.achievements_order = {}
_G.extra_rules = {}
_G.a_id = {
	AnimalFriend = 1,
	Arcanist = 2,
	Berserker = 3,
	Bloodbath = 4,
	CloseCombat = 5,
	Cyromancer = 6,
	DruidOfTheClaw = 7,
	Ephemeral = 8,
	Felfire = 9,
	Grounded = 10,
	Hammertime = 11,
	Homebound = 12,
	Humanist = 13,
	ICanSeeYou = 14,
	ImpMaster = 15,
	KingOfTheJungle = 16,
	LoneWolf = 17,
	MortalPet = 18,
	Naturalist = 19,
	NobodyGotTimeForThat = 20,
	NoHealthPotions = 21,
	NotSoDeadly = 22,
	NotSoTalented = 23,
	NotTheBlessedRun = 24,
	NoWayOut = 25,
	Nudist = 26,
	Pacifist = 27,
	PowerFromWithin = 28,
	Pyromancer = 29,
	SelfMade = 30,
	ShadowEmbrace = 31,
	Shivved = 32,
	Shocked = 33,
	SolitaryStruggle = 34,
	Speedrunner = 35,
	SwordAndBoard = 36,
	Thunderstruck = 37,
	TiedHands = 38,
	TotemicMisery = 39,
	TrueBeliever = 40,
	TunnelVision = 41,
	Unrestored = 42,
	Vagrant = 43,
	VoidServant = 44,
	WhiteKnight = 45,
	Scavenger = 46,
	InsaneInTheMembrane = 47,
	PartnerUp = 48,
	NoHit = 49,
}
_G.id_a = {}
for k, v in pairs(_G.a_id) do
	_G.id_a[tostring(v)] = k
end

for k in pairs(_G.a_id) do
	table.insert(_G.achievements_order, k)
end
table.sort(_G.achievements_order)

_G.passive_achievements = {}
_G.passive_achievements_order = {}
_G.pa_id = {
	KingOfTheJungle = 1,
	ShyRotam = 2,
	OfForgottenMemories = 3,
	Maltorious = 4,
	PawnCapturesQueen = 5,
	Deathclasp = 6,
	AFinalBlow = 7,
	SummoningThePrincess = 8,
	AbsentMindedProspector = 9,
	TheHuntCompleted = 10,
	MageSummoner = 11,
	EarthenArise = 12,
	GetMeOutOfHere = 13,
	RitesOfTheEarthmother = 14,
	KimjaelIndeed = 15,
	Counterattack = 16,
	StinkysEscape = 17,
	DarkHeart = 18,
	AgainstLordShalzaru = 19,
	TestOfEndurance = 20,
	CuergosGold = 21,
	TheStonesThatBindUs = 22,
	GalensEscape = 23,
	Morladim = 24,
	TheForgottenHeirloom = 25,
	Hogger = 26,
	Fangore = 27,
	DragonkinMenace = 28,
	SealOfEarth = 29,
	TremorsOfEarth = 30,
	Vagash = 31,
	InDefenseOfTheKing = 32,
	DefeatNekrosh = 33,
	DruidOfTheClawQuest = 34,
	TheCrownOfWill = 35,
	BattleOfHillsbrad = 36,
	TheWeaver = 37,
	TheFamilyCrypt = 38,
	HintsOfANewPlague = 39,
	RecoverTheKey = 40,
}
_G.id_pa = {}
for k, v in pairs(_G.pa_id) do
	_G.id_pa[tostring(v)] = k
end

for k in pairs(_G.pa_id) do
	table.insert(_G.passive_achievements_order, k)
end

-- sort function from stack overflow
local function spairs(t, order)
	local keys = {}
	for k in pairs(t) do
		keys[#keys + 1] = k
	end

	if order then
		table.sort(keys, function(a, b)
			return order(t, a, b)
		end)
	else
		table.sort(keys)
	end

	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

local sort_functions = {
	["Level"] = function(t, a, b)
		return _G.passive_achievements[t[a]].level_cap < _G.passive_achievements[t[b]].level_cap
	end,
}

function reorderPassiveAchievements()
  local order = {}
  for i, v in spairs(_G.passive_achievements_order, sort_functions["Level"]) do
	table.insert(order, v)
  end
  _G.passive_achievements_order = order
end

other_hardcore_character_cache = {} -- dict of player name & server to character data
