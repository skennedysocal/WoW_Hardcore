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

other_hardcore_character_cache = {} -- dict of player name & server to character data
