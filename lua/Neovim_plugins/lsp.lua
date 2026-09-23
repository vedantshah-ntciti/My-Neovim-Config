vim.lsp.config('clangd', {
    cmd = { '/usr/bin/clangd', '--background-index', '--clang-tidy', '--limit-results=20' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' ,}, root_markers = { '.clangd', 'compile_commands.json', 'compile_flags.txt', '.git' },
})

vim.filetype.add({
  extension = {
    ino = "arduino",
  },
})

vim.lsp.config('arduino_language_server', require("Neovim_plugins.arduino"))
vim.lsp.enable('arduino_language_server')

vim.lsp.enable("clangd")

vim.lsp.enable("lua_ls")

vim.lsp.enable("pyright")

vim.lsp.enable(
    require("Neovim_plugins.installLsp")
)
