require("mux")                  -- terminal multiplexer
require("config.lazy")          -- plugin manager
vim.opt.clipboard = "unnamedplus" -- Wayland clipboard
vim.opt.number = true -- line number
vim.opt.scrolloff = 999
vim.cmd [[source ~/.config/nvim/after/telescope.lua]]   -- fuzzy finder
vim.cmd [[source ~/.config/nvim/after/tree-sitter.lua]] -- syntax highlighting
vim.cmd [[source ~/.config/nvim/after/omnisharp.lua]]   -- C# LSP plugin
vim.cmd [[source ~/.config/nvim/after/lspconfig.lua]]   -- LSP setup
vim.cmd [[source ~/.config/nvim/after/typst.lua]]       -- Typst support
