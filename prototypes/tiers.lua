local tiers = {
	[""] = {
		technology = "logistics",
		fast = false,
		suffix = "transport-belt"
	},
	["fast-"] = {
		technology = "logistics-2",
		fast = true,
		suffix = "transport-belt"
	},
	["express-"] = {
		technology = "logistics-3",
		fast = true,
		suffix = "transport-belt"
	}
}

if mods["UltimateBelts"] then
	tiers["ultra-fast-"] = {
		fast = true,
		suffix = "belt"
	}
	tiers["extreme-fast-"] = {
		fast = true,
		suffix = "belt"
	}
	tiers["ultra-express-"] = {
		fast = true,
		suffix = "belt"
	}
	tiers["extreme-express-"] = {
		fast = true,
		suffix = "belt"
	}
	tiers["ultimate-"] = {
		fast = true,
		suffix = "belt"
	}
	tiers["original-ultimate-"] = {
		fast = true,
		suffix = "belt"
	}
end

return tiers