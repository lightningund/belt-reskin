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

if mods["UltimateBelts"] then
	data:extend({
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
		},
		{
			type = "color-setting",
			name = "belt-reskin-original-ultimate-color",
			setting_type = "startup",
			default_value = {0, 255, 221},
			order = "1f"
		}
	})
end