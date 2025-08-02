-- Telescope is a highly extensible fuzzy finder for files, commands and more.
-- https://github.com/nvim-telescope/telescope.nvim

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },

  config = function()
    require('telescope').setup {}

    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>s?', builtin.help_tags, { desc = '[S]earch [?]Help' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', function()
      builtin.find_files({
        hidden = true,
        file_ignore_patterns = {
          "%.git/.*",
          "node_modules/.*",
          "%.git/.*",
          "%.DS_Store",
          "dist/.*",
          "build/.*",
          "%.cache/.*",
          "vendor/.*",
          "%.bash_history",
          "%.zsh_history",
          "%.npm/.*",
          "%.yarn/.*",
          "%.env.*"
        }
      })
    end, { desc = '[S]earch [H]idden files' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  end,
}
