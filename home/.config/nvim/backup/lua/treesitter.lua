-- Treesitter is a powerful tool that can be used to parse and highlight code.
-- https://github.com/nvim-treesitter/nvim-treesitter

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  branch = 'master',
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'csv',
      'dockerfile',
      'go',
      'graphql',
      'html',
      'javascript',
      'jsdoc',
      'lua',
      'markdown',
      'proto',
      'query',
      'rust',
      'terraform',
      'tmux',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    local configs = require 'nvim-treesitter.configs'
    -- Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  end,
}

-- Consider if these are needed or if it's covered by go:
-- https://github.com/camdencheek/tree-sitter-go-mod
-- https://github.com/omertuc/tree-sitter-go-work
-- https://github.com/tree-sitter-grammars/tree-sitter-go-sum
