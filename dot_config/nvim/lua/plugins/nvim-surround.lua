---@type LazySpec
return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  init = function()
    -- nvim-surround v4 no longer accepts keymaps in setup().
    vim.g.nvim_surround_no_insert_mappings = true
    vim.g.nvim_surround_no_visual_mappings = true
  end,
  keys = {
    {
      "gs",
      "<Plug>(nvim-surround-visual)",
      mode = "x",
      desc = "Add surround around selection",
    },
    {
      "gS",
      "<Plug>(nvim-surround-visual-line)",
      mode = "x",
      desc = "Add surround around selection on new lines",
    },
  },
  opts = {},
}
