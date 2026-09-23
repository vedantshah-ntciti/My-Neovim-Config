vim.api.nvim_create_autocmd('FileType', {
    pattern = 'arduino',
    group = vim.api.nvim_create_augroup('my.arduino', { clear = true }),
    callback = function(args)
        local opts = { buffer = args.buf, silent = true }

        -- Board FQBN: override per-project with vim.g.arduino_fqbn
        local fqbn = vim.g.arduino_fqbn or 'esp8266:esp8266:nodemcuv2'

        -- Auto-detect port from arduino-cli; falls back to vim.g.arduino_port or default
        local function get_port()
            local handle = io.popen('arduino-cli board list --format json 2>/dev/null')
            if not handle then
                return vim.g.arduino_port or '/dev/ttyUSB0'
            end
            local result = handle:read('*a')
            handle:close()
            local ok, data = pcall(vim.json.decode, result)
            if ok and data and data[1] and data[1].port and data[1].port.address then
                return data[1].port.address
            end
            return vim.g.arduino_port or '/dev/ttyUSB0'
        end

        vim.keymap.set('n', '<leader>ac', function()
            vim.cmd('!arduino-cli compile --fqbn ' .. fqbn .. ' ' .. vim.fn.expand('%:p:h'))
        end, vim.tbl_extend('force', opts, { desc = 'Arduino: Compile' }))

        vim.keymap.set('n', '<leader>au', function()
            local port = get_port()
            vim.cmd('!arduino-cli compile --fqbn ' .. fqbn .. ' --upload -p ' .. port .. ' ' .. vim.fn.expand('%:p:h'))
        end, vim.tbl_extend('force', opts, { desc = 'Arduino: Compile + Upload' }))

        vim.keymap.set('n', '<leader>sm', function()
            local port = get_port()
            vim.cmd('!arduino-cli monitor -p ' .. port)
        end, vim.tbl_extend('force', opts, { desc = 'Arduino: Serial Monitor' }))

        vim.keymap.set('n', '<leader>bl', function()
            vim.cmd('!arduino-cli board list')
        end, vim.tbl_extend('force', opts, { desc = 'Arduino: List Boards' }))

        vim.keymap.set('n', '<leader>fqb', function()
            vim.ui.input({ prompt = 'FQBN: ', default = fqbn }, function(input)
                if input and input ~= '' then
                    fqbn = input
                    vim.g.arduino_fqbn = input
                end
            end)
        end, vim.tbl_extend('force', opts, { desc = 'Arduino: Set FQBN' }))
    end,
})
