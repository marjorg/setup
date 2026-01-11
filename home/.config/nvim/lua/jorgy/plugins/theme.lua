-- Tokyo Night is a clean and elegant color scheme
-- https://github.com/folke/tokyonight.nvim

return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require('tokyonight').setup {
        style = 'night',
        transparent = true,
      }

      vim.cmd [[colorscheme tokyonight]]
    end,
  },
}
