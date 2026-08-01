vim.lsp.config('tinymist', {
  cmd = { 'tinymist' },

  filetypes = { 'typ' },

  root_markers = { '.git', 'typst.toml' },

  single_file_support = true,
})

vim.lsp.enable('tinymist')

require 'typst-preview'.setup({
  invert_colors = 'always',
  -- invert_colors = '{"rest": "never","image": "never"}',
})

