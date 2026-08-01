return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config("omnisharp", {
      cmd = { "omnisharp" },
    })
    vim.lsp.enable("omnisharp")
  end,
}
