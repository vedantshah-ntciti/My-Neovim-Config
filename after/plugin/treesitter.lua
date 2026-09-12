config = function()
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "vim", "vimdoc", "bash", "python", "c", "cpp", "javascript", "html", "css" },
  highlight = { enable = true },
  indent = { enable = true },
})
end
