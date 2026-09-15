vim.lsp.config('clangd', {
    cmd = { 'clangd', '--background-index', '--clang-tidy', '--limit-results=20' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' , 'ino'}, root_markers = { '.clangd', 'compile_commands.json', 'compile_flags.txt', '.git' },
})
vim.filetype.add({ extension = { ino = "cpp" } })


vim.lsp.enable('clangd')

vim.lsp.enable("lua_ls")

vim.lsp.enable("pyright")

vim.lsp.enable(
    "arduino-language-server"
)

vim.lsp.enable(
    require("Neovim_plugins.installLsp")
)
