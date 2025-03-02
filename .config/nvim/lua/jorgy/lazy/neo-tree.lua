-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>e', ':Neotree toggle<CR>', desc = 'NeoTree toggle' },
  },
  opts = {
    filesystem = {
      hijack_netrw_behavior = 'open_current',
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      }
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- Make background transparent and border right
    vim.cmd([[
      highlight! link NeoTreeNormal Normal
      highlight! link NeoTreeNormalNC Normal
      highlight WinSeparator guifg=#5f5f5f gui=nocombine
    ]])
  end,
}
