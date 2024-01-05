-- Copyright (c) 2024 lightningund
-- Part of Belt Reskin
--
-- See LICENSE.md in the project directory for license information.

-- Core functions
require("functions")

local tiers = require "tiers"

local belt_animation_sets = {}

local belt_tint = util.color("FFF")

for prefix, properties in pairs(tiers) do
	local settings_name = "belt-reskin-" .. prefix .. "color"

	-- Of course, nothing is sacred, ultimate belts had to be a little bit goofy
	if prefix == "original-ultimate-" then
		settings_name = "belt-reskin-ultimate-color"
	end

	local col ---@type Color
	if settings.startup[settings_name] then
		col = settings.startup[settings_name].value
	else
		col = util.color("ff8000")
	end

	belt_animation_sets[prefix .. properties.suffix] = belt_reskin.transport_belt_animation_set(col, belt_tint, properties.fast)

	local ml_prefix = properties.ml_prefix or prefix

	-- Fetch entities
	local entities = {
		belt = data.raw["transport-belt"][prefix .. properties.suffix],
		splitter = data.raw["splitter"][prefix .. "splitter"],
		underground = data.raw["underground-belt"][prefix .. "underground-belt"],
		loader = data.raw["loader"][prefix .. "loader"],

		-- Miniloader
		miniloader = data.raw["loader-1x1"][ml_prefix .. "miniloader-loader"],
		miniloader_ins = data.raw["loader-1x1"][ml_prefix .. "miniloader-loader-inserter"],
		filter_miniloader = data.raw["loader-1x1"][ml_prefix .. "filter-miniloader-loader"],
		filter_miniloader_ins = data.raw["loader-1x1"][ml_prefix .. "filter-miniloader-loader-inserter"],

		-- Deadlock Stacking Beltboxes and Compact loaders
		deadlock_loader = data.raw["loader-1x1"][prefix .. properties.suffix .. "-loader"],
		deadlock_beltbox = data.raw["furnace"][prefix .. properties.suffix .. "-beltbox"],
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

	-- Retint Miniloader
	if entities.miniloader then
		belt_reskin.retint_mini_loader(entities.miniloader, col)
	end

	-- Retint Filter Miniloader
	if entities.filter_miniloader then
		belt_reskin.retint_mini_loader(entities.filter_miniloader, col)
	end

	-- Retint Deadlock Loader
	if entities.deadlock_loader then
		belt_reskin.retint_deadlock_loader(entities.deadlock_loader, col)
	end

	-- Retint Deadlock Beltbox
	if entities.deadlock_beltbox then
		belt_reskin.retint_deadlock_beltbox(entities.deadlock_beltbox, col)
	end
end

if mods["miniloader"] then
	local chute = data.raw["loader-1x1"]["chute-miniloader-loader"]

	if chute then
		chute.belt_animation_set = belt_animation_sets["transport-belt"]
	end
end