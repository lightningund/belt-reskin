data:extend({
	{
		type = "color-setting",
		name = "belt-reskin-color",
		setting_type = "startup",
		default_value = {210, 180, 80},
		order = "0a"
	},
	{
		type = "color-setting",
		name = "belt-reskin-fast-color",
		setting_type = "startup",
		default_value = {210, 60, 60},
		order = "0b"
	},
	{
		type = "color-setting",
		name = "belt-reskin-express-color",
		setting_type = "startup",
		default_value = {80, 180, 209},
		order = "0c"
	},
})

data:extend({
	{
		type = "bool-setting",
		name = "belt-reskin-regroup",
		setting_type = "startup",
		default_value = true,
		order = "00",
	}
})

if mods["UltimateBelts"] then
	local ub_tiers = {
		{
			type = "color-setting",
			name = "belt-reskin-ultra-fast-color",
			setting_type = "startup",
			default_value = {0, 179, 12},
			order = "1a"
		},
		{
			type = "color-setting",
			name = "belt-reskin-extreme-fast-color",
			setting_type = "startup",
			default_value = {224, 0, 0},
			order = "1b"
		},
		{
			type = "color-setting",
			name = "belt-reskin-ultra-express-color",
			setting_type = "startup",
			default_value = {54, 4, 181},
			order = "1c"
		},
		{
			type = "color-setting",
			name = "belt-reskin-extreme-express-color",
			setting_type = "startup",
			default_value = {0, 43, 255},
			order = "1d"
		},
		{
			type = "color-setting",
			name = "belt-reskin-ultimate-color",
			setting_type = "startup",
			default_value = {0, 255, 221},
			order = "1e"
		}
	}

	if mods["UltimateBelts_Owoshima_And_Pankeko-Mod"] then
		-- Pankeko UB colors
		ub_tiers[1].default_value = {43, 194, 75}
		ub_tiers[2].default_value = {196, 99, 47}
		ub_tiers[3].default_value = {111, 45, 224}
		ub_tiers[4].default_value = {61, 58, 240}
		ub_tiers[5].default_value = {153, 153, 153}
	end

	data:extend(ub_tiers)
end