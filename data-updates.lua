-- Copyright (c) 2024 lightningund
-- Part of Belt Reskin
--
-- See LICENSE.md in the project directory for license information.

-- Core functions
require("functions")

local tiers = require("tiers")

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
		col = settings.startup[settings_name].value --[[@as Color]]
	else
		col = util.color("ff8000")
	end

	belt_animation_sets[prefix .. properties.suffix] = belt_reskin.transport_belt_animation_set(col, belt_tint, properties.fast)

	local ml_prefix = properties.ml_prefix or prefix

	-- Fetch entities
	local entities = {
		-- Vanilla
		belt = data.raw["transport-belt"][prefix .. properties.suffix],
		belt_item = data.raw["item"][prefix .. properties.suffix],
		splitter = data.raw["splitter"][prefix .. "splitter"],
		splitter_item = data.raw["item"][prefix .. "splitter"],
		underground = data.raw["underground-belt"][prefix .. "underground-belt"],
		underground_item = data.raw["item"][prefix .. "underground-belt"],

		-- Miniloader
		miniloader = data.raw["loader-1x1"][ml_prefix .. "miniloader-loader"],
		miniloader_ins = data.raw["inserter"][ml_prefix .. "miniloader-inserter"],
		miniloader_item = data.raw["item"][ml_prefix .. "miniloader"],
		filter_miniloader = data.raw["loader-1x1"][ml_prefix .. "filter-miniloader-loader"],
		filter_miniloader_ins = data.raw["inserter"][ml_prefix .. "filter-miniloader-inserter"],
		filter_miniloader_item = data.raw["item"][ml_prefix .. "filter-miniloader"],

		-- Deadlock Stacking Beltboxes and Compact loaders
		deadlock_loader = data.raw["loader-1x1"][prefix .. properties.suffix .. "-loader"],
		deadlock_loader_item = data.raw["item"][prefix .. properties.suffix .. "-loader"],
		deadlock_beltbox = data.raw["furnace"][prefix .. properties.suffix .. "-beltbox"],
		deadlock_beltbox_item = data.raw["item"][prefix .. properties.suffix .. "-beltbox"],

		-- AAI Loader
		aai_loader = data.raw["loader-1x1"]["aai-" .. prefix .. "loader"],
		aai_pipe = data.raw["storage-tank"]["aai-" .. prefix .. "loader-pipe"],
		aai_item = data.raw["item"]["aai-" .. prefix .. "loader"],
		aai_tech = data.raw["technology"]["aai-" .. prefix .. "loader"],

		-- Loader Redux
		redux_ent = data.raw["loader"][prefix .. "loader"],
		redux_item = data.raw["item"][prefix .. "loader"],

		-- Vanilla Loaders HD
		vl_ent = data.raw["loader"][ml_prefix .. "loader"],
		vl_item = data.raw["item"][ml_prefix .. "loader"],
	}

	-- Reskin the belts on all related entity types
	for _, entity in pairs(entities) do
		if entity then
			entity.belt_animation_set = belt_animation_sets[prefix .. properties.suffix]
		end
	end

	-- Regroup Vanilla Items (temporary until this all gets moved into functions)
	belt_reskin.regroup_vanilla(entities)

	-- Reskin Vanilla entities and items
	belt_reskin.reskin_vanilla(entities, col)

	-- -- Retint Miniloader
	-- belt_reskin.retint_miniloader(entities, col)

	-- Retint Deadlock loaders
	belt_reskin.retint_deadlock(entities, col)

	-- Retint AAI loaders
	belt_reskin.retint_aai(entities, col)

	-- -- Retint Loader Redux loaders
	-- belt_reskin.retint_loader_redux(entities, col)

	-- Retint Vanilla Loader HD loaders
	belt_reskin.retint_vanilla_loader(entities, col)
end

local v_loader = data.raw["loader-1x1"]["loader-1x1"]
if v_loader then
	v_loader.belt_animation_set = belt_animation_sets["transport-belt"]
end

if mods["miniloader"] then
	local chute = data.raw["loader-1x1"]["chute-miniloader-loader"]
	local chute_itm = data.raw["item"]["chute-miniloader"]
	local chute_rcp = data.raw["recipe"]["chute-miniloader"]

	if chute then
		chute.belt_animation_set = belt_animation_sets["transport-belt"]

		chute_itm.subgroup = "miniloaders"
		chute_itm.order = "e[miniloader]-0[chute]"
		chute_rcp.subgroup = "miniloaders"
		chute_rcp.order = "e[miniloader]-z[chute]"
	end
end