-- Lazydev configures Lua LSP for your Neovim config, runtime and plugins used for completion, annotations and signatures of Neovim apis
-- https://github.com/folke/lazydev.nvim

return {
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    },
  },
  dependencies = {
    { 'Bilal2453/luvit-meta', lazy = true }
  },
}
