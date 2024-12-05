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

if mods["space-age"] then
	tiers["turbo-"] = {
		technology = "turbo-transport-belt",
		fast = true,
		suffix = "transport-belt"
	}
end

if mods["UltimateBelts"] then
	tiers["ultra-fast-"] = {
		ml_prefix = "ub-ultra-fast-",
		fast = true,
		suffix = "belt"
	}
	tiers["extreme-fast-"] = {
		ml_prefix = "ub-extreme-fast-",
		fast = true,
		suffix = "belt"
	}
	tiers["ultra-express-"] = {
		ml_prefix = "ub-ultra-express-",
		fast = true,
		suffix = "belt"
	}
	tiers["extreme-express-"] = {
		ml_prefix = "ub-extreme-express-",
		fast = true,
		suffix = "belt"
	}
	tiers["ultimate-"] = {
		ml_prefix = "ub-ultimate-",
		fast = true,
		suffix = "belt"
	}
	tiers["original-ultimate-"] = {
		fast = true,
		suffix = "belt"
	}
end

return tiers