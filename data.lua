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
		range_elongation = 50.0,
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
