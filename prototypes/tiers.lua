-- The tint property is just a backup and a relic
-- Will likely be removed

local tiers = {
	[""] = {
		technology = "logistics",
		tint = util.color("D2B450"),
		fast = false,
		suffix = "transport-belt"
	},
	["fast-"] = {
		technology = "logistics-2",
		tint = util.color("D23C3C"),
		fast = true,
		suffix = "transport-belt"
	},
	["express-"] = {
		technology = "logistics-3",
		tint = util.color("50B4D1"),
		fast = true,
		suffix = "transport-belt"
	}
}

if mods["UltimateBelts"] then
	tiers["ultra-fast-"] = {
		tint = util.color("00B30C"),
		fast = true,
		suffix = "belt"
	}
	tiers["extreme-fast-"] = {
		tint = util.color("E00000"),
		fast = true,
		suffix = "belt"
	}
	tiers["ultra-express-"] = {
		tint = util.color("3604B5"),
		fast = true,
		suffix = "belt"
	}
	tiers["extreme-express-"] = {
		tint = util.color("002BFF"),
		fast = true,
		suffix = "belt"
	}
	tiers["ultimate-"] = {
		tint = util.color("00FFDD"),
		fast = true,
		suffix = "belt"
	}
	tiers["original-ultimate-"] = {
		tint = util.color("00FFDD"),
		fast = true,
		suffix = "belt"
	}
end

return tiers