return
{
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = require("Neovim_plugins.installLsp"),
                automatic_enable = true
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "mason-org/mason.nvim", "williamboman/mason-lspconfig.nvim" },
        config = function()
            automatic_enable = true
            vim.lsp.enable('lua_ls')
        end
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-path" },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                sources = {
                    { name = "path" },
                },
            })
        end,
    }
}
