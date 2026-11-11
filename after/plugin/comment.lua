local config = function()
    local opts = {
        -- -Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
            ---Line-comment toggle keymap
            line = '<leader>cm',
            ---Block-comment toggle keymap
            block = '<leader>bm',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            ---Line-comment keymap
            line = '<leader>c',
            ---Block-comment keymap
            block = '<leader>b',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = true,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = false,
        },
        ---Function to call before (un)comment
        pre_hook = function(ctx)
            if vim.bo.filetype == 'arduino' then
                return vim.bo.commentstring -- "// %s" from your arduino autocmd
            end
            return require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()(ctx)
        end,
        ---Function to call after (un)comment
        post_hook = nil,
    }
    require('Comment').setup(opts)
end

config()
