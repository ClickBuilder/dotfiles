vim.g.omnisharp_path = "/usr/bin/omnisharp"
vim.g.omnisharp_host = "localhost"
vim.g.omnisharp_port = 2000
vim.g.omnisharp_timeout = 1000

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.cs",
  callback = function()
    vim.cmd("OmniSharpStart")
  end,
})
