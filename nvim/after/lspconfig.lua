local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("omnisharp", {
  cmd = { "/usr/bin/omnisharp", "--stdio" },
  filetypes = { "cs" },
  capabilities = capabilities,
})

vim.lsp.enable("omnisharp")
-- JavaScript / TypeScript
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
})
vim.lsp.enable("ts_ls")

-- CSS
vim.lsp.config("cssls", {
  capabilities = capabilities,
  filetypes = { "css", "scss" },
})
vim.lsp.enable("cssls")

-- HTML
vim.lsp.config("html", {
  capabilities = capabilities,
  filetypes = { "html" },
})
vim.lsp.enable("html")

-- JSON
vim.lsp.config("jsonls", {
  capabilities = capabilities,
  filetypes = { "json" },
})
vim.lsp.enable("jsonls")
