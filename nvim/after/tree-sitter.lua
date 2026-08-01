require("nvim-treesitter.configs").setup({
  -- включить подсветку синтаксиса
  highlight = {
    enable = true,
  },
  -- включить автодополнение
  autotag = {
    enable = true,
  },
  -- включить навигацию по синтаксическому дереву
  navigation = {
    enable = true,
  },
  -- включить поддержку языков программирования
ensure_installed = {
	"lua",
	"javascript",
	"html",
	"css",
	"c",
	"cpp",
  },
})
