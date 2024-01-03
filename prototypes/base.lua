-- Copyright (c) 2024 lightningund
-- Part of Belt Reskin
--
-- See LICENSE.md in the project directory for license information.

local tiers = require "tiers"

local belt_animation_sets = {}

local belt_tint = util.color("FFF")

for prefix, properties in pairs(tiers) do
	local settings_name = "belt-reskin-" .. prefix .. "color"

	-- Of course, nothing is sacred, ultimate belts had to be a little bit goofy
	if prefix == "original-ultimate-" then
		settings_name = "belt-reskin-ultimate-color"
	end

	local col
	if settings.startup[settings_name] then
		col = settings.startup[settings_name].value
	else
		col = util.color("ff8000")
	end

	belt_animation_sets[prefix .. properties.suffix] = belt_reskin.transport_belt_animation_set(col, belt_tint, properties.fast)

	-- Fetch entities
	local entities = {
		belt = data.raw["transport-belt"][prefix .. properties.suffix],
		splitter = data.raw["splitter"][prefix .. "splitter"],
		underground = data.raw["underground-belt"][prefix .. "underground-belt"],
		loader = data.raw["loader"][prefix .. "loader"],

		-- Miniloader
		miniloader = data.raw["loader-1x1"][prefix .. "miniloader-loader"],
		filter_miniloader = data.raw["loader-1x1"][prefix .. "filter-miniloader-loader"],

		-- Deadlock Stacking Beltboxes and Compact loaders
		deadlock_loader = data.raw["loader-1x1"][prefix .. properties.suffix .. "-loader"],
		deadlock_beltbox = data.raw["furnace"][prefix .. properties.suffix .. "-beltbox"],

		-- Krastorio
		krastorio_loader = data.raw["loader-1x1"]["kr-" .. prefix .. "loader"],
	}

	-- Reskin the belts on all related entity types
	for _, entity in pairs(entities) do
		if entity then
			entity.belt_animation_set = belt_animation_sets[prefix .. properties.suffix]
		end
	end

	-- Reskin the belt icon
	if entities.belt then
		local icons = belt_reskin.transport_belt_icon(col)
		entities.belt.icons = icons

		-- And the item to match
		local belt_item = data.raw["item"][prefix .. properties.suffix]
		if belt_item then
			belt_item.icons = icons
		end
	end

	-- Reskin the Underground
	if entities.underground then
		entities.underground.structure = belt_reskin.underground_belt_sprite_set(col)
	end

	-- Reskin the Splitter
	if entities.splitter then
		belt_reskin.splitter_sprite_set(entities.splitter, col)
	end

	-- Retint Deadlock Loader
	if entities.deadlock_loader then
		belt_reskin.retint_deadlock_loader(entities.deadlock_loader, col)
	end

	-- Retint Deadlock Beltbox
	if entities.deadlock_beltbox then
		belt_reskin.retint_deadlock_beltbox(entities.deadlock_beltbox, col)
	end

	-- Retint Miniloader
	if entities.miniloader then
		belt_reskin.retint_mini_loader(entities.miniloader, col)
	end

	-- Retint Filter Miniloader
	if entities.filter_miniloader then
		belt_reskin.retint_mini_loader(entities.filter_miniloader, col)
	end

	-- -- Setup remnants
	-- local remnants = data.raw["corpse"][prefix .. "transport-belt-remnants"]

	-- if remnants then
	-- 	if entities.belt then
	-- 		remnants.icons = entities.belt.icons
	-- 		remnants.icon = entities.belt.icon
	-- 		remnants.icon_size = entities.belt.icon_size
	-- 	end

	-- 	remnants.animation = make_rotated_animation_variations_from_sheet(2, {
	-- 		filename = "__prismatic-belts__/graphics/entity/base/" .. prefix .. "transport-belt/remnants/" .. prefix .. "transport-belt-remnants.png",
	-- 		line_length = 1,
	-- 		width = 54,
	-- 		height = 52,
	-- 		frame_count = 1,
	-- 		variation_count = 1,
	-- 		axially_symmetrical = false,
	-- 		direction_count = 4,
	-- 		shift = util.by_pixel(1, 0),
	-- 		hr_version = {
	-- 			filename = "__prismatic-belts__/graphics/entity/base/" .. prefix .. "transport-belt/remnants/hr-" .. prefix .. "transport-belt-remnants.png",
	-- 			line_length = 1,
	-- 			width = 106,
	-- 			height = 102,
	-- 			frame_count = 1,
	-- 			variation_count = 1,
	-- 			axially_symmetrical = false,
	-- 			direction_count = 4,
	-- 			shift = util.by_pixel(1, -0.5),
	-- 			scale = 0.5
	-- 		}
	-- 	})
	-- end

	-- -- Setup logistics technologies
	-- local technology = data.raw["technology"][properties.technology]

	-- if technology then
	-- 	local icons = {
	-- 		{
	-- 			icon = "__prismatic-belts__/graphics/technology/base/" .. properties.technology .. ".png",
	-- 			icon_size = 256,
	-- 			icon_mipmaps = 4,
	-- 		}
	-- 	}

	-- 	technology.icons = icons
	-- end
end

if mods["miniloader"] then
	local chute = data.raw["loader-1x1"]["chute-miniloader-loader"]

	if chute then
		chute.belt_animation_set = belt_animation_sets["transport-belt"]
	end
end