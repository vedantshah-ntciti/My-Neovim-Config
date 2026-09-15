local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup()

            require("nvim-treesitter").install({
                "lua", "vim", "vimdoc", "bash", "python",
                "c", "cpp", "javascript", "html", "css",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "lua", "vim", "bash", "python",
                    "c", "cpp", "javascript", "html", "css",
                },
                callback = function()
                    vim.treesitter.start()
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end
    },

    {
        'theprimeagen/harpoon'
    },

    {
        'tpope/vim-fugitive'
    },

    require("Neovim_plugins.lsp-config"),
    require("Neovim_plugins.autocomplete"),
    {
        "catppuccin/nvim",
        name = "catppuccin-nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin-nvim")
        end
    }

}
local opts = {}

require("lazy").setup(plugins, opts)
