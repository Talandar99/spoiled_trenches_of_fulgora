local resource_autoplace = require("resource-autoplace")
-- holmium sludge
data:extend({
	{
		type = "fluid",
		subgroup = "fluid",
		name = "holmium-sludge",
		default_temperature = 25,
		base_color = { r = 0.19, g = 0.07, b = 0.17, a = 1.000 },
		flow_color = { r = 0.26, g = 0.1, b = 0.23, a = 1.000 },
		icon = "__spoiled_trenches_of_fulgora__/graphics/holmium-sludge.png",
		icon_size = 64,
		order = "a[fluid]-b[holmium-sludge]",
		pressure_to_speed_ratio = 0.4,
		flow_to_energy_ratio = 0.59,
		auto_barrel = false,
		auto_titanium_barrel = true,
		fuel_value = "0.15MJ",
	},
})

data:extend({
	{
		type = "recipe",
		name = "holmium-ore-from-sludge",
		icon = "__spoiled_trenches_of_fulgora__/graphics/holmium-ore-from-sludge.png",
		icon_size = 64,
		category = "organic-or-chemistry",
		subgroup = "fulgora-processes",
		auto_recycle = false,
		enabled = false,
		allow_productivity = true,
		energy_required = 5,
		ingredients = {
			{ type = "fluid", name = "holmium-sludge", amount = 100 },
			{ type = "item", name = "sulfur", amount = 1 },
		},
		results = {
			{ type = "item", name = "holmium-ore", amount = 1, probability = 0.20 },
			{ type = "item", name = "spoilage", amount = 8 },
		},
		crafting_machine_tint = {
			primary = { r = 0.19, g = 0.07, b = 0.17, a = 1.000 },
			secondary = { r = 0.26, g = 0.1, b = 0.23, a = 1.000 },
			tertiary = { r = 0.19, g = 0.07, b = 0.17, a = 1.000 },
			quaternary = { r = 0.87, g = 0.38, b = 0.50, a = 1.000 },
		},
		main_product = "holmium-ore",
	},
})
local tech = data.raw.technology["recycling"]
if tech and tech.effects then
	table.insert(tech.effects, {
		type = "unlock-recipe",
		recipe = "holmium-ore-from-sludge",
	})
end

table.insert(data.raw.technology["planet-discovery-fulgora"].prerequisites, "deep_sea_oil_extraction")

-- map resource
data:extend({
	{
		type = "autoplace-control",
		name = "holmium-sludge",
		richness = true,
		can_be_disabled = true,
		order = "a-e-b",
		category = "resource",
		icon = "__spoiled_trenches_of_fulgora__/graphics/holmium-sludge.png",
		hidden = true,
	},
	{
		type = "resource-category",
		name = "offshore-fluid",
	},
	{
		type = "resource",
		name = "holmium-sludge",
		collision_mask = { layers = { water_resource = true } },
		icon = "__spoiled_trenches_of_fulgora__/graphics/holmium-sludge.png",
		flags = { "placeable-neutral" },
		category = "offshore-fluid",
		subgroup = "mineable-fluids",
		order = "a-b-b",
		infinite = true,
		highlight = true,
		--minimum = 60000,
		minimum = 100000,
		normal = 250000,
		surface_conditions = {
			{
				property = "pressure",
				min = 800,
				max = 800,
			},
			{
				property = "magnetic-field",
				min = 99,
				max = 99,
			},
		},
		infinite_depletion_amount = 1,
		resource_patch_search_radius = 50,
		minable = {
			mining_time = 1,
			results = {
				{
					type = "fluid",
					name = "holmium-sludge",
					amount_min = 6, --base is 10
					amount_max = 6, --base is 10
					probability = 1,
				},
			},
		},
		map_generator_bounding_box = { { -3.5, -3.5 }, { 3.5, 3.5 } },
		selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
		collision_box = table.deepcopy(data.raw.resource["crude-oil"].collision_box),
		autoplace = resource_autoplace.resource_autoplace_settings({
			name = "holmium-sludge",
			order = "b",
			--base_density = 10,
			base_density = 1,
			base_spots_per_km2 = 1.8,
			--random_probability = 1 / 400,
			random_probability = 1 / 100,
			random_spot_size_minimum = 1, --base 2
			random_spot_size_maximum = 2, --base 4
			additional_richness = 250000,
			has_starting_area_placement = false,
			regular_rq_factor_multiplier = 1,
			planet = "fulgora",
		}),
		stage_counts = { 0 },
		stages = {
			sheet = {
				filename = "__spoiled_trenches_of_fulgora__/graphics/holmium-sludge-stain.png",
				priority = "extra-high",
				width = 260,
				height = 220,
				frame_count = 1,
				variation_count = 1,
				shift = util.by_pixel(0, -2),
				scale = 0.6,
			},
		},
		map_color = { r = 0.88, g = 0.0, b = 0.88 },
		map_grid = false,
	},
})
-- oil rig lightning
data:extend({
	{
		type = "lightning-attractor",
		name = "or_lightning_collector",
		hidden = true,
		flags = { "not-blueprintable", "not-deconstructable", "placeable-off-grid" },
		selectable_in_game = false,
		collision_mask = { layers = {} },
		max_health = 1000,
		efficiency = 0.4,
		range_elongation = 25.0,
		lightning_strike_offset = { 0, -6 },
		energy_source = {
			type = "electric",
			buffer_capacity = "1000MJ",
			usage_priority = "primary-output",
			output_flow_limit = "1000MJ",
			drain = "0W",
		},
		resistances = {
			{ type = "electric", percent = 100 },
			{ type = "fire", percent = 90 },
		},
	},
})

-- remove holmium ore from scrap-recycling
local function remove_result(recipe, item)
	if not recipe or not recipe.results then
		return
	end
	for i = #recipe.results, 1, -1 do
		if recipe.results[i].name == item then
			table.remove(recipe.results, i)
		end
	end
end

remove_result(data.raw.recipe["scrap-recycling"], "holmium-ore")

--allow oil rig to use any fluid as fuel (it needs fuel value in order to not die randomly from lack of energy)
local generator = data.raw["generator"]["or_power_electric"]
if generator and generator.fluid_box then
	generator.fluid_box.filter = nil
	-- increase effectivity to make sure oil rig won't die randomly while mining uranium sludge
	generator.effectivity = 5000
end
