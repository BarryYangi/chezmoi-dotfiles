local wezterm = require("wezterm")
local config = {
	font = wezterm.font("Maple Mono NF CN", { weight = "Regular" }),
	font_size = 13.0,
	color_scheme = "Catppuccin Mocha",
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	window_decorations = "RESIZE",
	show_new_tab_button_in_tab_bar = false,
	window_background_opacity = 0.6,
	macos_window_background_blur = 45,
	text_background_opacity = 0.9,
	adjust_window_size_when_changing_font_size = false,
	window_close_confirmation = "NeverPrompt",
	initial_rows = 32,
	initial_cols = 120,
	window_padding = {
		left = 20,
		right = 20,
		top = 20,
		bottom = 5,
	},
}

return config
