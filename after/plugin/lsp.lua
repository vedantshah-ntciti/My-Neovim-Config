vim.o.autocomplete = true

vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy', 'popup' }

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local ev = args
        local opts = { buffer = args.buf }

        -- Keymaps
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        -- Enable auto-completion
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

-- Trigger completion manually with <C-Space>
vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { desc = 'Completion: trigger' })

-- Confirm selection with <C-y>
vim.keymap.set('i', '<C-y>', function()
    if vim.fn.pumvisible() == 1 then
        if vim.fn.complete_info()['selected'] ~= -1 then
            return '<C-y>'
        else
            return '<C-n><C-y>'
        end
    else
        return '<C-y>'
    end
end, { expr = true, desc = 'Completion: confirm' })
