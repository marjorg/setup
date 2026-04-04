return {
  -- Sleuth autoatically adjusts the shiftwidth and tabstop based on the file you are editing, based on the indentation of the file.
  -- https://github.com/tpope/vim-sleuth
  { 'tpope/vim-sleuth' },

  -- Highlight todo, notes, etc in comments
  -- https://github.com/folke/todo-comments.nvim
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Add indentation guides even on blank lines
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  -- See `:help ibl`
  -- TODO: Can we make the lines thinner?
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    ---@module 'ibl'
    ---@type ibl.config
    opts = {},
  },

  -- Conform is a formatter that can run multiple formatters sequentially.
  -- https://github.com/stevearc/conform.nvim
  {
    'stevearc/conform.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          rust = { "rustfmt" },
          go = { "gofmt", "goimports" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    }
  },

  -- Improves viewing Markdown files in Neovim
  -- https://github.com/MeanderingProgrammer/render-markdown.nvim
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  }
}
