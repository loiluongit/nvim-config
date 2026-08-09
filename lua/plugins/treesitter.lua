return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'lua', 'vim', 'vimdoc', 'query',
        'bash', 'json', 'yaml', 'markdown', 'markdown_inline',
        'javascript', 'typescript', 'tsx', 'html', 'css',
        'python', 'go', 'rust',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
}
