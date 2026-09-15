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

