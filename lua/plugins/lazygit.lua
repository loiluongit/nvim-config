return {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    { '<leader>gf', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit (current file)' },
  },
  config = function()
    -- Safety net: if terminal-mode is exited (e.g. via <Esc>), `q` in normal
    -- mode over the lazygit buffer force-closes the floating window instead
    -- of doing nothing (or starting macro recording).
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'lazygit',
      callback = function(event)
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
      end,
    })
  end,
}
