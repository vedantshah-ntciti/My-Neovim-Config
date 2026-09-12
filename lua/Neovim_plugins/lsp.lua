vim.lsp.config('clangd', {
    cmd = { 'clangd', '--background-index', '--clang-tidy', '--limit-results=20' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' }, root_markers = { '.clangd', 'compile_commands.json', 'compile_flags.txt', '.git' },
})

vim.lsp.enable('clangd')

vim.lsp.enable("lua_ls")

vim.lsp.enable("pyright")

vim.lsp.enable(
    require("Neovim_plugins.installLsp")
)
