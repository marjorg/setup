-- Add indentation guides even on blank lines
-- https://github.com/lukas-reineke/indent-blankline.nvim
-- See `:help ibl`

-- TODO: Can we make the lines thinner?
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {},
}
